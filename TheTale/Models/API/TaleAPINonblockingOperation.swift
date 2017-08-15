//
//  TaleAPIStatusOperation.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {

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
    // Blank for future opportunities.
    // httpParams["person"]   = ""
    // httpParams["place"]    = ""
    // httpParams["building"] = ""
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.useCard.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
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
  
  func checkStatusOperation(operation: NonblockingOperationStatus) {
    if let error = operation.error {
      NotificationCenter.default.post(name: .nonblockingOperationAlarm, object: nil, userInfo: ["alarm": error])
    }

    guard let pathURL = operation.statusURL,
          operation.retry <= 3 else {
      return
    }
    
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch operation.status {
      case "processing":
        sleep(UInt32(operation.retry + 1))
        strongSelf.fetchStatusOperation(url: pathURL) { (result) in
          switch result {
          case .success(var data):
            data.retry     = operation.retry + 1
            data.statusURL = operation.statusURL
            return strongSelf.checkStatusOperation(operation: data)
          case .failure(let error as NSError):
            debugPrint("checkStatusOperation \(error)")
          default: break
          }
        }
      case "ok":
        strongSelf.playerInformationAutorefresh = .start
      case "error":
        debugPrint("State of the nonblocking operation is an error.", operation)
      default:
        return
      }
    }
  }
  
  private func fetchStatusOperation(url: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: url, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
}
