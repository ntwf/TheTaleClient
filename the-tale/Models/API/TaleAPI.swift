//
//  TaleAPI.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 24/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class TaleAPI: NSObject {

  class var shared: TaleAPI {
    struct Singleton {
      static let instance = TaleAPI()
    }
    return Singleton.instance
  }
  
  // Managers
  var networkManager: NetworkManager
  var dataManager: DataManager
  
  // Internal variables
  var autoUpdateTimer       = Timer()
  var clientTurns: [String] = []
  var mapVersion            = MapVersions()
  var reconnectCounter      = 0
  
  var timerState: TimerState = .start {
    didSet {
      switch timerState {
      case .stop:
        stopRefreshGameInformation()
      case .start:
        refreshGameInformation()
      }
    }
  }
  
  // External variables
  var authorisationState            = AuthorisationState()
  var loginState                    = Login()
  var gameInformation               = GameInformation()
  var messages: [Message]           = []
  var action                        = Action()
  var diaryMessages: [DiaryMessage] = []
  var hero                          = Hero()
  var heroBaseParameters            = HeroBaseParameters()
  var heroSecondaryParameters       = HeroSecondaryParameters()
  var heroPosition                  = Position()
  var energy                        = Energy()
  var might                         = Might()
  var companion                     = Companion()
  var equipment: [Artifact]         = []
  var bag: [Artifact]               = []
  var quests: [Quest]               = []
  var cards                         = Cards()
  var map                           = Map()
  var turn                          = Turn()
  var basicInformation              = BasicInformation()
  var alarm                         = ""
  
  override init() {
    networkManager = NetworkManager(sessionConfiguration: URLSessionConfiguration.default)
    dataManager    = DataManager()
  }
  
}
