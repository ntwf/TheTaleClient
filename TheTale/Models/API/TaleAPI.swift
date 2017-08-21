//
//  TaleAPI.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 24/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class TaleAPI: NSObject, NetworkClient {
  
  // MARK: Singleton
  static let shared = TaleAPI()

  // MARK: Network variable
  var sessionConfiguration: URLSessionConfiguration
  var session: URLSession
  
  let baseURL      = "http://the-tale.org"
  let gameGuideURL = "http://the-tale.org/guide/game"
  let gameForumURL = "http://the-tale.org/forum"
  
  var httpParams: JSON
  var pathComponents: JSON

  // MARK: Managers
  var playerInformationManager: PlayerInformationManager
  var gameInformationManager: GameInformationManager
  var diaryManager: DiaryManager
  
  // MARK: Initializer
  private override init() {
    self.sessionConfiguration = URLSessionConfiguration.default
    self.session              = URLSession(configuration: sessionConfiguration)
    
    httpParams     = [:]
    pathComponents = [:]

    playerInformationManager = PlayerInformationManager()
    gameInformationManager   = GameInformationManager()
    diaryManager             = DiaryManager()
  }
  
  // MARK: Internal variables
  var playerInformationTimer  = Timer()
  var clientTurns: [String] = []
  var reconnectCounter      = 0
  
  var playerInformationAutorefresh: TimerState = .stop {
    didSet {
      switch playerInformationAutorefresh {
      case .start:
        playerInformationTimer.invalidate()
        
        getGameInformation()
        getPlayerInformation()
        
        playerInformationTimer = Timer.scheduledTimer(timeInterval: 10,
                                                      target: self,
                                                      selector: #selector(getPlayerInformation),
                                                      userInfo: nil,
                                                      repeats: true)
      case .stop:
        playerInformationTimer.invalidate()
      }
    }
  }
  
  // MARK: External variables
  var authorisationState = AuthorisationState()
  var isSigned           = false
  
}

enum TimerState {
  case start
  case stop
}
