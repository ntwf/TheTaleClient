//
//  TaleAPIGameInformation.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

enum TimerState {
  case start
  case stop
}

extension TaleAPI {

  func updateTimerState(newState: TimerState) {
    guard timerState != newState else { return }
    timerState = newState
  }
  
  func refreshGameInformation() {
    stopRefreshGameInformation()
    
    fetchBasicInformation()
    fetchGameInformation()
    
    startRefreshGameInformation()
  }
  
  func stopRefreshGameInformation() {
    autoUpdateTimer.invalidate()
  }
  
  func startRefreshGameInformation() {
    autoUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchGameInformation), userInfo: nil, repeats: true)
  }
  
  func fetchGameInformation() {
    let turns = getTurn(needConciseAnswer: true)
    
    networkManager.fetchGameInformation(turn: turns) { (result) in
      switch result {
      case .success(let data):
        self.gameInformation = data
        
        self.dataManager.getAccountInformation()
        self.dataManager.getHeroInformation()
        self.dataManager.getJournalMessages()
        self.dataManager.getJournalAction()
      
      case.failure(let error as NSError):
        self.reconnectCounter += 1

        if self.reconnectCounter == 3 {
          self.stopRefreshGameInformation()
          self.reconnectCounter = 0
        }
        
        debugPrint("fetchGameInformation \(error)")
      default: break
      }
    }
  }
  
  private func fetchBasicInformation() {
    networkManager.fetchBasicInformation { (result) in
      switch result {
      case .success(let data):
        self.basicInformation = data
      case .failure(let error as NSError):
        debugPrint("fetchBasicInformation \(error)")
      default: break
      }
    }
  }
  
  private func getTurn(needConciseAnswer: Bool) -> String {
    guard let turnNumber = turn?.number else {
      return ""
    }
    
    clientTurns.append(String(turnNumber))
    
    while clientTurns.count > 3 {
      clientTurns.removeFirst()
    }
    
    if needConciseAnswer {
      return clientTurns.joined(separator: ",")
    }
    return ""
  }
  
}
