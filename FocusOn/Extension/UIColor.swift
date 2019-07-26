//
//  UIColor.swift
//  FocusOn
//
//  Created by Rafal Padberg on 20.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgbColor(R: Int, G: Int, B: Int, A: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(R) / 256, green: CGFloat(G) / 256, blue: CGFloat(B) / 256, alpha: A)
    }
    
    struct Main {
        static let blackSafflower = UIColor.rgbColor(R: 52, G: 43, B: 54)
        static let rosin = UIColor.rgbColor(R: 57, G: 57, B: 54)
        static let atlanticDeep = UIColor.rgbColor(R: 41, G: 77, B: 87)
        static let deepPeacoockBlue = UIColor.rgbColor(R: 0, G: 132, B: 129)
        static let studio = UIColor.rgbColor(R: 112, G: 79, B: 164)
        static let lagoon = UIColor.rgbColor(R: 79, G: 164, B: 154)
        static let treetop = UIColor.rgbColor(R: 147, G: 187, B: 173)
        static let berkshireLace = UIColor.rgbColor(R: 241, G: 227, B: 208)
    }
    
    struct Gradients {
        static let greenLight = [UIColor.Main.deepPeacoockBlue, UIColor.Main.lagoon]
        static let greenMedium = [UIColor.Main.deepPeacoockBlue, UIColor.Main.treetop]
        static let greenYellowish = [UIColor.Main.deepPeacoockBlue, UIColor.Main.berkshireLace]
        static let greenYellowishLight = [UIColor.Main.lagoon, UIColor.Main.berkshireLace]
        static let greenDarker = [UIColor.Main.atlanticDeep, UIColor.Main.deepPeacoockBlue]
        static let greenBlack = [UIColor.Main.blackSafflower, UIColor.Main.deepPeacoockBlue]
    }
}
