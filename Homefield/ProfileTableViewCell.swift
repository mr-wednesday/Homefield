//
//  ProfileTableViewCell.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell
{
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicture.layer.masksToBounds=true
        self.profilePicture.layer.borderWidth=4
        self.profilePicture.backgroundColor=UIColor.lightGrayColor()
        self.profilePicture.layer.borderColor=appDelegate.appColor.CGColor
        self.profilePicture.layer.cornerRadius=(self.profilePicture.image?.size.height)!/2
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func openCameraRoll(sender: AnyObject) {
        
    }
    
}
