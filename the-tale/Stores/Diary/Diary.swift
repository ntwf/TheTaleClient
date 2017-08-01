//
//  DiaryMessages.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 29/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Diary {
  var messages: [DiaryMessage]
}

extension Diary: JSONDecodable {
  init?(jsonObject: JSON) {
    
    var messages: [DiaryMessage] = []
    
    guard let jsonMessages = jsonObject["messages"] as? [JSON] else {
      return nil
    }
    
    for jsonMessage in jsonMessages {
      guard let message = DiaryMessage(jsonObject: jsonMessage) else {
          return nil
      }
      messages.append(message)
    }
    
    self.messages = messages
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
