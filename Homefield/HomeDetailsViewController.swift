//
//  HomeDetailsViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 06/05/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class HomeDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var home = [String:AnyObject!]()

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var homeIdLabel: UILabel!
    @IBOutlet weak var homeIdButton: UIButton!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var homeId:String = String()
    var houseMembers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeNameLabel.text=(home["name"] as! String!).uppercaseString
        self.homeIdButton.setTitle(homeId, forState: UIControlState.Normal)
        self.tableView.registerNib(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "User")
self.descriptionLabel.text="This is your unique home id. Click it to copy and send it to your homemates for them to join the \(home["name"]!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func homeIdClick(sender: AnyObject) {
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = sender.currentTitle
    descriptionLabel.text="Your home id is copied to your clipboard!"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseMembers.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UserTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("User", forIndexPath: indexPath) as! UserTableViewCell
        cell.usernameLabel.text = houseMembers[indexPath.row].username
        cell.userBalanceLabel.hidden=true
        return cell
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
