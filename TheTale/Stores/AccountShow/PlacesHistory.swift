//
//  PlacesHistory.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct PlacesHistory {
  var count: Int
  var place: Place
}

extension PlacesHistory {
  init?(jsonObject: JSON) {
    guard let count     = jsonObject["count"] as? Int,
          let placeDict = jsonObject["place"] as? JSON,
          let place     = Place(jsonObject: placeDict) else {
      return nil
    }
    
    self.count = count
    self.place = place
  }
}
