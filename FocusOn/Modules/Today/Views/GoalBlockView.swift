//
//  GoalBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 26.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class GoalBlockView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var goalTextFieldRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var completionImageView: UIImageView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var bottomLineLeftView: UIView!
    @IBOutlet weak var bottomLineRightView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    private var parentConnection: TodayViewController!
    
    var completionProgress: Goal.CompletionProgress!
    
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
    }
    
    // MARK:- View Life Cycle Methods
    
    override func layoutSubviews() {
        
        setupUI()
    }
    
    // MARK:- Public Methods
    
    func config(parent: TodayViewController?) {
        if parent != nil {
            parentConnection = parent
            goalTextField.tag = tag
            goalTextField.delegate = parent
            alpha = 0
        }
    }
    
    func changeLabels(title: String, date: String) {
        self.goalLabel.text = title
        self.goalTextField.text = title
        self.dateLabel.text = date
    }
    
    func setTo(text: String, dateString: String, completion: Goal.CompletionProgress) {
        print("BLOCK SET TO")
        goalLabel.text = text
        goalTextField.isHidden = true
        dateLabel.text = dateString
        dateLabel.alpha = 1
        dateLabel.transform = .identity
        setCompletion(to: completion)
    }
    
    func setCompletion(to completionProgress: Goal.CompletionProgress) {
        self.completionProgress = completionProgress
        var imageName = "0"
        switch completionProgress {
        case .notCompleted:
            imageName = "0"
        case .oneThird:
            imageName = "120"
        case .twoThirds:
            imageName = "240"
        case .completed:
            imageName = "done"
        case .notYetAchieved:
            imageName = "cancel"
        }
        completionImageView.image = UIImage(named: imageName)
    }
    
    func animateTransition() {
        dateLabel.transform = CGAffineTransform(translationX: 0, y: -24)
        dateLabel.alpha = 1
        dateLabel.text = Date().getDateString()
        
        completionImageView.frame.origin.x += 56
        goalLabel.text = goalTextField.text
        let translation = CGAffineTransform(translationX: -7, y: 0)
        goalLabel.transform = CGAffineTransform(translationX: 7, y: 0)
        
        self.completionImageView.rotate(duration: 1.0, fromValue: 1.5 * CGFloat.pi, toValue: 0)
        
        UIView.animate(withDuration: 0.9) {
            self.completionImageView.frame.origin.x -= 56
            self.dateLabel.transform = .identity
            self.goalTextField.alpha = 0
            self.goalTextField.transform = translation
            self.goalLabel.transform = .identity
        }
    }
    
    // MARK:- PRIVATE:
    // MARK:- Custom Methods
    
    private func setupUI() {
        print("BLOCK SETUP")
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        bottomLineView.backgroundColor = UIColor.Main.rosin
        backgroundView.backgroundColor = UIColor.Main.berkshireLace
        
        let colors = [UIColor.Main.berkshireLace, UIColor.Main.rosin]
        bottomLineLeftView.addHorizontalGradient(of: colors)
        bottomLineRightView.addHorizontalGradient(of: colors.reversed())
        
        addSimpleShadow(color: UIColor.Main.rosin, radius: 8, opacity: 0.4, offset: CGSize(width: 0, height: 3))
        
        goalTextField.textColor = UIColor.Main.rosin
        goalLabel.textColor = UIColor.Main.rosin
        
        dateLabel.textColor = UIColor.Main.atlanticDeep
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("GoalBlockView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
