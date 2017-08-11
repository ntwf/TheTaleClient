//
//  PlaceInfo.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 04/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct PlaceInfo {
  var placeID: Int
  var name: String
  var posX: Int
  var posY: Int
  var race: Int
  var size: Int
}

extension PlaceInfo: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let placeID = jsonObject["id"] as? Int,
          let name    = jsonObject["name"] as? String,
          let pos     = jsonObject["pos"] as? JSON,
          let posX    = pos["x"] as? Int,
          let posY    = pos["y"] as? Int,
          let race    = jsonObject["race"] as? Int,
          let size    = jsonObject["size"] as? Int else {
        return nil
    }
    
    self.placeID = placeID
    self.name    = name
    self.posX    = posX
    self.posY    = posY
    self.race    = race
    self.size    = size
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension PlaceInfo {
  func nameRepresentation() -> String {
    return " (\(size)) \(name) "
  }
}
