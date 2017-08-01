//
//  Actor.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Actor {
  var nameActors: String
  var typeActors: Int
  var gender: Int?
  var actorsID: Int?
  var name: String?
  var personalityCosmetic: Int?
  var personalityPractical: Int?
  var place: Int?
  var profession: Int?
  var race: String?
  var description: String?
  var goal: String?
}

extension Actor: ArrayDecodable {
  init?(arrayObject: NSArray) {
    
    guard let nameActors = arrayObject[0] as? String,
          let typeActors = arrayObject[1] as? Int,
          let actorJSON  = arrayObject[2] as? JSON else {
      return nil
    }
    
    let race        = String(describing: actorJSON["race"] as? Int)
    let personality = actorJSON["personality"] as? JSON
    
    self.nameActors           = nameActors
    self.typeActors           = typeActors
    self.gender               = actorJSON["gender"] as? Int
    self.actorsID             = actorJSON["id"] as? Int
    self.name                 = actorJSON["name"] as? String
    self.personalityCosmetic  = personality?["cosmetic"] as? Int
    self.personalityPractical = personality?["practical"] as? Int
    self.place                = actorJSON["place"] as? Int
    self.profession           = actorJSON["profession"] as? Int
    self.race                 = String(describing: Types.shared.common?.race[race])
    self.description          = actorJSON["description"] as? String
    self.goal                 = actorJSON["goal"] as? String
    
  }
  
  init?() {
    self.init(arrayObject: [])
  }
}

extension Actor {
  func nameActorsRepresentation() -> String {
    return "\(self.nameActors.capitalizeFirstLetter):"
  }
}
