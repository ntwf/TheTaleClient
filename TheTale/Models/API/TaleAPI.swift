//
//  TaleAPI.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 24/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension Notification.Name {
  static let TaleAPINonblockingOperationRecivedAlarm = NSNotification.Name("TaleAPINonblockingOperationRecivedAlarm")
}

enum TimerState {
  case start
  case stop
}

class TaleAPI: NSObject, NetworkClient {
  
  // MARK: Singleton
  static let shared = TaleAPI()

  // MARK: Network variable
  var sessionConfiguration: URLSessionConfiguration
  var session: URLSession

  // MARK: Managers
  var playerInformationManager: PlayerInformationManager
  var gameInformationManager: GameInformationManager
  var diaryManager: DiaryManager
  var networkManager: NetworkManager
  
  // MARK: Configuration
  enum Configuration {
    static let networkClient      = "the-tale"
    static let networkInfo        = "the-tale-ios-client"
    static let networkDescription = "ios-client"
    
    static let applicationName        = "The Tale iOS Client"
    static let applicationInfo        = "\(UIDevice.current.name)"
    static let applicationDescription = "iOS client for The Tale."
  }
  
  // MARK: Initializer
  private override init() {
    self.sessionConfiguration = URLSessionConfiguration.default
    self.session              = URLSession(configuration: sessionConfiguration)

    playerInformationManager = PlayerInformationManager()
    gameInformationManager   = GameInformationManager()
    diaryManager             = DiaryManager()
    networkManager           = NetworkManager(client: Configuration.networkClient,
                                              info: Configuration.networkInfo,
                                              description: Configuration.networkDescription)
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
  
  // MARK: User info
  enum UserInfoKey {
    static let nonblockingOperation = "TaleAPINonblockingOperation"
  }
}
