//
//  Place.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Place {
  var id: Int
  var name: String
}

extension Place {
  init?(jsonObject: JSON) {
    guard let id   = jsonObject["id"] as? Int,
          let name = jsonObject["name"] as? String else {
        return nil
    }
    
    self.id   = id
    self.name = name
  }
}
