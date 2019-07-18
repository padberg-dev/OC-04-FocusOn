//
//  CustomCollectionView.swift
//  FocusOn
//
//  Created by Rafal Padberg on 02.05.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var customDelegate: CustomCollectionViewDelegate?
    
    var highlightedCell = 0

    var data: [String] = []
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        print("REGISTER")
        register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 60, height: 20)
        layout?.minimumLineSpacing = 10
        layout?.sectionInset = UIEdgeInsets(top: 3, left: 5, bottom: 7, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.setTitile(to: data[indexPath.item])
        if indexPath.item == highlightedCell {
            cell.highlightCell()
        } else {
            cell.clearCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.cellWasSelected(withIndex: indexPath.item)
    }
    
    func highlightCell(withIndex: Int) {
        if let cell = self.cellForItem(at: IndexPath(item: highlightedCell, section: 0)) as? CustomCollectionViewCell {
            cell.clearCell()
        }
        
        if let cell = self.cellForItem(at: IndexPath(item: withIndex, section: 0)) as? CustomCollectionViewCell {
            cell.highlightCell()
        }
        highlightedCell = withIndex
    }
}
