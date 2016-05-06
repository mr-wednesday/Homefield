//
//  TaskItemTableViewCell.swift
//  Homefield
//
//  Created by Ugur Bastug on 25/03/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class TaskItemTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
