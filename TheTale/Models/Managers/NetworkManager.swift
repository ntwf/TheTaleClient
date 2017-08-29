//
//  NetworkManager.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 28/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

final class NetworkManager {

  // MARK: - Internal constants
  private enum Configuration {
    static let baseURL = URL(string: "http://the-tale.org")
  }
  
  // MARK: - Internal variables
  private let client: String
  private let info: String
  private let description: String
  
  // MARK: - Initialization
  init(client: String, info: String, description: String) {
    self.client      = client
    self.info        = info
    self.description = description
  }

  // MARK: - Configured url components
  private func configured(version path: APIPath) -> String {
    switch path {
    case .info, .requestAuth, .login, .authState, .logout, .diary, .actionHelp, .dropItem, .getCard, .chooseQuest, .mergeCard, .useCard:
      return "1.0"
    case .gameInfo:
      return "1.7"
    case .map, .mapVersions:
      return "0.1"
    }
  }
  
  private func configured(request path: APIPath) -> RequestMethod {
    switch path {
    case .info, .authState, .gameInfo, .diary, .map, .mapVersions:
      return .get
    case .requestAuth, .login, .logout, .actionHelp, .dropItem, .getCard, .chooseQuest, .mergeCard, .useCard:
      return .post
    }
  }

  // MARK: - Create request
  func createRequest(fromAPI path: APIPath, urlParameters: [String: String] = [:], httpParameters: [String: String] = [:]) -> URLRequest? {
    var apiVersion: String = ""
    var urlPath: String    = "" {
      didSet {
        apiVersion = configured(version: path)
      }
    }
    
    urlPath = path.rawValue
    
    var components: [String: String] = [:]
    components["api_version"] = apiVersion
    urlParameters.forEach { components[$0.key] = $0.value }

    let apiRequest = configured(request: path)
    
    return createRequest(fromString: urlPath, method: apiRequest, urlParameters: components, httpParameters: httpParameters)
  }
  
  func createRequest(fromString path: String, method: RequestMethod,
                     urlParameters: [String: String] = [:], httpParameters: [String: String] = [:]) -> URLRequest? {
    
    var components: [String: String] = [:]
    components["api_client"] = client
    urlParameters.forEach { components[$0.key] = $0.value }
    
    var url = createURL(fromString: path)
    url.appendQueryParameters(components)
    
    let request = URLRequest(url, method: method, httpParams: httpParameters)
    return request
  }
  
  // MARK: - Create URL
  func createURL(fromSite path: SitePath) -> URL {
    if path == .main {
      return Configuration.baseURL!
    }
    
    return createURL(fromString: path.rawValue)
  }
  
  func createURL(fromString path: String) -> URL {
    let url = URL(string: path, relativeTo: Configuration.baseURL)!
    return url
  }
}

// MARK: - SitePath
enum SitePath: String {
  case main  = ""
  case guide = "/guide/game"
  case forum = "/forum"
}

// MARK: - APIPath
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
}
