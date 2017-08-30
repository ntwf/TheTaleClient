//
//  TaleAPINonblockingOperation
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {

  // MARK: - Public method. Request data.
  func tryActionHelp(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .actionHelp) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }

  func tryGetCard(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .getCard) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }

  func tryMergeCard(uidCards: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .mergeCard) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }

  func tryUseCard(uidCard: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    var components: [String: String] = [:]
    components["card"]        = uidCard
    
    guard let request = networkManager.createRequest(fromAPI: .useCard, urlParameters: components) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func tryDropItem(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .dropItem) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }

  func tryChooseQuest(uidChoose: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    var components: [String: String] = [:]
    components["option_uid"]  = uidChoose
    
    guard let request = networkManager.createRequest(fromAPI: .chooseQuest, urlParameters: components) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  func fastRegistration(completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = TaleAPI.shared.networkManager.createRequest(fromString: "accounts/registration/fast", method: .post) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
  // MARK: - Public method. Check status operation
  enum StatusOperation {
    case ok, processing, error
  }
  
  func checkStatusOperation(operation: NonblockingOperationStatus) {

    if let error = operation.error {
      debugPrint("checkStatusOperation error \(error)")
      NotificationCenter.default.post(name: .TaleAPINonblockingOperationRecivedAlarm,
                                      object: nil,
                                      userInfo: [TaleAPI.UserInfoKey.nonblockingOperationAlarm: error])
    }
    
    guard let pathURL = operation.statusURL else {
       debugPrint("API didn't return a link to check the status operation. It's ok.", operation)
      return
    }

    if operation.retry >= 3 {
      debugPrint("Attempts to perform the operation are over. What to do?", operation)
      return
    }
    
    switch operation.status {
    case "processing":
      sleep(UInt32(operation.retry + 1))
      fetchStatusOperation(url: pathURL) { (result) in
        switch result {
        case .success(var data):
          data.retry     = operation.retry + 1
          data.statusURL = operation.statusURL
          return self.checkStatusOperation(operation: data)
        case .failure(let error as NSError):
          debugPrint("checkStatusOperation \(error)")
        default: break
        }
      }
    case "ok":
      playerInformationAutorefresh = .start
      
      NotificationCenter.default.post(name: .TaleAPINonblockingOperationStatusChanged,
                                      object: nil,
                                      userInfo: [TaleAPI.UserInfoKey.nonblockingOperationStatus: StatusOperation.ok])
    case "error":
      debugPrint("State of the nonblocking operation is an error.", operation)
      
      NotificationCenter.default.post(name: .TaleAPINonblockingOperationStatusChanged,
                                      object: nil,
                                      userInfo: [TaleAPI.UserInfoKey.nonblockingOperationStatus: StatusOperation.error])
    default:
      return
    }
  }
  
  // MARK: - Internal method. Fetch data.
  private func fetchStatusOperation(url: String, completionHandler: @escaping (APIResult<NonblockingOperationStatus>) -> Void) {
    guard let request = networkManager.createRequest(fromString: url, method: .get) else {
      return
    }

    fetch(request: request, parse: { (json) -> NonblockingOperationStatus? in
      return NonblockingOperationStatus(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
}
