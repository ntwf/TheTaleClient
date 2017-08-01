//
//  Logout.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Logout {
  var status: String
}

extension Logout: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let status = jsonObject["status"] as? String else {
      return nil
    }
    
    self.status = status
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
