//
//  AuthorisationState.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

enum AuthorisationCode: String {
  case notRequested
  case notDecision
  case successful
  case denied
}

struct AuthorisationState {
  var accountID: Int
  var accountName: String
  var sessionExpireAt: Double
  var state: Int
}

extension AuthorisationState: JSONDecodable {
  init?(jsonObject: JSON) {
    
    guard let accountID       = jsonObject["account_id"] as? Int,
          let accountName     = jsonObject["account_name"] as? String,
          let sessionExpireAt = jsonObject["session_expire_at"] as? Double,
          let state           = jsonObject["state"] as? Int else {
        return nil
    }

    self.accountID       = accountID
    self.accountName     = accountName
    self.sessionExpireAt = sessionExpireAt
    self.state           = state
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
