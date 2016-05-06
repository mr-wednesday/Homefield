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

    let ref = Firebase(url:"https://homefield.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if ref.authData != nil {
            // user authenticated
            getUserData()
            print("segue")
        } else {
            // No user is signed in
        }
    }
    @IBAction func register(sender: AnyObject) {
        
        ref.authUser(self.emailTextfield.text, password:self.passwordTextField.text) {
            error, authData in
            if error != nil {
                // Something went wrong. :(
            } else {
                // Authentication just completed successfully :)
                // The logged in user's unique identifier
                // Create a new user dictionary accessing the user's info
                // provided by the authData parameter
                let newUser = [
                    "provider": authData.provider,
                    "username": self.usernameTextField.text,
                    "email": self.emailTextfield.text
                ]
                self.login(self)
                // Create a child path with a key set to the uid underneath the "users" node
                // This creates a URL path like the following:
                //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                self.ref.childByAppendingPath("user")
                    .childByAppendingPath(authData.uid).setValue(newUser)
            }
        }
        
    }
    
    
    @IBAction func login(sender: AnyObject) {
        ref.authUser(emailTextfield.text, password: passwordTextField.text,
            withCompletionBlock: { error, authData in
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
        ref.childByAppendingPath("user").childByAppendingPath(ref.authData.uid).observeEventType(.Value, withBlock: { snapshot in
            self.appDelegate.currentUser=snapshot.value as! [String:String!]
            if(self.checkIfUserHasHome()){
                print("guy has a home")
                self.performSegueWithIdentifier("navigationSegue", sender: nil)

            }else{
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

