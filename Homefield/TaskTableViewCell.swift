//
//  TaskTableViewCell.swift
//  Homefield
//
//  Created by Ugur Bastug on 24/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicture.layer.masksToBounds=true
        self.profilePicture.layer.cornerRadius=((self.profilePicture.image?.size.height)!/4
        )
        self.profilePicture.layer.borderColor=UIColor.grayColor().CGColor
        self.profilePicture.layer.borderWidth=1.5
        // Initialization code
        self.bgView.layer.cornerRadius=6
        self.bgView.layer.masksToBounds=false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
