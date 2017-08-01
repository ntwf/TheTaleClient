//
//  ChoiceAlternatives.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct ChoiceAlternatives {
  var choiceID: String
  var description: String
}

extension ChoiceAlternatives: ArrayDecodable {
  init?(arrayObject: NSArray) {
    
    guard let choiceID    = arrayObject[0] as? String,
          let description = arrayObject[1] as? String else {
        return nil
    }
    
    self.choiceID    = choiceID
    self.description = description
    
  }
  
  init?() {
    self.init(arrayObject: [])
  }
}
