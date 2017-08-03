//
//  HeroSecondaryParameters.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class HeroSecondaryParameters: NSObject {
  
  var maxBagSize: Int
  var mPower: Int
  var pPower: Int
  var moveSpeed: Double
  var lootItemsCount: Int
  var initiative: Int

  required init?(jsonObject: JSON) {
    
    guard let power          = jsonObject["power"] as? [Int],
          let maxBagSize     = jsonObject["max_bag_size"] as? Int,
          let moveSpeed      = jsonObject["move_speed"] as? Double,
          let lootItemsCount = jsonObject["loot_items_count"] as? Int,
          let initiative     = jsonObject["initiative"] as? Int else {
      return nil
    }
    
    self.maxBagSize     = maxBagSize
    self.mPower         = power[1]
    self.pPower         = power[0]
    self.moveSpeed      = moveSpeed
    self.lootItemsCount = lootItemsCount
    self.initiative     = initiative
  }
}

extension HeroSecondaryParameters {
  func mPowerRepresentation() -> String {
    return "\(self.mPower)"
  }
  
  func pPowerRepresentation() -> String {
    return "\(self.pPower)"
  }
  
  func lootItemsCountRepresentation() -> String {
    return "Рюкзак \(Int(self.lootItemsCount))/\(Int(self.maxBagSize))"
  }
}
