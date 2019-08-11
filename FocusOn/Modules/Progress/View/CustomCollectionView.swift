//
//  CustomCollectionView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 02.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

enum CellType {
    case yearsCell
    case monthsCell
}

class CustomCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var customDelegate: CustomCollectionViewDelegate?
    
    var highlightedCell = 0
    var type: CellType!

    var data: [String] = []
    var isDataAvailable: [Bool] = []
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        print("REGISTER")
        register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 56, height: 20)
        layout?.minimumLineSpacing = 10
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.setTitile(to: data[indexPath.item])
        let index = indexPath.item
        
        if type == .monthsCell && isDataAvailable[highlightedCell] == false {
            highlightedCell = 0
            customDelegate?.cellWasSelected(withIndex: 0, cellType: .monthsCell)
        }
        
        if index == highlightedCell {
            cell.highlightCell()
        } else {
            if isDataAvailable[index] {
                cell.clearCell()
            } else {
                cell.setUnavailable()
            }
        }
        return cell
    }
    
    // todo: Case when switching from december 2018 to december 2019 it should be impossible or change to whole year
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if index != highlightedCell && isDataAvailable[index] == true {
            highlightCell(withIndex: indexPath.item)
            let number = type == .monthsCell ? index : Int(data[index])!
            customDelegate?.cellWasSelected(withIndex: number, cellType: type)
        }
    }
    
    func highlightCell(withIndex index: Int) {
        highlightedCell = index
        reloadData()
    }
}
