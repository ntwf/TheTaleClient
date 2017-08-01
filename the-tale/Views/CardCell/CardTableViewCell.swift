//
//  CardTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
  
  @IBOutlet weak var cardNameLabel: UILabel!
  @IBOutlet weak var cardDescriptionLabel: UILabel!
  
  func configuredCard(info card: CardInfo, description: String) {
    cardNameLabel.text        = card.name.capitalizeFirstLetter
    cardDescriptionLabel.text = description
    
    var textColor: UIColor {
      switch card.rarity {
      case 0:
        return UIColor(hexString: "#333333")!
      case 1:
        return UIColor(hexString: "#30b030")!
      case 2:
        return UIColor(hexString: "#0070dd")!
      case 3:
        return UIColor(hexString: "#a335ee")!
      case 4:
        return UIColor(hexString: "#ff8000")!
      default:
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      }
    }
    
    cardNameLabel.textColor = textColor
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
