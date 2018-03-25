//
//  TaleAPILogout.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
 
  func logout(completionHandler: @escaping (APIResult<Logout>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .logout) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> Logout? in
      return Logout(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
}
