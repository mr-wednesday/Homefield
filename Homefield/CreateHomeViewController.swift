//
//  CreateHomeViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 23/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
class CreateHomeViewController: UIViewController ,UITextFieldDelegate{
    let ref = FIRDatabase.database().reference()
    var userData = [String: String]()
    var option:String=""
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var homeIdTextField: UITextField!
    
    @IBOutlet weak var registerHomeButton: UIButton!
    @IBOutlet weak var homeNameTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    var appDelegate=AppDelegate() //You create a new instance,not get the exist one
    var homeIsValid=true
    var uid = FIRAuth.auth()?.currentUser?.uid
    //TODO CHECK
    @IBAction func registerExistingHomeClick(sender: AnyObject) {
        
        if(self.registerHomeButton.currentTitle=="This is the home."){
            //Register the home to the user class
            if(homeIsValid){
                let id = self.homeIdTextField.text
                let base = ref.child("home").child(id!).child("members")
                base.childByAutoId().setValue(uid)
                //Register the user to the home class
                let homeData = [
                    "home": id!
                ]
                self.ref.child("user")
                    .child(uid!).updateChildValues(homeData)
                appDelegate.currentUser.homeId = id
                self.performSegueWithIdentifier("launchTaskSegue", sender: self)
            }
            
        }else{
            self.registerHomeButton.setTitle("This is the home.", forState: UIControlState.Normal)
            self.homeIdTextField.hidden=false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeIdTextField.hidden=true
        appDelegate.underLinesStyleForTextField(homeIdTextField)
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.welcomeLabel.text="Hi \(appDelegate.currentUser.username)!"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func createNewHomeAction(sender: AnyObject) {
        self.homeNameTextField.hidden=false;
        self.rentTextField.hidden=false;
        createNewHome()
    }
    
    
    func createNewHome(){
        
        var homeRef = ref.child("home")
        homeRef = homeRef.childByAutoId()
        
        let homeMembersInit = NSArray.init(object: uid!)
        let homeData:[String:AnyObject] = ["name": self.homeNameTextField.text!,"rent":rentTextField.text!,"members":homeMembersInit];
        homeRef.setValue(homeData)
        
        self.ref.child("user")
            .child(uid!).child("home").setValue(homeRef.key)
        appDelegate.currentUser.homeId = homeRef.key
        self.performSegueWithIdentifier("launchTaskSegue", sender: self)
        
        
        /*
         homeRef.setValue(homeData, withCompletionBlock: {
         (error:NSError?, ref:Firebase!) in
         if (error != nil) {
         print("Data could not be saved.")
         } else {
         print("Data saved successfully!")
         }
         })
         */
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
