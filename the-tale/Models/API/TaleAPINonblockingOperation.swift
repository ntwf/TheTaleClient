//
//  TaleAPIStatusOperation.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func tryActionHelp() {
    networkManager.tryActionHelp { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryActionHelp \(error)")
      default: break
      }
    }
  }
  
  func tryGetCard() {
    networkManager.tryGetCard { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryGetCard \(error)")
      default: break
      }
    }
  }
  
  func tryMergeCard(_ selectedCard: [String: CardInfo]) {
    let uidCards = selectedCard.map({ $0.key })
                               .joined(separator: ",")
    
    networkManager.tryMergeCard(uidCards: uidCards) { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryMergeCard \(error)")
      default: break
      }
    }
  }
  
  func tryUseCard(_ selectedCard: String) {
    networkManager.tryUseCard(uidCard: selectedCard) { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryUseCard \(error)")
      default: break
      }
    }
  }
  
  func tryDropItem() {
    networkManager.tryDropItem { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryDropItem \(error)")
      default: break
      }
    }
  }
  
  func tryChooseQuest(_ chooseQuest: String) {
    networkManager.tryChooseQuest(uidChoose: chooseQuest) { (result) in
      switch result {
      case .success(let data):
        self.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryChooseQuest \(error)")
      default: break
      }
    }
  }
  
  private func checkStatusOperation(operation: NonblockingOperationStatus) {
    guard let pathURL = operation.statusURL else {
      alarm = operation.error ?? "error"
      NotificationCenter.default.post(name: NSNotification.Name("operationAlarm"), object: nil)
      return
    }

    if operation.retry >= 3 {
      debugPrint("Attempts to perform the operation are exhausted. What to do?", operation)
      return
    }
    
    switch operation.status {
    case "processing":
      sleep(UInt32(operation.retry + 1))
      networkManager.checkStatusOperation(url: pathURL) { (result) in
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
      refreshGameInformation()
    case "error":
      alarm = operation.error ?? "error"
      NotificationCenter.default.post(name: NSNotification.Name("operationAlarm"), object: nil)
    default:
      return
    }
  }
  
}
