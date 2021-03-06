//
//  CompanionTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 12/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class CompanionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var healthProgressView: UIProgressView!
  @IBOutlet weak var healthLabel: UILabel!
  @IBOutlet weak var experienceProgressView: UIProgressView!
  @IBOutlet weak var experienceLabel: UILabel!

  func configuredCompanion(info companion: Companion) {
    healthLabel.text     = companion.healthRepresentation
    experienceLabel.text = companion.experienceRepresentation
    
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.healthProgressView.setProgress(TaleAPI.shared.playerInformationManager.companion?.healthProgressRepresentation ?? 0.5, animated: false)
      strongSelf.experienceProgressView.setProgress(TaleAPI.shared.playerInformationManager.companion?.experienceProgressRepresentation ?? 0.5, animated: false)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
