//
//  DropBagItemTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class DropBagItemTableViewCell: UITableViewCell {
  
  @IBOutlet weak var dropItemButton: UIButton!

  func configuredDropItemButton(isHidden: Bool) {
    dropItemButton.isHidden = isHidden
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
