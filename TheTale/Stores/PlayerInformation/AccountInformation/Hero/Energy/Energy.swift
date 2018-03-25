//
//  Energy.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Energy: NSObject {
  var bonus: Int
  var max: Int
  var value: Int
  var discount: Int

  required init?(jsonObject: JSON) {
    
    guard let bonus    = jsonObject["bonus"] as? Int,
          let max      = jsonObject["max"] as? Int,
          let value    = jsonObject["value"] as? Int,
          let discount = jsonObject["discount"] as? Int else {
      return nil
    }
    
    self.bonus    = bonus
    self.max      = max
    self.value    = value
    self.discount = discount
  }
}

extension Energy {
  var energyRepresentation: String {
    return "\(value)/\(max) + \(bonus)"
  }
  
  var energyProgressRepresentation: Float {
    return (Float(value) / Float(max))
  }
  
  var energyTotal: Int {
    return bonus + value
  }
}
