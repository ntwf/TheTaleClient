//
//  showAccount.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct AccountShow {
  var id: Int
  var registered: Bool
  var name: String
  var heroID: Int
  var placesHistory: [PlacesHistory]
  var might: Double
  var achievements: Int
  var collections: Int
  var referrals: Int
  var ratings: [String: Rating]
  var canAffectGame: Bool
  var description: String
  var clan: Clan?
}

extension AccountShow {
  init?(jsonObject: JSON) {

    guard let id                 = jsonObject["id"] as? Int,
          let registered         = jsonObject["registered"] as? Bool,
          let name               = jsonObject["name"] as? String,
          let heroID             = jsonObject["hero_id"] as? Int,
          let placesHistoryArray = jsonObject["places_history"] as? [JSON],
          let might              = jsonObject["might"] as? Double,
          let achievements       = jsonObject["achievements"] as? Int,
          let collections        = jsonObject["collections"] as? Int,
          let referrals          = jsonObject["referrals"] as? Int,
          let ratingsDict        = jsonObject["ratings"] as? JSON,
          let permissionsDict    = jsonObject["permissions"] as? JSON,
          let canAffectGame      = permissionsDict["can_affect_game"] as? Bool,
          let description        = jsonObject["description"] as? String else {
        return nil
    }
    
    var placesHistory: [PlacesHistory] = []
    for place in placesHistoryArray {
      if let data = PlacesHistory(jsonObject: place) {
        placesHistory.append(data)
      }
    }

    var ratings: [String: Rating] = [:]
    for (key, value) in ratingsDict {
      if let value = value as? JSON,
         let data = Rating(jsonObject: value) {
        ratings[key] = data
      }
    }
    
    if let clanDict = jsonObject["clan"] as? JSON,
       let clan     = Clan(jsonObject: clanDict) {
      self.clan = clan
    }
    
    self.id            = id
    self.registered    = registered
    self.name          = name
    self.heroID        = heroID
    self.placesHistory = placesHistory
    self.might         = might
    self.achievements  = achievements
    self.collections   = collections
    self.referrals     = referrals
    self.ratings       = ratings
    self.canAffectGame = canAffectGame
    self.description   = description
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
