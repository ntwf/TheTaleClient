//
//  Cards.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Cards {
  var helpCount: Int
  var helpBarrier: Int
  var info: [CardInfo]
  var cardCount: Int
}

extension Cards: Equatable {
}

func == (lhs: Cards, rhs: Cards) -> Bool {
  return lhs.helpCount == rhs.helpCount && lhs.cardCount == rhs.cardCount
}

extension Cards: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let helpCount   = jsonObject["help_count"] as? Int,
          let helpBarrier = jsonObject["help_barrier"] as? Int else {
        return nil
    }
    
    var cards: [CardInfo] = []
    if let cardsArray = jsonObject["cards"] as? NSArray {
      for card in cardsArray {
        guard let card = card as? JSON,
              let data = CardInfo(jsonObject: card) else {
            break
        }
        cards.append(data)
      }
    }
    
    self.helpCount   = helpCount
    self.helpBarrier = helpBarrier
    self.info        = cards
    self.cardCount   = cards.count
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension Cards {
  func helpCountRepresentation() -> String {
    return "\(self.helpCount)/\(self.helpBarrier)"
  }
  
  func helpBarrierProgressRepresentation() -> Float {
    return (Float(self.helpCount) / Float(self.helpBarrier))
  }
}
