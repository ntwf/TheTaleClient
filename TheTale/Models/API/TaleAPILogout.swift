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
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.logout.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.logout.rawValue, pathComponents: pathComponents, method: .post, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> Logout? in
      return Logout(jsonObject: json)
    }, completionHandler: completionHandler)
  }
  
}
