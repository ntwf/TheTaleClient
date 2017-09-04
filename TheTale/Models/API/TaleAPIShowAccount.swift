//
//  TaleAPIShowAccount.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func getAccountInfo(accountID: Int, completionHandler: @escaping (APIResult<AccountShow>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .accounts, pathParameters: String(accountID)) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> AccountShow? in
      if let dictionary = json["data"] as? JSON {
        return AccountShow(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}
