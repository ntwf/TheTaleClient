//
//  JournalMessages.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 27/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct JournalMessages {
  var messages: [Message]
}

extension JournalMessages: JSONDecodable {
  init?(jsonObject: JSON) {
    
    var messages: [Message] = []
    
    guard let arrayMessages = jsonObject["messages"] as? NSArray else {
      return nil
    }
    
    for arrayMessage in arrayMessages {
      guard let arrayMessage = arrayMessage as? NSArray,
            let message = Message(arrayObject: arrayMessage) else {
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
