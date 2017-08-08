//
//  JournalMessage.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 27/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class JournalMessage: NSObject {
  
  var timestamp: Int
  var gameTime: String
  var text: String
  
  override var hashValue: Int {
    return self.timestamp
  }

  required init?(arrayObject: NSArray) {
    
    guard let timestamp = arrayObject[0] as? Double,
          let gameTime  = arrayObject[1] as? String,
          let text      = arrayObject[2] as? String else {
      return nil
    }
    
    self.timestamp = Int(timestamp)
    self.gameTime  = gameTime
    self.text      = text
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? JournalMessage {
      return timestamp == rhs.timestamp && timestamp == rhs.timestamp
    } else {
      return false
    }
  }
}

extension JournalMessage {
  static func == (rhs: JournalMessage, lhs: JournalMessage) -> Bool {
    return rhs.timestamp == lhs.timestamp
  }
}
