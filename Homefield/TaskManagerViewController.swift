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
    
    var allTasks = [Task]()
    var toDoTasks = [Task]()
    
    
    func getToDoTasks(){
        for task in allTasks{
            if ((task.doneBy == nil)){
                //if task is not created so it is a todo item.
                toDoTasks.append(task)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getToDoTasks()
        
        self.addToDoActionButton.hidden=true
        self.tableView.registerNib(UINib(nibName: "TaskItemTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskItem")
        appDelegate.setButtonStyle(savePaymentButton,borderColor: UIColor.whiteColor())
        appDelegate.setButtonStyle(addToDoActionButton,borderColor: UIColor.whiteColor())
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
        self.tableView.reloadData()
    }
    
    @IBAction func savePaymentAction(sender: AnyObject) {
        let firstCell:TaskItemTableViewCell = self.tableView.cellForRowAtIndexPath(ip) as! TaskItemTableViewCell
        self.saveTask(self.taskTextField.text!, paymentDescription: firstCell.taskTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControl.selectedSegmentIndex==0){
            return 1
        }else{
            return toDoTasks.count+1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TaskItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath) as! TaskItemTableViewCell
        if(indexPath.row==0){
            cell.taskTextField.delegate=self
            cell.todoLabel.hidden=true
        }else{
            //OKAY THESE ARE TODO ACTIVITY ITEMS SO BE CAREFUL PLS - UGUR
            if(segmentedControl.selectedSegmentIndex==1){
                let toDoTask = toDoTasks[indexPath.row-1]
                cell.taskTextField?.text = toDoTask.description
                cell.taskTextField.userInteractionEnabled=false
            }

        }
        
        return cell
        
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell:TaskItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath) as! TaskItemTableViewCell
        if(indexPath.row==0){
            //NO ACTION FOR THE FIRST ONE BECAUSE IT IS MANUAL...
        }else{
            let toDoTask = toDoTasks[indexPath.row-1]

            let alert = UIAlertController()
            alert.title = "Task"
            alert.message = "Did you really did the activity: \(toDoTask.description)"
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:{(alert :UIAlertAction!) in
                self.markTodoAsDone(toDoTask)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
    }
    
    func markTodoAsDone(task: Task){
        let taskRef = Firebase.init(url: task.ref)
        
        let updates = ["doneBy": ref.authData.uid,
                       "username":appDelegate.currentUser["username"] as String!
        ]

        taskRef.updateChildValues(updates)
    }
    
    func saveTask(paymentAmount: String, paymentDescription: String){
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


    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
