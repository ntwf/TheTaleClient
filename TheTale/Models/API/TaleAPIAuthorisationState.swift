//
//  TaleAPIAuthorisationState.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {

  func getAuthorisationState(completionHandler: @escaping (APIResult<AuthorisationState>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.authState.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.authState.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> AuthorisationState? in
      if let dictionary = json["data"] as? JSON {
        return AuthorisationState(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}
