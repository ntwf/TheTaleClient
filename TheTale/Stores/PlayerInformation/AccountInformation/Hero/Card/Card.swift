//
//  CardInfo.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class Card: NSObject {
  
  var auction: Bool
  var name: String
  var rarity: Int
  var type: String
  var uid: Int

  override var hashValue: Int {
    return uid.hashValue
  }
  
  required init?(jsonObject: JSON) {
    
    guard let auction = jsonObject["auction"] as? Bool,
          let name    = jsonObject["name"] as? String,
          let rarity  = jsonObject["rarity"] as? Int,
          let type    = jsonObject["type"] as? Int,
          let uid     = jsonObject["uid"] as? Int else {
        return nil
    }
    
    self.auction = auction
    self.name    = name
    self.rarity  = rarity
    self.type    = String(type)
    self.uid     = uid
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? Card {
      return uid == rhs.uid && uid == rhs.uid
    } else {
      return false
    }
  }
}

extension Card {
  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.uid == rhs.uid
  }
}

extension Card {
  var uidRepresentation: String {
    return String(uid)
  }
  
  var nameRepresentation: String {
    return String(name.capitalizeFirstLetter)
  }
}
