//
//  AccountInfo.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 28/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct AccountInformation {
  var accountID: Int
  var isOwn: Bool
  var isOld: Bool
  var hero: JSON
  var inPvPQueue: Bool
  var lastVisit: Int
}

extension AccountInformation: JSONDecodable {
  init?(jsonObject: JSON) {

    guard let accountID   = jsonObject["id"] as? Int,
          let isOwn       = jsonObject["is_own"] as? Bool,
          let isOld       = jsonObject["is_old"] as? Bool,
          let inPvPQueue  = jsonObject["in_pvp_queue"] as? Bool,
          let lastVisit   = jsonObject["last_visit"] as? Int,
          let hero        = jsonObject["hero"] as? JSON else {
        return nil
    }

    self.accountID   = accountID
    self.isOld       = isOld
    self.isOwn       = isOwn
    self.hero        = hero
    self.inPvPQueue  = inPvPQueue
    self.lastVisit   = lastVisit
    
  }
  
  init?() {
    self.init(jsonObject: [:])
  }
}
