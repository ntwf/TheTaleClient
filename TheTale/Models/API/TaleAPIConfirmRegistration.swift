//
//  TaleAPIConfirmRegistration.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 04/09/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func confirmRegistration(nick: String, email: String, password: String, completionHandler: @escaping (APIResult<JSON>) -> Void) {
    var components: [String: String] = [:]
    components["nick"]     = nick
    components["email"]    = email
    components["password"] = password
    
    guard let request = networkManager.createRequest(fromAPI: .updateProfile, httpParameters: components) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> JSON? in
      if let dictionary = json["data"] as? JSON {
        return dictionary
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
    
  }
  
}
