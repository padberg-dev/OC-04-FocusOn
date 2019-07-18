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
    
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    
    @IBOutlet weak var gearImageView: UIImageView!
    
    @IBOutlet var taskBlocks: [TaskBlockView]!
    
    var cellIsSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        bottomConstraint.constant = 0
        
//        gradientView.addHorizontalGradient(of: [UIColor.Main.berkshireLace.withAlphaComponent(0.4), UIColor.Main.berkshireLace])
        
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.Main.berkshireLace.cgColor, UIColor.Main.berkshireLace.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradientView.layer.addSublayer(gradient)
        
        gradientViewTop.backgroundColor = UIColor.Main.berkshireLace.withAlphaComponent(0.75)
        
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
        
        let gradient3 = CAGradientLayer()
        gradient3.frame = topLeftView.bounds
        gradient3.colors = [UIColor.Main.rosin.withAlphaComponent(0).cgColor, UIColor.Main.rosin.withAlphaComponent(0.15).cgColor]
        gradient3.startPoint = CGPoint(x: 0, y: 0)
        gradient3.endPoint = CGPoint(x: 1, y: 1)
        topLeftView.layer.addSublayer(gradient3)
        
        let gradient4 = CAGradientLayer()
        gradient4.frame = bottomLeftView.bounds
        gradient4.colors = [UIColor.Main.rosin.withAlphaComponent(0).cgColor, UIColor.Main.rosin.withAlphaComponent(0.15).cgColor]
        gradient4.startPoint = CGPoint(x: 0, y: 1)
        gradient4.endPoint = CGPoint(x: 0, y: 0)
        bottomLeftView.layer.addSublayer(gradient4)
    }
    
    func animateTasks() {
        taskBlocks.forEach {
            $0.transform = CGAffineTransform(translationX: 0, y: CGFloat(($0.tag + 1) * -30))
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            self.taskBlocks.forEach { $0.transform = .identity }
        }) { [weak self] _ in
            self?.taskBlocks.forEach { $0.checkBox.hide() }
        }
    }
    
    func resetTasks() {
        taskBlocks.forEach { $0.checkBox.unHide() }
    }
    
    override func layoutSubviews() {
        print("DDD cell alyouts subviews \(cellIsSelected)")
        
    }
    
    func setWidth() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
    }
    
    override func prepareForReuse() {
        bottomConstraint.constant = 0
    }
}
