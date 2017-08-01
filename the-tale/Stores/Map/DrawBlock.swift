//
//  DrawBlock.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 04/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct DrawBlock {
  var blockID: Int
  var blockAngle: Int
}

extension DrawBlock: ArrayDecodable {
  init?(arrayObject: NSArray) {
    
    guard let blockID    = arrayObject[0] as? Int,
          let blockAngle = arrayObject[1] as? Int else {
        return nil
    }
    
    self.blockID    = blockID
    self.blockAngle = blockAngle
    
  }
  
  init?() {
    self.init(arrayObject: [])
  }
}
