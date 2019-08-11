//
//  CustomCollectionViewCell.swift
//  FocusOn
//
//  Created by Rafal Padberg on 02.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        customView.layer.cornerRadius = 5.0
    }
    
    func setTitile(to text: String) {
        customLabel.text = text
    }
    
    func highlightCell() {
        customView.backgroundColor = .white
    }
    
    func setUnavailable() {
        self.customView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
    
    func  clearCell() {
        self.customView.backgroundColor = UIColor(red: 136/255, green: 212/255, blue: 152/255, alpha: 1.0)
    }
}
