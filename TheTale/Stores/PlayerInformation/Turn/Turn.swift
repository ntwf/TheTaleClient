//
//  Turn.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Turn: NSObject {

  var number: Int
  var verboseDate: String
  var verboseTime: String

  required init?(jsonObject: JSON) {
    
    guard let number      = jsonObject["number"] as? Int,
          let verboseDate = jsonObject["verbose_date"] as? String,
          let verboseTime = jsonObject["verbose_time"] as? String else {
      return nil
    }
    
    self.number      = number
    self.verboseDate = verboseDate
    self.verboseTime = verboseTime
  }
}

extension Turn {
  var timeRepresentation: String {
    return "\(verboseTime) \(verboseDate)"
  }
}
