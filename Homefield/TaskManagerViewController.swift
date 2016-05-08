//
//  TaskManagerViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
class TaskManagerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var taskBackgroundView: UIView!
    @IBOutlet weak var savePaymentButton: UIButton!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ref = Firebase(url:"https://homefield.firebaseio.com/")
    var paymentTodos = [String:AnyObject!]()
    var paymentTodoKeys = [AnyObject]()
    let ip = NSIndexPath.init(forItem: 0, inSection: 0)

    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var addToDoActionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getPaymentToDos()
        self.addToDoActionButton.hidden=true
        self.tableView.registerNib(UINib(nibName: "TaskItemTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskItem")
        appDelegate.setButtonStyle(savePaymentButton)
        appDelegate.setButtonStyle(addToDoActionButton)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentedControlAction(sender: AnyObject) {
        let firstCell:TaskItemTableViewCell = self.tableView.cellForRowAtIndexPath(ip) as! TaskItemTableViewCell

        if(self.segmentedControl.selectedSegmentIndex==0){
            //we are dealing with payment
            self.savePaymentButton.setTitle("SAVE PAYMENT", forState: UIControlState.Normal)
            self.taskTextField.hidden=false
            self.taskBackgroundView.backgroundColor=UIColor.whiteColor()
            firstCell.taskTextField.placeholder="Enter new payment description. Ex: paid the rent."
            self.addToDoActionButton.hidden=true
        }else{
            //we are dealing with activity
            self.savePaymentButton.setTitle("SAVE ACTIVITY", forState: UIControlState.Normal)
            self.taskTextField.hidden=true
            self.taskBackgroundView.backgroundColor=appDelegate.appColor
            firstCell.taskTextField.placeholder="Enter new activity description. Ex: washed the dishes."
            self.addToDoActionButton.hidden=false

        }
    }
    
    @IBAction func savePaymentAction(sender: AnyObject) {
        let firstCell:TaskItemTableViewCell = self.tableView.cellForRowAtIndexPath(ip) as! TaskItemTableViewCell
        self.savePayment(self.taskTextField.text!, paymentDescription: firstCell.taskTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTodos.count+1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TaskItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath) as! TaskItemTableViewCell
        if(indexPath.row==0){
            cell.taskTextField.delegate=self
            cell.todoLabel.hidden=true
        }else{
            let paymentTodoKey = self.paymentTodoKeys[indexPath.row] as! String
            let paymentTodoObject = self.paymentTodos[paymentTodoKey]
            cell.detailTextLabel?.text = paymentTodoObject!["description"] as! String!
        }
        
        return cell
        
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:TaskItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath) as! TaskItemTableViewCell
        if(indexPath.row==0){
            
        }else{
            let alert = UIAlertController()
            alert.title = "Task"
            alert.message = "Do you really want to pay \(taskTextField.text!) for \(cell.taskTextField.text!)"
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:{(alert :UIAlertAction!) in
                //self.uploadBalance(self.taskTextField.text!, paymentDescription: cell.taskTextField.text!)
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
    }
    func savePayment(paymentAmount: String, paymentDescription: String){
        if (self.savePaymentButton.currentTitle=="SAVE PAYMENT") {
            let paymentDetails=[
                "doneBy":ref.authData.uid,
                "description":paymentDescription,
                "amount": paymentAmount,
                "type":"payment",
                "username":appDelegate.currentUser["username"] as String!,
                "createdAt": NSDate().timeIntervalSince1970,
                ]
            let homeid:String = appDelegate.currentUser["home"]!
            let paymentRef = ref.childByAppendingPath("task").childByAppendingPath(homeid)
            
            paymentRef.childByAutoId().setValue(paymentDetails)
        }
        if(self.savePaymentButton.currentTitle=="SAVE ACTIVITY"){
            let activityDetails=[
                "doneBy":ref.authData.uid,
                "description":paymentDescription,
                "type":"activity",
                "username":appDelegate.currentUser["username"] as String!,
                "createdAt": NSDate().timeIntervalSince1970,
                ]
            let homeid:String = appDelegate.currentUser["home"]!
            let activityRef = ref.childByAppendingPath("task").childByAppendingPath(homeid)
            activityRef.childByAutoId().setValue(activityDetails)
        }

        
        
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    func getActivities(){
        let homeid:String = appDelegate.currentUser["home"]!
        let tasksForHome = ref.childByAppendingPath("task").childByAppendingPath(homeid)
        
        tasksForHome.observeSingleEventOfType(.Value,withBlock: { snapshot in
            self.paymentTodos=snapshot.value as! [String:AnyObject!]
            var keys = Array(self.paymentTodos.keys)
            self.paymentTodoKeys=keys
            
            self.tableView.reloadData()
        })
        
    }
    func getPaymentToDos(){
        let homeid:String = appDelegate.currentUser["home"]!
        let paymentRef = ref.childByAppendingPath("task").childByAppendingPath("payment").childByAppendingPath(homeid).childByAppendingPath("todos")
        
        paymentRef.observeSingleEventOfType(.Value,withBlock: { snapshot in
            self.paymentTodos=snapshot.value as! [String:AnyObject!]
            var keys = Array(self.paymentTodos.keys)
            self.paymentTodoKeys=keys
            
            self.tableView.reloadData()
        })
        
        
        
    }
    func savePaymentToDos(){
        let homeid:String = appDelegate.currentUser["home"]!
        let paymentRef = ref.childByAppendingPath("task").childByAppendingPath(homeid).childByAutoId()
        
        paymentRef.setValue(["description":"Rent","type":"payment"])
        
        
        
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
