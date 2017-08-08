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
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.login.version
    
    httpParams.removeAll()
    httpParams["next_url"] = ""
    httpParams["email"]    = email
    httpParams["password"] = password
    httpParams["remember"] = "on"
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.login.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> Login? in
      if let dictionary = json["data"] as? JSON {
        return Login(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
    
  }
  
}
