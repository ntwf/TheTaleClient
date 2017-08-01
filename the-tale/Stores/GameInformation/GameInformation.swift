//
//  gameInformation.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct GameInformation {
  var gameState: Int
  var mapVersion: String
  var mode: String
  var account: JSON
  var turn: JSON
}

extension GameInformation: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let gameState  = jsonObject["game_state"] as? Int,
          let mapVersion = jsonObject["map_version"] as? String,
          let mode       = jsonObject["mode"] as? String,
          let turn       = jsonObject["turn"] as? JSON,
          let account    = jsonObject["account"] as? JSON else {
        return nil
    }
    
    self.gameState  = gameState
    self.mapVersion = mapVersion
    self.mode       = mode
    self.account    = account
    self.turn       = turn
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
