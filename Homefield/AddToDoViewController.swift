//
//  AddToDoViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 07/05/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
class AddToDoViewController: UIViewController {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var toDoDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveToDoButton: UIButton!
    let ref = Firebase(url:"https://homefield.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.underLinesStyleForTextField(toDoDescription)
        appDelegate.setButtonStyle(saveToDoButton)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    @IBAction func saveToDoButtonAction(sender: AnyObject) {
        saveToDo(self.toDoDescription.text!, toDoDate: 0.0)
    }
    
    func saveToDo(todoDescription:String,toDoDate:NSTimeInterval){
        let activityDetails=[
            "description":toDoDescription.text as NSString!,
            "type":"activity",
            "createdAt": datePicker.date.timeIntervalSince1970,
            ]
        let homeid:String = appDelegate.currentUser["home"]!
        let activityRef = ref.childByAppendingPath("task").childByAppendingPath(homeid)
        activityRef.childByAutoId().setValue(activityDetails)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func dateChanged(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        
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
