//
//  ProfileTableViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView:UITableView!
    var user = [String:String!]()
    var userActivities=[String:AnyObject!]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = appDelegate.appColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    
    override func viewDidLoad() {
        
        //PROTOTOTYPE ONLY
        user = appDelegate.currentUser
        
        
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileHeader")
        self.tableView.registerNib(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "Balance")
        self.tableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Task")
        
        self.title = user["username"];
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.row){
        case 0:
            return 155
        case 1:
            return 44
        default:
            return 66
        }
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(indexPath.row==0){
            //profileHeader
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeader", forIndexPath: indexPath)
            return cell
        }
        if(indexPath.row==1){
            let cell = tableView.dequeueReusableCellWithIdentifier("Balance", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Task", forIndexPath: indexPath)
            return cell
        }

    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
