//
//  MapVersions.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 04/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct MapVersions {
  var turns: [Int]
}

extension MapVersions: JSONDecodable {
  init?(jsonObject: JSON) {
    
    var turns: [Int] = []
    
    guard let turnsArray = jsonObject["turns"] as? NSArray else { return nil }
    
    for turn in turnsArray {
      guard let turn = turn as? Int else { break }
      turns.append(turn)
    }
    
    self.turns = turns
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}

extension MapVersions {
  func returnLastTurn() -> String {
    return String(describing: turns.last)
  }
}
