//
//  EquipmentTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 12/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class EquipmentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var equipImageView: UIImageView!
  @IBOutlet weak var equipLabel: UILabel!
  @IBOutlet weak var mPowerLabel: UILabel!
  @IBOutlet weak var pPowerLabel: UILabel!

  func configuredEquipment(info equipment: Artifact) {

    equipImageView.image = UIImage(named: equipment.imageName)
    equipLabel.text      = equipment.nameRepresentation
    mPowerLabel.text     = equipment.mPowerRepresentation
    pPowerLabel.text     = equipment.pPowerRepresentation
    
    guard let rarity = equipment.rarity else { return }
    
    var textColor: UIColor {
      switch rarity {
      case 1:
        return UIColor(hexString: "#0070dd")!
      case 2:
        return UIColor(hexString: "#a335ee")!
      default:
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      }
    }
    
    equipLabel.textColor = textColor
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
