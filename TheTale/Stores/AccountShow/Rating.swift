//
//  Rating.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Rating {
  var name: String
  var place: Int
  var value: Double
}

extension Rating {
  init?(jsonObject: JSON) {
    guard let name  = jsonObject["name"] as? String,
          let place = jsonObject["place"] as? Int,
          let value = jsonObject["value"] as? Double else {
        return nil
    }
    
    self.name  = name
    self.place = place
    self.value = value
  }
}
