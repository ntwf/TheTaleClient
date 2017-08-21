//
//  DiaryMessage.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 23/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class DiaryMessage: NSObject {
  
  var position: String
  var gameDate: String
  var gameTime: String
  var message: String
  var type: Int
  var timestamp: Int
  
  override var hashValue: Int {
    return self.timestamp
  }

  init?(jsonObject: JSON) {
    
    guard let position  = jsonObject["position"] as? String,
          let gameDate  = jsonObject["game_date"] as? String,
          let gameTime  = jsonObject["game_time"] as? String,
          let message   = jsonObject["message"] as? String,
          let type      = jsonObject["type"] as? Int,
          let timestamp = jsonObject["timestamp"] as? Double else {
      return nil
    }
    
    self.position  = position
    self.gameDate  = gameDate
    self.gameTime  = gameTime
    self.message   = message
    self.type      = type
    self.timestamp = Int(timestamp)
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? DiaryMessage {
      return timestamp == rhs.timestamp && timestamp == rhs.timestamp
    } else {
      return false
    }
  }
}

extension DiaryMessage {
  static func == (rhs: DiaryMessage, lhs: DiaryMessage) -> Bool {
    return rhs.timestamp == lhs.timestamp
  }
}

extension DiaryMessage {
  var positionRepresentation: String {
    return String(position.capitalizeFirstLetter)
  }
  
  var messageRepresentation: String {
    return String(message.capitalizeFirstLetter)
  }
  
  var dateRepresentation: String {
    return "\(gameTime) \(gameDate)"
  }
}
