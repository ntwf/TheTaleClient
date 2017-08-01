//
//  Action.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Action {
  var percents: Double
  var description: String
  // var infoLink: String
  var type: Int
  // var isBoss: Bool
}

extension Action: JSONDecodable {
  init?(jsonObject: JSON) {

    guard let percents    = jsonObject["percents"] as? Double,
          let description = jsonObject["description"] as? String,
          // let infoLink = jsonObject["info_link"] as? String,
          // let isBoss   = jsonObject["is_boss"] as? Bool,
          let type        = jsonObject["type"] as? Int else {
        return nil
    }
    
    self.percents    = percents
    self.description = description
    // self.infoLink = infoLink
    self.type        = type
    // self.isBoss   = isBoss
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
