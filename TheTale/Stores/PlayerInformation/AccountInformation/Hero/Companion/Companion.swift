//
//  Companion.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Companion: NSObject {

  var coherence: Int
  var experience: Double
  var experienceToLevel: Double
  var health: Double
  var maxHealth: Double
  var name: String
  var realCoherence: Int
  var type: Int

  required init?(jsonObject: JSON) {
    
    guard let coherence         = jsonObject["coherence"] as? Int,
          let experience        = jsonObject["experience"] as? Double,
          let experienceToLevel = jsonObject["experience_to_level"] as? Double,
          let health            = jsonObject["health"] as? Double,
          let maxHealth         = jsonObject["max_health"] as? Double,
          let name              = jsonObject["name"] as? String,
          let realCoherence     = jsonObject["real_coherence"] as? Int,
          let type              = jsonObject["type"] as? Int else {
      return nil
    }
    
    self.coherence         = coherence
    self.experience        = experience
    self.experienceToLevel = experienceToLevel
    self.health            = health
    self.maxHealth         = maxHealth
    self.name              = name
    self.realCoherence     = realCoherence
    self.type              = type
  }
}

extension Companion {
  func levelRepresentation() -> String {
    return "\(self.coherence)"
  }

  func nameRepresentation() -> String {
    return "\(self.coherence) \(self.name)"
  }
  
  func healthRepresentation() -> String {
    return "\(Int(self.health))/\(Int(self.maxHealth))"
  }
  
  func experienceRepresentation() -> String {
    return "\(Int(self.experience))/\(Int(self.experienceToLevel))"
  }
  
  func healthProgressRepresentation() -> Float {
    return (Float(self.health) / Float(self.maxHealth))
  }
  
  func experienceProgressRepresentation() -> Float {
    return (Float(self.experience) / Float(self.experienceToLevel))
  }
}
