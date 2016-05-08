//
//  TaskTableViewCell.swift
//  Homefield
//
//  Created by Ugur Bastug on 24/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var moneyAmountLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var taskDoneLabel: UILabel!
    @IBOutlet weak var typeTaskAvatar: UIImageView!
    @IBOutlet weak var doneMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let goldColor = UIColor.init(red: 154/255.0, green: 125/255.0, blue: 49/255.0, alpha: 1)
        self.profilePicture.layer.masksToBounds=true
        self.profilePicture.layer.cornerRadius=((self.profilePicture.image?.size.height)!/4
        )
        self.profilePicture.layer.borderColor=UIColor.grayColor().CGColor
        self.profilePicture.layer.borderWidth=1.5
        // Initialization code
        self.bgView.layer.cornerRadius=6
        self.bgView.layer.masksToBounds=false
        self.bgView.layer.borderColor=goldColor.CGColor
        self.bgView.layer.borderWidth=0.2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
