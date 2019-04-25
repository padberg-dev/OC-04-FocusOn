//
//  CustomTableViewCell.swift
//  FocusOn
//
//  Created by Rafal Padberg on 19.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var goalCompletionLabel: UILabel!
    
    @IBOutlet weak var task1Label: UILabel!
    @IBOutlet weak var task2Label: UILabel!
    @IBOutlet weak var task3Label: UILabel!
    
    @IBOutlet weak var task1CompletionLabel: UILabel!
    @IBOutlet weak var task2CompletionLabel: UILabel!
    @IBOutlet weak var task3CompletionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
