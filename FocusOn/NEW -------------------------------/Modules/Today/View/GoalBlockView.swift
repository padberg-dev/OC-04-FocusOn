//
//  GoalBlockView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 26.06.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class GoalBlockView: UIView {
    
    // MARK:- Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var completionImageView: UIImageView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var bottomLineLeftView: UIView!
    @IBOutlet weak var bottomLineRightView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK:- Constraints
    
    @IBOutlet weak var goalTextFieldRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
    
    // MARK:- Private Properties
    
    private var parentConnection: TodayViewController?
    private var completionProgress: Goal.CompletionProgress!
    
    // MARK:- Public Methods
    
    func getCompletionProgress() -> Goal.CompletionProgress {
        
        return completionProgress
    }
    
    func getGoalData() -> (title: String, dateString: String, completion: Goal.CompletionProgress) {
        
        return (goalLabel.text ?? "", dateLabel.text ?? "", getCompletionProgress())
    }
    
    func config(parent: TodayViewController) {
        
        parentConnection = parent
        goalTextField.delegate = parent
        goalTextField.tag = tag
        alpha = 0
    }
    
    func update(title: String, dateString: String, completion: Goal.CompletionProgress) {
        
        goalLabel.text = title
        goalTextField.text = title
        dateLabel.text = dateString
        setCompletion(to: completion)
    }
    
    func update(with goal: Goal) {
        
        goalLabel.text = goal.fullDescription
        goalTextField.text = goal.fullDescription
        dateLabel.text = goal.date.getDateString()
        setCompletion(to: goal.completion)
    }
    
    func setTo(title: String, dateString: String, completion: Goal.CompletionProgress) {
        
        update(title: title, dateString: dateString, completion: completion)
        
        goalTextField.isHidden = true
        dateLabel.alpha = 1
        dateLabel.transform = .identity
    }
    
    func animateTransition() {
        
        dateLabel.transform = CGAffineTransform(translationX: 0, y: -24)
        dateLabel.alpha = 1
        
        completionImageView.frame.origin.x += 56
        let translation = CGAffineTransform(translationX: -7, y: 0)
        goalLabel.transform = CGAffineTransform(translationX: 7, y: 0)
        
        self.completionImageView.rotate(duration: 1.0, fromValue: 1.5 * CGFloat.pi, toValue: 0)
        
        UIView.animate(withDuration: 1) {
            
            self.completionImageView.frame.origin.x -= 56
            self.dateLabel.transform = .identity
            self.goalTextField.alpha = 0
            self.goalTextField.transform = translation
            self.goalLabel.transform = .identity
        }
    }
    
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
    
    // MARK:- PRIVATE:
    // MARK:- Custom Methods
    
    private func setupUI() {
        
        backgroundView.backgroundColor = UIColor.Main.berkshireLace
        
        let colors = [UIColor.Main.berkshireLace, UIColor.Main.rosin]
        bottomLineLeftView.addHorizontalGradient(of: colors)
        bottomLineView.backgroundColor = UIColor.Main.rosin
        bottomLineRightView.addHorizontalGradient(of: colors.reversed())
        
        goalTextField.textColor = UIColor.Main.rosin
        goalLabel.textColor = UIColor.Main.rosin
        dateLabel.textColor = UIColor.Main.atlanticDeep
        
        if parentConnection != nil {
            
            addSimpleShadow(color: UIColor.Main.rosin, radius: 8, opacity: 0.4, offset: CGSize(width: 0, height: 3))
        }
    }
    
    private func setCompletion(to completionProgress: Goal.CompletionProgress) {
        
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
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("GoalBlockView", owner: self, options: nil)
        backgroundColor = .clear
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .clear
        
        addSubview(contentView)
    }
}
