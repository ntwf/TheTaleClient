//
//  NonblockingOperationStatus.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 08/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct NonblockingOperationStatus {
  var status: String
  var statusURL: String?
  var error: String?
  var retry: Int
}

extension NonblockingOperationStatus: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let status    = jsonObject["status"] as? String else {
        return nil
    }
    
    let error     = jsonObject["error"] as? String
    let statusURL = jsonObject["status_url"] as? String
    
    self.status    = status
    self.statusURL = statusURL
    self.error     = error
    self.retry     = 0
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
