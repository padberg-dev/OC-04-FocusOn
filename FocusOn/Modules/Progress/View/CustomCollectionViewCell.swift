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
        
        customView.alpha = 1
        backgroundColor = UIColor.Main.berkshireLace
        customView.backgroundColor = UIColor.Main.berkshireLace
        customLabel.textColor = UIColor.Main.rosin
    }
    
    func setUnavailable() {
        
        customView.alpha = 0.5
        backgroundColor = UIColor.Main.hypothalamusGrey
        customView.backgroundColor = UIColor.Main.treetop
        customLabel.textColor = UIColor.Main.atlanticDeep
    }
    
    func  clearCell() {
        
        customView.alpha = 1
        backgroundColor = UIColor.Main.hypothalamusGrey
        customView.backgroundColor = UIColor.Main.treetop
        customLabel.textColor = UIColor.Main.blackSafflower
    }
}
