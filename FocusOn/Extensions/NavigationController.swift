//
//  NavigationController.swift
//  FocusOn
//
//  Created by Rafal Padberg on 18.07.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func configure() {
        
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.Main.atlanticDeep
        
        let font = UIFont(name: "AvenirNextCondensed-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.Main.berkshireLace,
            NSAttributedString.Key.font : font]
        
        navigationBar.addSimpleShadow(color: UIColor.Main.rosin, radius: 6.0, opacity: 0.3, offset: .zero)
    }
}
