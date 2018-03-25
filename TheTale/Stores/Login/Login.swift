//
//  Login.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct Login {
  var accountID: Int
  var accountName: String
  var sessionExpireAt: Double
}

extension Login: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let accountID       = jsonObject["account_id"] as? Int,
          let accountName     = jsonObject["account_name"] as? String,
          let sessionExpireAt = jsonObject["session_expire_at"] as? Double else {
      return nil
    }

    self.accountID       = accountID
    self.accountName     = accountName
    self.sessionExpireAt = sessionExpireAt
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
