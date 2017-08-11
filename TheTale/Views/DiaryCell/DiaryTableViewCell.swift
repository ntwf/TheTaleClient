//
//  DiaryTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  func configuredDiary(diary message: DiaryMessage) {
    locationLabel.text = message.positionRepresentation()
    dateLabel.text     = message.dateRepresentation()
    messageLabel.text  = message.message
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
