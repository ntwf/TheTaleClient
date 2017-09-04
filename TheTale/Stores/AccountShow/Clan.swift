//
//  Clan.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Clan {
  var id: Int
  var abbr: Int
  var name: String
}

extension Clan {
  init?(jsonObject: JSON) {
    guard let id   = jsonObject["id"] as? Int,
          let abbr = jsonObject["abbr"] as? Int,
          let name = jsonObject["name"] as? String else {
        return nil
    }
    
    self.id   = id
    self.abbr = abbr
    self.name = name
  }
}
