//
//  Info.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 14/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct BasicInformation {
  var accountID: Int
  var accountName: String
  var gameVersion: String
  var staticContent: String
  var turnDelta: Int
  var arenaPvP: Int
  var arenaPvPAccept: Int
  var arenaPvPLeaveQueue: Int
  var help: Int
  var buildingRepair: Int
  var dropItem: Int
}

extension BasicInformation: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let accountID          = jsonObject["account_id"] as? Int,
          let accountName        = jsonObject["account_name"] as? String,
          let gameVersion        = jsonObject["game_version"] as? String,
          let staticContent      = jsonObject["static_content"] as? String,
          let turnDelta          = jsonObject["turn_delta"] as? Int,
          let abilitiesCost      = jsonObject["abilities_cost"] as? JSON,
          let arenaPvP           = abilitiesCost["arena_pvp_1x1"] as? Int,
          let arenaPvPAccept     = abilitiesCost["arena_pvp_1x1_accept"] as? Int,
          let arenaPvPLeaveQueue = abilitiesCost["arena_pvp_1x1_leave_queue"] as? Int,
          let help               = abilitiesCost["help"] as? Int,
          let buildingRepair     = abilitiesCost["building_repair"] as? Int,
          let dropItem           = abilitiesCost["drop_item"] as? Int else {
        return nil
    }
    
    self.accountID          = accountID
    self.accountName        = accountName
    self.gameVersion        = gameVersion
    self.staticContent      = staticContent
    self.turnDelta          = turnDelta
    self.arenaPvP           = arenaPvP
    self.arenaPvPAccept     = arenaPvPAccept
    self.arenaPvPLeaveQueue = arenaPvPLeaveQueue
    self.help               = help
    self.buildingRepair     = buildingRepair
    self.dropItem           = dropItem
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
