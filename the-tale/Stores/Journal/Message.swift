//
//  Message.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Message: Hashable, Equatable {
  var timestamp: Double
  var gameTime: String
  var text: String
  
  var hashValue: Int { return timestamp.hashValue }
}

func == (rhs: Message, lhs: Message) -> Bool {
  return rhs.timestamp == lhs.timestamp
}

extension Message: ArrayDecodable {
  init?(arrayObject: NSArray) {
    
    guard let timestamp = arrayObject[0] as? Double,
          let gameTime  = arrayObject[1] as? String,
          let text      = arrayObject[2] as? String else {
      return nil
    }
    
    self.timestamp = timestamp
    self.gameTime  = gameTime
    self.text      = text
    
  }
  
  init?() {
    self.init(arrayObject: [])
  }
}
