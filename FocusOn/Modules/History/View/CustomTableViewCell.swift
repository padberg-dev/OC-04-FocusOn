//
//  CustomTableViewCell.swift
//  FocusOn
//
//  Created by Rafal Padberg on 19.04.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goalBlockView: GoalBlockView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var gradientViewTop: UIView!
    @IBOutlet weak var gradientViewOverBlock: UIView!
    
    @IBOutlet weak var gearImageView: UIImageView!
    
    @IBOutlet var taskBlocks: [TaskBlockView]!
    
    var cellIsSelected: Bool = false
    var goal: GoalData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        bottomConstraint.constant = 0
        
        gradientViewTop.backgroundColor = UIColor.Main.berkshireLace
        
        gradientViewOverBlock.backgroundColor = UIColor.Main.berkshireLace
        gradientViewOverBlock.addSimpleShadow(color: UIColor.Main.rosin, radius: 4, opacity: 0.3, offset: CGSize(width: -6, height: 0))
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 26, height: 1)))
        view.addHorizontalGradient(of: [UIColor.Main.rosin, UIColor.Main.rosin.withAlphaComponent(0)].reversed())
        gradientViewOverBlock.addSubview(view)
        
        let view2 = UIView(frame: CGRect(origin: CGPoint(x: 0, y: gradientViewOverBlock.frame.size.height), size: CGSize(width: 26, height: 1)))
        view2.addHorizontalGradient(of: [UIColor.Main.rosin, UIColor.Main.rosin.withAlphaComponent(0)].reversed())
        gradientViewOverBlock.addSubview(view2)
        
        let view3 = UIView(frame: CGRect(origin: CGPoint(x: 25, y: -27), size: CGSize(width: 1, height: 27)))
        view3.addVerticalGradient(of: [UIColor.Main.rosin, UIColor.Main.rosin])
        gradientViewOverBlock.addSubview(view3)
        
        let view4 = UIView(frame: CGRect(origin: CGPoint(x: 25, y: 6), size: CGSize(width: 1, height: 27)))
        view4.addVerticalGradient(of: [UIColor.Main.rosin, UIColor.Main.rosin.withAlphaComponent(0)])
        gradientViewOverBlock.addSubview(view4)
    }
    
    func setWidth() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
    }
    
    override func prepareForReuse() {
        bottomConstraint.constant = 0
    }
}
