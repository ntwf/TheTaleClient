//
//  MapCollectionViewLayout.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 05/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MapCollectionViewLayout: UICollectionViewLayout {
  
  let cellWidth  = 32.0
  let cellHeight = 32.0
  
  var contentSize: CGSize = .zero
  override var collectionViewContentSize: CGSize {
    return self.contentSize
  }
  
  var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
  
  override func prepare() {
    guard let collectionView = collectionView else { return }
    
    if collectionView.numberOfSections > 0 {
      for section in 0..<collectionView.numberOfSections {
        
        if collectionView.numberOfItems(inSection: 0) > 0 {
          for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let cellIndex = IndexPath(item: item, section: section)
            
            let xPosition = Double(item) * cellWidth
            let yPosition = Double(section) * cellHeight
            
            let cellAttribute = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
            cellAttribute.frame = CGRect(x: xPosition, y: yPosition, width: cellWidth, height: cellHeight)
            
            cellAttributes[cellIndex] = cellAttribute
          }
        }
        
      }
    }
    
    let contentHeight = cellHeight * Double(collectionView.numberOfSections)
    let contentWidth  = cellWidth * Double(collectionView.numberOfItems(inSection: 0))
    self.contentSize  = CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cellAttributes[indexPath]
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributesInRect = [UICollectionViewLayoutAttributes]()
    
    for cellAttribute in cellAttributes.values {
      if rect.intersects(cellAttribute.frame) {
        attributesInRect.append(cellAttribute)
      }
    }
    
    return attributesInRect
  }
}
