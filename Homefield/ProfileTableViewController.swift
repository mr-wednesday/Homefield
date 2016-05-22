//
//  ProfileTableViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let ref = FIRDatabase.database().reference()

    @IBOutlet var tableView:UITableView!
    var userActivities=[String:AnyObject!]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedImage:UIImage!
    var uid = FIRAuth.auth()?.currentUser?.uid
    var latestPayments = [Task]()
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = appDelegate.appColor
        
    }
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("loginModal", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.latestPayments.removeAll()
        self.getPayments()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileHeader")
        self.tableView.registerNib(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "Balance")
        self.tableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Task")
        self.tableView.registerNib(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "User")

        self.title = appDelegate.currentUser.username
        
        
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
        if(indexPath.section==1){
            return 44
        }else{
            switch(indexPath.row){
            case 0:
                return 155
            case 1:
                return 44
            default:
                return 66
            }
        }


    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0){
            return 2
        }
        if(section==1){
            return latestPayments.count
        }
        else{
            return 0
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==1){
            return "Latest Payments"
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section==0){
            if(indexPath.row==0){
                //profileHeader
                let cell:ProfileTableViewCell = tableView.dequeueReusableCellWithIdentifier("ProfileHeader", forIndexPath: indexPath) as! ProfileTableViewCell
                
                cell.profilePictureButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                if((appDelegate.currentUser.profilePicture == nil)){
                    cell.profilePicture.image = UIImage.init(named: "defaultUser.jpg")
                }else{
                    cell.profilePicture.image = appDelegate.currentUser.profilePicture
                    
                }
                
                
                return cell
            }
            if(indexPath.row==1){
                let cell:BalanceTableViewCell = tableView.dequeueReusableCellWithIdentifier("Balance", forIndexPath: indexPath) as!BalanceTableViewCell
                cell.balanceLabel.text="Balance: \(self.appDelegate.currentUser.balance)"
                
                return cell
            }
        }

        if(indexPath.section==1){
            let cell:UserTableViewCell = tableView.dequeueReusableCellWithIdentifier("User", forIndexPath: indexPath) as! UserTableViewCell
            let taskObject = latestPayments[indexPath.row]
            cell.userBalanceLabel.text="\(taskObject.amount)"
            cell.usernameLabel.text = taskObject.description
            return cell
            
        }else{
            //never gonna happen
            let cell:TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("Task", forIndexPath: indexPath) as! TaskTableViewCell

            return cell
        }
        
    }
    func getPayments(){
        var totalPaymentsDone:Double=Double()
        (ref.child("task").child(appDelegate.currentUser.homeId).observeEventType(.Value, withBlock: { snapshot in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let task = Task();
                if(child.value!.objectForKey("type") as! String=="payment"){
                    if(child.value!.objectForKey("doneBy")! as! String == self.uid){
                        task.amount =  (child.value!.objectForKey("amount") as! NSString).doubleValue
                        task.description = (child.value!.objectForKey("description") as! String)
                        totalPaymentsDone+=task.amount
                        self.latestPayments.append(task)
                    }
                    
                    self.appDelegate.currentUser.balance = totalPaymentsDone * -1
                    self.tableView.reloadData()

                }
                
                
            }
        }))
    }
    func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
        selectPicture()
    }
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData =  UIImageJPEGRepresentation(tempImage,0.5)
        storeImage(imageData!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    func storeImage(imageData:NSData){
        // Data in memory
        // Create a reference to the file you want to upload
        let storage = FIRStorage.storage()
        let ppRef = storage.reference().child("profilePicture").child(uid!)
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = ppRef.putData(imageData, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()?.absoluteString
                self.ref.child("user").child(self.uid!).child("profilePicture").setValue(downloadURL!)
                self.appDelegate.currentUser.profilePicture = UIImage.init(data: imageData)
                self.tableView.reloadData()
            }
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
