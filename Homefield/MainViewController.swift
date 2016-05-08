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
    
    var tasks = [String:AnyObject!]()
    
    var taskArr = [AnyObject]()
    
    var home = [String:AnyObject!]()
    
    var houseMembers = [String]()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var me = [String:String!]()
    
    @IBOutlet weak var navigationBarButton: UIButton!
    override func viewWillAppear(animated: Bool) {
        let appColor: UIColor = UIColor.init(red: 80/255.0, green: 174/255.0, blue: 156/255.0, alpha: 1.0)
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
        return tasks.count
    }
    
    //SHOW THE TASKS DONE FOR THAT HOME
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:TaskTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Task", forIndexPath: indexPath) as! TaskTableViewCell
        
        if(tasks.count>0){
            
            let taskKey = self.taskArr[indexPath.row] as! String
            let taskObject = self.tasks[taskKey]
            if(taskObject!["type"] as! String!=="payment"){
                cell.descriptionTextField?.text="\(taskObject!["description"] as! String!)"
                cell.moneyAmountLabel.text="\(taskObject!["amount"] as! String!)£"
                cell.moneyAmountLabel.hidden=false
                let interval:NSTimeInterval = taskObject!["createdAt"] as! NSTimeInterval
                let date = NSDate(timeIntervalSince1970: interval)
                cell.taskDoneLabel.text="TASK DONE: \(date)"
                cell.typeTaskAvatar.image = UIImage.init(named: "money.png")
                
            }else{
                cell.descriptionTextField?.text="\(taskObject!["description"] as! String!)"
                cell.moneyAmountLabel.hidden=true
                let interval:NSTimeInterval = taskObject!["createdAt"] as! NSTimeInterval
                let date = NSDate(timeIntervalSince1970: interval)
                cell.taskDoneLabel.text="TASK DONE: \(date)"
                cell.typeTaskAvatar.image = UIImage.init(named: "stickman.png")
                if((taskObject!["doneBy"] == nil)){
                    cell.doneMark.hidden=true
                }else{
                    cell.doneMark.hidden=false
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
        
        ref.childByAppendingPath("task").childByAppendingPath(me["home"]).observeEventType(.Value, withBlock: { snapshot in
            
            self.tasks = snapshot.value as! [String : AnyObject!]
            var keys = Array(self.tasks.keys)
            self.taskArr=keys
            
            //self.taskArr = self.tasks.keys as! [String:AnyObject!];
            
            self.tableView.reloadData()
            
            
        })
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="homeDetailsSegue"){
            (segue.destinationViewController as! HomeDetailsViewController).home=self.home
            (segue.destinationViewController as! HomeDetailsViewController).homeId="test"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
