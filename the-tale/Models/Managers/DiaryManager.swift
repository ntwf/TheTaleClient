//
//  DiaryManager.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class DiaryManager: NSObject {
  
  dynamic var diary: [DiaryMessage]           = []
  
  private var recivedMessages: [DiaryMessage] = []
  
  func getNewMessages(jsonObject: JSON) {
    var messages: [DiaryMessage] = []
    
    guard let jsonMessages = jsonObject["messages"] as? [JSON] else {
      return
    }
    
    for jsonMessage in jsonMessages {
      guard let message = DiaryMessage(jsonObject: jsonMessage) else {
        return
      }
      messages.append(message)
    }

    let newMessages    = Set(messages).subtracting(Set(recivedMessages))
    let sortedMessages = newMessages.sorted(by: { $0.timestamp < $1.timestamp })

    recivedMessages = messages
    diary           = sortedMessages
  }
}
