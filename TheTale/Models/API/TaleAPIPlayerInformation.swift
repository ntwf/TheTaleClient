//
//  TaleAPIAccountInformation.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {

  func getPlayerInformation() {
    // needConciseAnswer - it's necessary for PvP mode. In PvP mode the first request shouldn't be abbreviated. Now isn't used.
    let turns = getTurn(needConciseAnswer: true)
    
    fetchPlayerInformation(turn: turns) { [weak self] (result) in
      switch result {
      case .success(let data):
        self?.playerInformationManager.getPlayerInformation(from: data)
      case.failure(let error as NSError):
        self?.reconnectCounter += 1

        if self?.reconnectCounter == 3 {
          self?.playerInformationAutorefresh = .stop
          self?.reconnectCounter = 0
        }
        
        debugPrint("fetchPlayerInformation \(error)")
      default: break
      }
    }
  }

  private func getTurn(needConciseAnswer: Bool) -> String {
    guard let turn = playerInformationManager.turn?.number else {
      return ""
    }
    
    clientTurns.append(String(turn))
    
    while clientTurns.count > 3 {
      clientTurns.removeFirst()
    }
    
    if needConciseAnswer {
      return clientTurns.joined(separator: ",")
    }
    return ""
  }

  private func fetchPlayerInformation(turn: String, completionHandler: @escaping (APIResult<PlayerInformation>) -> Void) {
    var components: [String: String] = [:]
    components["client_turns"] = turn
    
    guard let request = networkManager.createRequest(fromAPI: .gameInfo, urlParameters: components) else {
      return
    }

    fetch(request: request, parse: { (json) -> PlayerInformation? in
      if let dictionary = json["data"] as? JSON {
        return PlayerInformation(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}
