//
//  CardInfo.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct CardInfo {
  var auction: Bool
  var name: String
  var rarity: Int
  var type: String
  var uid: Int
}

extension CardInfo: Equatable {
}

extension CardInfo: Hashable {
  var hashValue: Int { return uid.hashValue }
}

func == (lhs: CardInfo, rhs: CardInfo) -> Bool {
  return lhs.uid == rhs.uid
}

extension CardInfo: JSONDecodable {
  init?(jsonObject: JSON) {
    
    debugPrint(jsonObject)
    
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
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension CardInfo {
  func uidRepresentation() -> String {
    return String(self.uid)
  }
}
