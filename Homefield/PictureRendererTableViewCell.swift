//
//  PictureRendererTableViewCell.swift
//  Homefield
//
//  Created by Ugur Bastug on 09/05/16.
//  Copyright © 2016 Ugur Bastug. All rights reserved.
//

import UIKit

class PictureRendererTableViewCell: UITableViewCell {
    
    @IBOutlet weak var initialLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func render(name:String)->UIImage{
        var text = self.initialLabel.text
        text = text!.characters.first as? String
        initialLabel.text=text
    UIGraphicsBeginImageContext(self.bounds.size);
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot
    }
}
