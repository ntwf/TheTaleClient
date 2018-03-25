//
//  TaleAPILogin.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func login(email: String, password: String, completionHandler: @escaping (APIResult<Login>) -> Void) {
    var components: [String: String] = [:]
    components["next_url"] = ""
    components["email"]    = email
    components["password"] = password
    components["remember"] = "on"
    
    guard let request = networkManager.createRequest(fromAPI: .login, httpParameters: components) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> Login? in
      if let dictionary = json["data"] as? JSON {
        return Login(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
    
  }
  
  func requestURLPathTologinIntoSite(completionHandler: @escaping (APIResult<RequestAuthorisation>) -> Void) {
    var components: [String: String] = [:]
    components["application_name"]        = Configuration.applicationName
    components["application_info"]        = Configuration.applicationInfo
    components["application_description"] = Configuration.applicationDescription
    
    guard let request = networkManager.createRequest(fromAPI: .requestAuth, httpParameters: components) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> RequestAuthorisation? in
      if let dictionary = json["data"] as? JSON {
        return RequestAuthorisation(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
    
  }
  
}
