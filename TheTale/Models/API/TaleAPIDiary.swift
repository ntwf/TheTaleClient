//
//  TaleAPIDiary.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {

  func getDiary(completionHandler: @escaping (APIResult<JSON>) -> Void) {
    guard let request = networkManager.createRequest(fromAPI: .diary) else {
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
