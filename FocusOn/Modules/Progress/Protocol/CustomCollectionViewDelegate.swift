//
//  CustomCollectionViewDelegate.swift
//  FocusOn
//
//  Created by Rafal Padberg on 02.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import Foundation

protocol CustomCollectionViewDelegate: class {
    func cellWasSelected(withIndex index: Int)
}
