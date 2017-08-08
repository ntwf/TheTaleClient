//
//  HelpBarrierTableViewCell.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class HelpBarrierTableViewCell: UITableViewCell {
  
  @IBOutlet weak var helpBarrierViewBar: UIProgressView!
  @IBOutlet weak var helpCountLabel: UILabel!
  @IBOutlet weak var getCardButton: UIButton!
  @IBOutlet weak var mergeCardButton: UIButton!
  
  func configured() {
    selectionStyle = .none
  }
  
  func configuredHelpBarrier(with card: CardsInfo) {
    helpCountLabel.text = card.helpCountRepresentation()
    
    DispatchQueue.main.async {
      self.helpBarrierViewBar.setProgress(card.helpBarrierProgressRepresentation(), animated: false)
    }
  }
  
  func configuredGetCardButton(isHidden: Bool) {
    getCardButton.isHidden = isHidden
  }
  
  func configuredMergeCardButton(isHidden: Bool) {
    mergeCardButton.isHidden = isHidden
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
