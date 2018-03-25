//
//  MapCollectionViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 04/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var mapBlockImageView: UIImageView!
  @IBOutlet weak var heroBlockImageView: UIImageView!
  @IBOutlet weak var annotationLabel: UILabel!
  
  func setBackground(with image: UIImage) {
    mapBlockImageView.image = image
  }
  
  func setHero(with image: UIImage) {
    heroBlockImageView.image    = image
    heroBlockImageView.isHidden = false
    layer.zPosition             = 2
  }
  
  func setAnnotation(with text: String) {
    annotationLabel.text     = text
    annotationLabel.isHidden = false
    layer.zPosition          = 1
  }
  
  func configuredCell() {
    layer.zPosition = 0
    
    annotationLabel.isHidden    = true
    heroBlockImageView.isHidden = true
  }
  
}
