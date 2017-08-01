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

final class NetworkManager: NetworkClient {

  var sessionConfiguration: URLSessionConfiguration
  var session: URLSession
  
  var httpParams: JSON
  var pathComponents: JSON
  
  let baseURL = "http://the-tale.org"
  
  init(sessionConfiguration: URLSessionConfiguration) {
    self.sessionConfiguration = URLSessionConfiguration.default
    
    self.session = URLSession(configuration: sessionConfiguration)
    
    httpParams = [:]
    pathComponents = [:]
  }
  
  func fetchBasicInformation(completionHandler: @escaping (APIResult<BasicInformation>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.info.version

    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.info.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> BasicInformation? in
      if let dictionary = json["data"] as? JSON {
        return BasicInformation(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
  func login(email: String, password: String, completionHandler: @escaping (APIResult<Login>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.login.version
    
    httpParams.removeAll()
    httpParams["next_url"] = ""
    httpParams["email"]    = email
    httpParams["password"] = password
    httpParams["remember"] = "on"
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.login.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> Login? in
      if let dictionary = json["data"] as? JSON {
        return Login(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
    
  }
  
  func logout(completionHandler: @escaping (APIResult<Logout>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.logout.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.logout.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> Logout? in
      return Logout(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func fetchAuthorisationState(completionHandler: @escaping (APIResult<AuthorisationState>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.authState.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.authState.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> AuthorisationState? in
      if let dictionary = json["data"] as? JSON {
        return AuthorisationState(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
  func fetchDiary(completionHandler: @escaping (APIResult<Diary>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.diary.version
    
    httpParams.removeAll()

    let request = URLRequest(baseURL: baseURL, path: APIPath.diary.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> Diary? in
      if let dictionary = json["data"] as? JSON {
        return Diary(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
  func fetchGameInformation(turn: String, completionHandler: @escaping (APIResult<GameInformation>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]   = APIConfiguration.client.rawValue
    pathComponents["api_version"]  = APIPath.gameInfo.version
    pathComponents["client_turns"] = turn
    
    httpParams.removeAll()

    let request = URLRequest(baseURL: baseURL, path: APIPath.gameInfo.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> GameInformation? in
      if let dictionary = json["data"] as? JSON {
        return GameInformation(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }

  func fetchMap(turn: String, completionHandler: @escaping (APIResult<JSON>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.map.version
    pathComponents["turn"]        = turn
    
    httpParams.removeAll()

    let request = URLRequest(baseURL: baseURL, path: APIPath.map.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> JSON? in
      if let dictionary = json["data"] as? JSON {
        return dictionary
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
  func fetchMapVersions(completionHandler: @escaping (APIResult<MapVersions>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.mapVersions.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.mapVersions.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> MapVersions? in
      if let dictionary = json["data"] as? JSON {
        return MapVersions(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
  func tryActionHelp(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.actionHelp.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.actionHelp.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryDropItem(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.dropItem.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.dropItem.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryGetCard(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.getCard.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.getCard.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryMergeCard(uidCards: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.mergeCard.version
    pathComponents["cards"]       = uidCards
    
    httpParams.removeAll()

    let request = URLRequest(baseURL: baseURL, path: APIPath.mergeCard.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryUseCard(uidCard: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.useCard.version
    pathComponents["card"]        = uidCard
    
    httpParams.removeAll()
//  httpParams["person"]   = ""
//  httpParams["place"]    = ""
//  httpParams["building"] = ""
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.useCard.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryChooseQuest(uidChoose: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.chooseQuest.version
    pathComponents["option_uid"]  = uidChoose
    
    httpParams.removeAll()

    let request = URLRequest(baseURL: baseURL, path: APIPath.chooseQuest.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func checkStatusOperation(url: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: url, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
}
