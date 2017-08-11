//
//  HeroBaseParameters.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class HeroBaseParameters: NSObject {

  var alive: Bool
  var destinyPoints: Int
  var experience: Int
  var experienceToLevel: Int
  var gender: Int
  var health: Int
  var level: Int
  var maxHealth: Int
  var money: Int
  var name: String
  var race: String

  required init?(jsonObject: JSON) {
    
    guard let alive             = jsonObject["alive"] as? Bool,
          let destinyPoints     = jsonObject["destiny_points"] as? Int,
          let experience        = jsonObject["experience"] as? Int,
          let experienceToLevel = jsonObject["experience_to_level"] as? Int,
          let gender            = jsonObject["gender"] as? Int,
          let health            = jsonObject["health"] as? Int,
          let level             = jsonObject["level"] as? Int,
          let maxHealth         = jsonObject["max_health"] as? Int,
          let money             = jsonObject["money"] as? Int,
          let name              = jsonObject["name"] as? String,
          let race              = jsonObject["race"] as? Int else {
      return nil
    }
    
    self.alive             = alive
    self.destinyPoints     = destinyPoints
    self.experience        = experience
    self.experienceToLevel = experienceToLevel
    self.gender            = gender
    self.health            = health
    self.level             = level
    self.maxHealth         = maxHealth
    self.money             = money
    self.name              = name
    self.race              = String(describing: Types.shared.common?.race[String(race)])
  }
}

extension HeroBaseParameters {
  func levelRepresentation() -> String {
    return "\(level)"
  }
  
  func moneyRepresentation() -> String {
    return "\(money)"
  }
  
  func healthRepresentation() -> String {
    return "\(Int(health))/\(Int(maxHealth))"
  }
  
  func experienceRepresentation() -> String {
    return "\(Int(experience))/\(Int(experienceToLevel))"
  }
  
  func healthProgressRepresentation() -> Float {
    return (Float(health) / Float(maxHealth))
  }
  
  func experienceProgressRepresentation() -> Float {
    return (Float(experience) / Float(experienceToLevel))
  }
  
  func nameRepresentation() -> String {
    return "\(level) \(name)"
  }
}
