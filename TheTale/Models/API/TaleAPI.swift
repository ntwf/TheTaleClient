//
//  TaleAPI.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 24/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension Notification.Name {
  static let TaleAPINonblockingOperationRecivedAlarm  = NSNotification.Name("TaleAPINonblockingOperationRecivedAlarm")
  static let TaleAPINonblockingOperationStatusChanged = NSNotification.Name("TaleAPINonblockingOperationStatusChanged")
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
  
  // MARK: User info
  enum UserInfoKey {
    static let nonblockingOperationAlarm  = "TaleAPINonblockingOperationAlarm"
    static let nonblockingOperationStatus = "TaleAPINonblockingOperationStatus"
  }
  
  // MARK: Key path
  enum NotificationKeyPath {
    static let action                  = #keyPath(TaleAPI.playerInformationManager.action)
    static let bag                     = #keyPath(TaleAPI.playerInformationManager.bag)
    static let cardsInfo               = #keyPath(TaleAPI.playerInformationManager.cardsInfo)
    static let companion               = #keyPath(TaleAPI.playerInformationManager.companion)
    static let diary                   = #keyPath(TaleAPI.diaryManager.diary)
    static let energy                  = #keyPath(TaleAPI.playerInformationManager.energy)
    static let equipment               = #keyPath(TaleAPI.playerInformationManager.equipment)
    static let heroBaseParameters      = #keyPath(TaleAPI.playerInformationManager.heroBaseParameters)
    static let heroSecondaryParameters = #keyPath(TaleAPI.playerInformationManager.heroSecondaryParameters)
    static let journal                 = #keyPath(TaleAPI.playerInformationManager.journal)
    static let quests                  = #keyPath(TaleAPI.playerInformationManager.quests)
    static let turn                    = #keyPath(TaleAPI.playerInformationManager.turn)
  }
}
