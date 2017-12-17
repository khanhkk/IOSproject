//
//  ActionsTableViewCell.swift
//  PlanManagement
//
//  Created by CNTT-MAC on 12/16/17.
//  Copyright © 2017 CNTT-MAC. All rights reserved.
//

import UIKit

class ActionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblActionName: UILabel!
    
    @IBOutlet weak var lblPlan: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
