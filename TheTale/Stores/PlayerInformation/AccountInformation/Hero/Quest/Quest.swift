//
//  Quest.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Quest: NSObject {
  
  var action: String
  var choice: String?
  var experience: Int
  var name: String
  var power: Int
  var type: String
  var uid: String
  var actors: [Actor]
  var choiceAlternatives: [ChoiceAlternatives]

  required init?(jsonObject: JSON) {

    guard let action     = jsonObject["action"] as? String,
          let experience = jsonObject["experience"] as? Int,
          let name       = jsonObject["name"] as? String,
          let power      = jsonObject["power"] as? Int,
          let type       = jsonObject["type"] as? String,
          let uid        = jsonObject["uid"] as? String else {
      return nil
    }
    
    var actors: [Actor] = []
    if let actorsArray = jsonObject["actors"] as? NSArray {
      for actorArray in actorsArray {
        guard let actor = actorArray as? NSArray,
              let data  = Actor(arrayObject: actor) else {
            break
        }
        actors.append(data)
      }
    }
    
    var choiceAlternatives: [ChoiceAlternatives] = []
    if let choiceAlternativesArray = jsonObject["choice_alternatives"] as? NSArray {
      for choiceAlternative in choiceAlternativesArray {
        guard let choiceAlternativeArray = choiceAlternative as? NSArray,
              let data = ChoiceAlternatives(arrayObject: choiceAlternativeArray) else {
            break
        }
        choiceAlternatives.append(data)
      }
    }
    
    self.action             = action
    self.choice             = jsonObject["choice"] as? String
    self.experience         = experience
    self.name               = name
    self.power              = power
    self.type               = type
    self.uid                = uid
    self.actors             = actors
    self.choiceAlternatives = choiceAlternatives
    
  }
  
  convenience override init() {
    self.init(jsonObject: [:])!
  }
}

extension Quest {
  func choiceRepresentation() -> String? {
    if let data = choice {
      return data.capitalizeFirstLetter
    }
    return nil
  }
  
  func experienceRepresentation() -> String {
    return "(+\(power) опыта, +\(experience) влияния)"
  }
  
  func actionRepresentation() -> String {
    return action.capitalizeFirstLetter
  }
  
  func nameRepresentation() -> String {
    return name.capitalizeFirstLetter
  }
}
