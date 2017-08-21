//
//  HeroTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 12/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
  
  @IBOutlet weak var healthProgressView: UIProgressView!
  @IBOutlet weak var healthLabel: UILabel!
  @IBOutlet weak var experienceProgressView: UIProgressView!
  @IBOutlet weak var experienceLabel: UILabel!
  @IBOutlet weak var energyProgressView: UIProgressView!
  @IBOutlet weak var energyLabel: UILabel!
  @IBOutlet weak var pPowerLabel: UILabel!
  @IBOutlet weak var mPowerLabel: UILabel!
  @IBOutlet weak var moneyLabel: UILabel!
  @IBOutlet weak var mightLabel: UILabel!

  func configuredHeroBaseParameters(info hero: HeroBaseParameters) {
    healthLabel.text     = hero.healthRepresentation
    experienceLabel.text = hero.experienceRepresentation
    moneyLabel.text      = hero.moneyRepresentation
    
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.experienceProgressView.setProgress(hero.experienceProgressRepresentation, animated: false)
      strongSelf.healthProgressView.setProgress(hero.healthProgressRepresentation, animated: false)
    }
  }
  
  func configuredHeroSecondParameters(info hero: HeroSecondaryParameters) {
    mPowerLabel.text = hero.mPowerRepresentation
    pPowerLabel.text = hero.pPowerRepresentation
  }
  
  func configuredEnergy(info energy: Energy) {
    energyLabel.text = energy.energyRepresentation
    
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.energyProgressView.setProgress(energy.energyProgressRepresentation, animated: false)
    }
  }
  
  func configuredMight(info might: Might) {
    mightLabel.text = might.mightRepresentation
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
