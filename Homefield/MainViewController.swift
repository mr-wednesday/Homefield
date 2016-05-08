//
//  MainViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 24/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    let currentUser = [String:String!]()
    
    let ref = Firebase(url:"https://homefield.firebaseio.com/")
    
    var home = [String:AnyObject!]()
    
    var houseMembers = [String]()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var me = [String:String!]()
    
    var taskObjects = [Task]();
    
    @IBOutlet weak var navigationBarButton: UIButton!
    override func viewWillAppear(animated: Bool) {
        //let appColor: UIColor = UIColor.init(red: 80/255.0, green: 174/255.0, blue: 156/255.0, alpha: 1.0)
        //self.navigationController!.navigationBar.barTintColor = appColor
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Task")
        
        //self.tableView.estimatedRowHeight = 66
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.getHouseMembers()
        self.getTasks()
        me=appDelegate.currentUser
        //self.addDataThen()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskObjects.count
    }
    
    //SHOW THE TASKS DONE FOR THAT HOME
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:TaskTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Task", forIndexPath: indexPath) as! TaskTableViewCell
        
        if(taskObjects.count>0){
            
            let taskObject = taskObjects[indexPath.row]
            if((taskObject.doneBy) != nil){
                cell.ownerUsername = taskObject.doneBy
            }
            if(taskObject.type=="payment"){
                cell.descriptionTextField?.text="\(taskObject.description)"
                cell.moneyAmountLabel.text="\(taskObject.amount)£"
                cell.moneyAmountLabel.hidden=false
                
                let interval:NSTimeInterval = taskObject.createdAt
                let date = NSDate(timeIntervalSince1970: interval)
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                let convertedDate = dateFormatter.stringFromDate(date)
                
                cell.taskDoneLabel.text="TASK DONE: \(convertedDate)"
                cell.typeTaskAvatar.image = UIImage.init(named: "money.png")
                cell.dueToLabel.hidden=true
                cell.doneMark.image = UIImage.init(named: "checked")

            }else{
                cell.descriptionTextField?.text="\(taskObject.description)"
                cell.moneyAmountLabel.hidden=true

                let interval:NSTimeInterval = taskObject.createdAt
                let date = NSDate(timeIntervalSince1970: interval)
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale.currentLocale()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                let convertedDate = dateFormatter.stringFromDate(date)
                
                cell.taskDoneLabel.text="TASK DONE: \(convertedDate)"
                cell.typeTaskAvatar.image = UIImage.init(named: "stickman.png")
                if(taskObject.doneBy == nil){
                    //TO DO ACTIVITY
                    cell.dueToLabel.hidden=false
                    
                    let interval:NSTimeInterval = taskObject.dueTo
                    let date = NSDate(timeIntervalSince1970: interval)
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.locale = NSLocale.currentLocale()
                    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    let convertedDate = dateFormatter.stringFromDate(date)
                    
                    cell.dueToLabel.text="DUE TO: \(convertedDate)"
                    cell.doneMark.image = UIImage.init(named: "warning.png")
                }else{
                    //DONE ACTIVITY
                    cell.dueToLabel.hidden=true
                    cell.doneMark.image = UIImage.init(named: "checked")

                }
                
            }
            
            self.tableView.setNeedsLayout()
            self.tableView.layoutIfNeeded()
            
            return cell
        }
        else{
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 178
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if((taskObjects[indexPath.row].doneBy) != nil){
            if(taskObjects[indexPath.row].doneBy==ref.authData.uid){
                return true
            }else{
                return false
            }
        }else{
            return false
        }

    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let taskCloud = taskObjects[indexPath.row].ref
            let taskRef = Firebase.init(url: taskCloud)
            taskRef.removeValue()
            self.getTasks()
        }
    }
    func addDataThen(){
        let newActivty = [
            "owner": ref.authData.uid,
            "description": "washes the dishes",
            "creation":NSDate().timeIntervalSince1970
        ]
        let newRef = self.ref.childByAppendingPath("task").childByAppendingPath("activity").childByAutoId()
        newRef.setValue(newActivty)
        
        
        
    }
    func getHouseMembers(){
        //also sets nav bar title
        self.me=appDelegate.currentUser
        
        ref.childByAppendingPath("home").childByAppendingPath(me["home"]).observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.home = snapshot.value as! [String : AnyObject!]
            print(snapshot.description)
            self.navigationItem.title = self.home["name"] as? String;
            self.navigationBarButton.setTitle(self.home["name"] as? String, forState: UIControlState.Normal)
            
            // do some stuff once
            
        })
        
        
    }
    
    func getTasks(){
        (ref.childByAppendingPath("task").childByAppendingPath(me["home"])).queryOrderedByChild("createdAt").observeEventType(.Value, withBlock: { snapshot in
            self.taskObjects.removeAll()
            for child in snapshot.children.allObjects as! [FDataSnapshot] {
                let task = Task();
                task.ref = child.ref.description
                if(child.value.objectForKey("type") as! String=="payment"){
                    
                    task.amount =  (child.value.objectForKey("amount") as! NSString).doubleValue
                    task.description = child.value.objectForKey("description") as! String
                    task.type = child.value.objectForKey("type") as! String
                    task.username = child.value.objectForKey("username") as! String
                    task.doneBy = child.value.objectForKey("doneBy") as! String
                    task.createdAt = (child.value.objectForKey("createdAt") as! NSTimeInterval)
                    self.taskObjects.append(task)
                }
                if(child.value.objectForKey("type") as! String=="activity"){
                    if(child.value.objectForKey("doneBy")==nil){
                        //TODO
                        task.description = child.value.objectForKey("description") as! String
                        task.type = child.value.objectForKey("type") as! String
                        task.createdAt = (child.value.objectForKey("createdAt") as! NSTimeInterval)
                        task.dueTo = (child.value.objectForKey("dueTo") as! NSTimeInterval)

                        self.taskObjects.append(task)
                    }else{
                        task.description = child.value.objectForKey("description") as! String
                        task.type = child.value.objectForKey("type") as! String
                        task.username = child.value.objectForKey("username") as! String
                        task.doneBy = child.value.objectForKey("doneBy") as! String
                        task.createdAt = (child.value.objectForKey("createdAt") as! NSTimeInterval)
                        self.taskObjects.append(task)
                    }

                }
            }
            self.taskObjects = self.taskObjects.reverse()
            self.tableView.reloadData()
            
            
        })
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="homeDetailsSegue"){
            (segue.destinationViewController as! HomeDetailsViewController).home=self.home
            (segue.destinationViewController as! HomeDetailsViewController).homeId="test"
        }
        if(segue.identifier=="taskManagerSegue"){
            (segue.destinationViewController as! TaskManagerViewController).allTasks=taskObjects
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
