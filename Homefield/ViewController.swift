//
//  ViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 23/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPass: UIButton!
    
    
    
    
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var ref = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func underLinesStyleForTextField(textField:UITextField){
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height)
        border.borderWidth = borderWidth
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
    }
    func setButtonStyle(button:UIButton){
        button.layer.borderColor=UIColor.whiteColor().CGColor
        button.layer.borderWidth=1.2
        button.layer.cornerRadius=16
        button.layer.masksToBounds=true
    }
    func buttonStyles(){
        self.setButtonStyle(registerButton)
        self.setButtonStyle(loginButton)
        self.setButtonStyle(forgotPass)
        self.underLinesStyleForTextField(emailTextfield)
        self.underLinesStyleForTextField(passwordTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        self.buttonStyles()
        FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
            if let user = user {
                print("User is signed in with uid:", user.uid)
                self.getUserData()

            } else {
                print("No user is signed in.")
            }
        }
    }
    @IBAction func register(sender: AnyObject) {
        if(usernameTextField.hidden){
            usernameTextField.hidden=false
        }else{
            FIRAuth.auth()?.createUserWithEmail(self.emailTextfield.text!, password: self.passwordTextField.text!) { (user, error) in
                // ...
                if error == nil {
                    // 3
                    let newUser = [
                        //"provider": self.ref.authData.provider,
                        "username": self.usernameTextField.text,
                        "email": self.emailTextfield.text
                    ]
                    
                    //SAVE USER DETAILS
                    
                    //self.ref.childByAppendingPath("user").childByAppendingPath(FIRAuth.auth()?.currentUser?.uid).setValue(newUser)
                    self.login(self)

                }
            }
            
            
        }
        
        
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(emailTextfield.text!, password: passwordTextField.text!,
                                        completion: { error, authData in
                        if error != nil {
                            // There was an error logging in to this account
                            print(error)
                        } else {
                            print("successfully logged in")
                            // Get a reference to our posts
                            self.getUserData()
                            // We are now logged in
                        }
        })
    }
    
    func getUserData(){
        // Retrieve new posts as they are added to your database
        ref.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: { snapshot in
            self.appDelegate.currentUser=snapshot.value as! [String:String!]
            if(self.checkIfUserHasHome()){
                print("guy has a home")
                self.performSegueWithIdentifier("navigationSegue", sender: nil)
                
            }else{
                print("no home register or create screen")
                self.performSegueWithIdentifier("createHome", sender: nil)
            }
            
        })
        
    }
    
    func checkIfUserHasHome()->Bool{
        if((appDelegate.currentUser["home"]) != nil){
            return true
        }else{
            return false
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let crvc = segue.destinationViewController as! CreateHomeViewController;
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

