//
//  AuthorisationState.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

enum AuthorisationCode {
  case notRequested, notDecision, successful, denied, unknown
}

struct AuthorisationState {
  var accountID: Int
  var accountName: String
  var sessionExpireAt: Double
  var state: AuthorisationCode
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
    
    switch state {
    case 0:
      self.state = AuthorisationCode.notRequested
    case 1:
      self.state = AuthorisationCode.notDecision
    case 2:
      self.state = AuthorisationCode.successful
    case 4:
      self.state = AuthorisationCode.denied
    default:
      self.state = AuthorisationCode.unknown
    }
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
