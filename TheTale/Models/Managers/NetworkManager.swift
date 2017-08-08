//
//  AAPINetworkManager.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

enum APIPath: String {
  case info        = "/api/info"
  case requestAuth = "/accounts/third-party/tokens/api/request-authorisation"
  case login       = "/accounts/auth/api/login"
  case authState   = "/accounts/third-party/tokens/api/authorisation-state"
  case logout      = "/accounts/auth/api/logout"
  case diary       = "/game/api/diary"
  case gameInfo    = "/game/api/info"
  case map         = "/game/map/api/region"
  case mapVersions = "/game/map/api/region-versions"
  case actionHelp  = "/game/abilities/help/api/use"
  case dropItem    = "/game/abilities/drop_item/api/use"
  case getCard     = "/game/cards/api/get"
  case chooseQuest = "/game/quests/api/choose"
  case mergeCard   = "/game/cards/api/combine"
  case useCard     = "/game/cards/api/use"
  
  var version: String {
    switch self {
    case .info, .requestAuth, .login, .authState, .logout, .diary, .actionHelp, .dropItem, .getCard, .chooseQuest, .mergeCard, .useCard:
      return "1.0"
    case .gameInfo:
      return "1.7"
    case .map, .mapVersions:
      return "0.1"
    }
  }
}

enum APIConfiguration: String {
  case client      = "the-tale"
  case info        = "the-tale-ios-client"
  case description = "ios-client"
}
