//
//  Sprite.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 07/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation
import UIKit

struct Hero {
  var accountID: Int
  var actualOnTurn: Bool
  var image: UIImage
}

extension Hero: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let accountID    = jsonObject["id"] as? Int,
          let actualOnTurn = jsonObject["actual_on_turn"] as? Bool,
          let sprite       = jsonObject["sprite"] as? Int else {
        return nil
    }

    self.accountID    = accountID
    self.actualOnTurn = actualOnTurn
    self.image        = UIImage(named: "map_default_\(String(sprite))")!
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
