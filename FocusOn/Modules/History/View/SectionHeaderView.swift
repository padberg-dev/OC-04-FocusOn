//
//  SectionHeaderView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 25.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var numberDoneLabel: UILabel!
    @IBOutlet weak var numberAllLabel: UILabel!
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        print("LOL")
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
    }
    
    func configureHeader(sectionText: String, completedGoals: Int, allGoals: Int) {
        sectionTitleLabel.text = sectionText
        numberDoneLabel.text = String(completedGoals)
        numberAllLabel.text = String(allGoals)
    }
    
    private func loadFromNib() {
        Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.isUserInteractionEnabled = false
    }
}
