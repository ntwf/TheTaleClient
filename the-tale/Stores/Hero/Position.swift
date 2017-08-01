//
//  Position.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 07/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Position {
  var xCoordinate: Int
  var yCoordinate: Int
  var xDirection: Int
  var yDirection: Int
}

extension Position: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let xCoordinate = jsonObject["x"] as? Int,
          let yCoordinate = jsonObject["y"] as? Int,
          let xDirection  = jsonObject["dx"] as? Int,
          let yDirection  = jsonObject["dy"] as? Int else {
        return nil
    }
    
    self.xCoordinate = xCoordinate
    self.yCoordinate = yCoordinate
    self.xDirection  = xDirection
    self.yDirection  = yDirection
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
