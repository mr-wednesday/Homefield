//
//  ViewController.swift
//  Homefield
//
//  Created by Ugur Bastug, Edited By Niroshan on 23/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPass: UIButton!
    var EmailCore = [NSManagedObject]()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var calledOnce:Bool=false
    
    var managedContext: NSManagedObjectContext!
    var people = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        if(!calledOnce){
            FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
                if let user = user {
                    print("User is signed in with uid:", user.uid)
                    self.getUserData()
                    let managedContext = self.appDelegate.managedObjectContext
                    
                    let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
                    let email = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    
                    email.setValue(self.emailTextfield.text!, forKey: "emailAddress")
                    
                    do {
                        try managedContext.save()
                        self.EmailCore.append(email)
                        
                    } catch let error as NSError {
                        print("Could not store\(error), \(error.userInfo)")
                    }
                    
                } else {
                    print("No user is signed in.")
                    self.getEmailFromCoreData()
                    let currentUser = self.people.last
                    if((currentUser?.valueForKey("emailAddress")) != nil){
                        self.emailTextfield.text = currentUser?.valueForKey("emailAddress") as! String!
                    }else{
                        print("No email address found in core data")
                    }
                }
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewDidAppear(animated: Bool) {
        self.buttonStyles()

    }
    func getEmailFromCoreData() {
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
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
        //self.setButtonStyle(forgotPass)
        self.underLinesStyleForTextField(emailTextfield)
        self.underLinesStyleForTextField(passwordTextField)
        self.underLinesStyleForTextField(usernameTextField)
        
    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape")
            buttonStyles()
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait")
            buttonStyles()

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
        if(usernameTextField.hidden){
            usernameTextField.hidden=false
            self.loginButton.hidden=true
            self.registerButton.setTitle("Continue", forState: UIControlState.Normal)
        }else{
            FIRAuth.auth()?.createUserWithEmail(self.emailTextfield.text!, password: self.passwordTextField.text!) { (user, error) in
                // ...
                if error == nil {
                    // 3
                    
                    var ref = FIRDatabase.database().reference()
                    
                    let userRef = ref.child("user").child((FIRAuth.auth()?.currentUser?.uid)!)
                    userRef.child("username").setValue(self.usernameTextField.text!)
                    userRef.child("email").setValue(self.emailTextfield.text!)
                    
                    self.login(self)
                    // DONOT LOGIN INVOKES GET USER DATA NOOO
                    
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
        var ref = FIRDatabase.database().reference()
        
        ref.child("user").child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: { snapshot in
            self.appDelegate.currentUser.username=snapshot.value?.objectForKey("username") as! String!
            self.appDelegate.currentUser.email=snapshot.value?.objectForKey("username") as! String!
            self.appDelegate.currentUser.homeId=snapshot.value?.objectForKey("home") as! String!
            self.appDelegate.currentUser.uid=FIRAuth.auth()?.currentUser?.uid
            
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
        if((appDelegate.currentUser.homeId) != nil){
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

