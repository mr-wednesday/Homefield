//
//  TaskManagerViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
class TaskManagerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ref = Firebase(url:"https://homefield.firebaseio.com/")
    var paymentTodos = [String:AnyObject!]()
    var paymentTodoKeys = [AnyObject]()
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentToDos()
        self.tableView.registerNib(UINib(nibName: "TaskItemTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskItem")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTodos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath)
        let paymentTodoKey = self.paymentTodoKeys[indexPath.row] as! String
        let paymentTodoObject = self.paymentTodos[paymentTodoKey]
        cell.detailTextLabel?.text = paymentTodoObject!["description"] as! String!
        return cell
        
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:TaskItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("TaskItem", forIndexPath: indexPath) as! TaskItemTableViewCell
        
        let alert = UIAlertController()
        alert.title = "Task"
        alert.message = "Do you really want to pay \(taskTextField.text!) for \(cell.taskLabel.text!)"
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:{(alert :UIAlertAction!) in
            self.uploadBalance(self.taskTextField.text!, paymentDescription: cell.taskLabel.text!)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func uploadBalance(paymentAmount: String, paymentDescription: String){
        
        let paymentDetails=[
            "doneBy":ref.authData.uid,
            "description":paymentDescription,
            "amount": paymentAmount,
            "type":"payment",
            "username":appDelegate.currentUser["username"] as String!,
            
        ]
        let homeid:String = appDelegate.currentUser["home"]!
        let paymentRef = ref.childByAppendingPath("task").childByAppendingPath(homeid)
        
        paymentRef.childByAutoId().setValue(paymentDetails)
        
        
        
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
