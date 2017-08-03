//
//  JournalTableViewActionCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 10/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class JournalTableViewActionCell: UITableViewCell {
  
  @IBOutlet weak var actionLabel: UILabel!
  @IBOutlet weak var progressViewBar: UIProgressView!
  @IBOutlet weak var hpLabel: UILabel!
  @IBOutlet weak var energyLabel: UILabel!
  @IBOutlet weak var helpButton: UIButton!
  
  func configuredAction(info action: Action) {
    actionLabel.text = action.info.capitalizeFirstLetter

    DispatchQueue.main.async {
      self.progressViewBar.setProgress(Float(action.percents), animated: false)
    }
  }
  
  func configuredHeroBase(info hero: HeroBaseParameters) {
    hpLabel.text = hero.healthRepresentation()
  }
  
  func configuredEnergy(info energy: Energy) {
    energyLabel.text = energy.energyRepresentation()
  }
  
  func configuredHelpButton(isEnabled: Bool) {
    helpButton.isEnabled = isEnabled
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
