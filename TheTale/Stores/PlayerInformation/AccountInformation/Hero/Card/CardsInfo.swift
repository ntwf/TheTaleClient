//
//  CardsInfo.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 03/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class CardsInfo: NSObject {

  var helpCount: Int
  var helpBarrier: Int
  var cards: [Card]
  var cardCount: Int

  required init?(jsonObject: JSON) {
    
    guard let helpCount   = jsonObject["help_count"] as? Int,
          let helpBarrier = jsonObject["help_barrier"] as? Int else {
      return nil
    }
    
    var cards: [Card] = []
    if let cardsArray = jsonObject["cards"] as? NSArray {
      for card in cardsArray {
        guard let card = card as? JSON,
              let data = Card(jsonObject: card) else {
            break
        }
        cards.append(data)
      }
    }

    let sortedCards = cards.sorted(by: {
      if $0.rarity == $1.rarity {
        return $0.name < $1.name
      } else {
        return $0.rarity < $1.rarity
      }
    })
    
    self.helpCount   = helpCount
    self.helpBarrier = helpBarrier
    self.cardCount   = cards.count
    self.cards       = sortedCards
  }
}

extension CardsInfo {
  static func == (lhs: CardsInfo, rhs: CardsInfo) -> Bool {
    return lhs.helpCount == rhs.helpCount && lhs.cardCount == rhs.cardCount
  }
}

extension CardsInfo {
  func helpCountRepresentation() -> String {
    return "\(helpCount)/\(helpBarrier)"
  }
  
  func helpBarrierProgressRepresentation() -> Float {
    return (Float(helpCount) / Float(helpBarrier))
  }
}
