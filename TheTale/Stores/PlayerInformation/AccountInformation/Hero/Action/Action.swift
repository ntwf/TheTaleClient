//
//  Action.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Action: NSObject {
  
  var percents: Double
  var info: String
  // var infoLink: String
  // var isBoss: Bool
  var type: Int
  
  required init?(jsonObject: JSON) {

    guard let percents    = jsonObject["percents"] as? Double,
          let info        = jsonObject["description"] as? String,
          // let infoLink = jsonObject["info_link"] as? String,
          // let isBoss   = jsonObject["is_boss"] as? Bool,
          let type        = jsonObject["type"] as? Int else {
      return nil
    }
    
    self.percents    = percents
    self.info        = info
    // self.infoLink = infoLink
    // self.isBoss   = isBoss
    self.type        = type
  }
}
