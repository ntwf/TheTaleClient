//
//  DiaryMessage.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 23/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct DiaryMessage: Hashable, Equatable {
  var position: String
  var gameDate: String
  var gameTime: String
  var message: String
  var type: Int
  var timestamp: Double
  
  var hashValue: Int { return timestamp.hashValue }
}

func == (rhs: DiaryMessage, lhs: DiaryMessage) -> Bool {
  return rhs.timestamp == lhs.timestamp
}

extension DiaryMessage: JSONDecodable {
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
    self.timestamp = timestamp
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension DiaryMessage {
  func dateRepresentation() -> String {
    return "\(gameTime) \(gameDate)"
  }
}
