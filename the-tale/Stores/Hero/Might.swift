//
//  Might.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Might {
  var value: Double
  var critChance: Double
  var pvpEffectivenessBonus: Double
  var politicsPower: Double
}

extension Might: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let value                 = jsonObject["value"] as? Double,
          let critChance            = jsonObject["crit_chance"] as? Double,
          let pvpEffectivenessBonus = jsonObject["pvp_effectiveness_bonus"] as? Double,
          let politicsPower         = jsonObject["politics_power"] as? Double else {
        return nil
    }
    
    self.value                 = value
    self.critChance            = critChance
    self.pvpEffectivenessBonus = pvpEffectivenessBonus
    self.politicsPower         = politicsPower
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension Might {
  func mightRepresentation() -> String {
    return "\(Int(self.value))"
  }
}
