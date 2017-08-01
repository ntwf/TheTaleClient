//
//  QuestTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {
  
  @IBOutlet weak var questImageView: UIImageView!
  @IBOutlet weak var questNameLabel: UILabel!
  @IBOutlet weak var experienceLabel: UILabel!
  @IBOutlet weak var actionLabel: UILabel!

  func configuredQuest(info quest: Quest) {
    questImageView.image = UIImage(named: quest.type)
    questNameLabel.text  = quest.nameRepresentation()
    actionLabel.text     = quest.actionRepresentation()
    
    if quest.experience == 0, quest.power == 0 {
      experienceLabel.isHidden = true
    } else {
      experienceLabel.text = quest.experienceRepresentation()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
