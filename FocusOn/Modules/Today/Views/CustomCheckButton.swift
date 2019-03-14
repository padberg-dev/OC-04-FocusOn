//
//  CustomCheckButton.swift
//  FocusOn
//
//  Created by Rafal Padberg on 14.03.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomCheckButton: UIButton {
    
    func changeImage(to imageName: String) {
        if let image = UIImage(named: imageName) {
            self.setImage(image, for: .normal)
        }
    }
}
