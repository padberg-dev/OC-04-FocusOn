//
//  AnimatedLabelView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 21.07.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class AnimatedLabelView: UIView {
    
    enum FontType {
        case bold
        case light
    }
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK:- Private Properties
    
    private var characterLabels: [UILabel] = []
    private var fontAttributes: [NSAttributedString.Key : NSObject] = [:]
    
    private let animationDuration: Double = 0.3
    private let animationDelay: Double = 0.02

    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNib()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadFromNib()
        setup()
    }
    
    // MARK:- Public Methods
    
    func assign(text: String, font: AnimatedLabelView.FontType = .bold) {
        
        assignFont(font)
        text.forEach { character in
            
            createLabelAndInsertIntoStackView(character)
        }
    }
    
    func show(animated: Bool) {
        
        if animated {
            
            for (i, label) in characterLabels.enumerated() {
                
                label.transform = CGAffineTransform(translationX: 0, y: (i % 2) == 0 ? -10 : 10)
                let duration = animationDuration
                
                UIView.animate(withDuration: duration / 18, delay: Double(i) * animationDelay, options: .curveEaseInOut, animations: {

                    label.alpha = 1
                    label.transform = .identity
                }, completion: nil)
            }
        } else {
            
            characterLabels.forEach { $0.alpha = 1 }
        }
    }
    
    // MARK:- PRIVATE:
    // MARK:- Custom Methods
    
    private func createLabelAndInsertIntoStackView(_ character: Character) {
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: String(character), attributes: fontAttributes)
        label.alpha = 0
        
        characterLabels.append(label)
        stackView.addArrangedSubview(label)
    }
    
    private func assignFont(_ fontType: AnimatedLabelView.FontType) {
        
        var font: UIFont!
        
        switch fontType {
        case .bold:
            font = UIFont(name: "AvenirNextCondensed-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        case .light:
            font = UIFont(name: "AvenirNextCondensed-Light", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .light)
            stackView.spacing = -0.7
        }
        fontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Main.blackSafflower, NSAttributedString.Key.font : font]
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
    }
    
    private func loadFromNib() {
        
        Bundle.main.loadNibNamed("AnimatedLabelView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
