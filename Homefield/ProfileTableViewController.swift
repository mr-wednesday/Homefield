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
    @IBOutlet var tableView:UITableView!
    var user = [String:String!]()
    var userActivities=[String:AnyObject!]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedImage:UIImage!
    var localURL:NSURL!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = appDelegate.appColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    @IBAction func logout(sender: AnyObject) {
        //try! FIRAuth.auth()!.signOut()
        self.performSegueWithIdentifier("loginModal", sender: self)
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
            let cell:ProfileTableViewCell = tableView.dequeueReusableCellWithIdentifier("ProfileHeader", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.profilePictureButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
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
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage

        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage

        } else {
            return
        }
        //tricky
        //ref: http://stackoverflow.com/questions/28255789/getting-url-of-uiimage-selected-from-uiimagepickercontroller
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath =  imageURL.path!
        let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imagePath)
        
        //this block of code adds data to the above path
        let path = localPath.relativePath!
        let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImagePNGRepresentation(imageName)
        data?.writeToFile(imagePath, atomically: true)
        
        //this block grabs the NSURL so you can use it in CKASSET
        let photoURL = NSURL(fileURLWithPath: path)
        localURL=photoURL
        //self.selectedImage=newImage
        //no need fo now
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func storeImage(){
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()

        // Create a root reference
        let storageRef = storage.reference()
        let pictureRef = storageRef.child("images/\(FIRAuth.auth()?.currentUser?.uid)")
        


        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = pictureRef.putFile(localURL, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
            }
        }
        uploadTask.observeStatus(.Success) { snapshot in
            // Upload completed successfully
        }
        uploadTask.observeStatus(.Progress) { snapshot in
            // Upload reported progress
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
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
