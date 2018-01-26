//
//  CustomTableViewCell.swift
//  todolist2
//
//  Created by Omar Ihmoda on 1/24/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var completed = false
    
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
