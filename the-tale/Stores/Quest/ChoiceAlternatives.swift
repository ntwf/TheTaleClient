//
//  ChoiceAlternatives.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class ChoiceAlternatives: NSObject {
  
  var choiceID: String
  var info: String

  required init?(arrayObject: NSArray) {
    
    guard let choiceID = arrayObject[0] as? String,
          let info     = arrayObject[1] as? String else {
      return nil
    }
    
    self.choiceID = choiceID
    self.info     = info
  }
}
