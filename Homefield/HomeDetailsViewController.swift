//
//  HomeDetailsViewController.swift
//  Homefield
//
//  Created by Ugur Bastug on 06/05/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class HomeDetailsViewController: UIViewController {
    var home = [String:AnyObject!]()

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var homeIdLabel: UILabel!
    @IBOutlet weak var homeIdButton: UIButton!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var homeId:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeNameLabel.text=(home["name"] as! String!).uppercaseString
        self.homeIdButton.setTitle(homeId, forState: UIControlState.Normal)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
