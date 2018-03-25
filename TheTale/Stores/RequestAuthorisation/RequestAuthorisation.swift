//
//  RequestAuthorisation.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 20/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

struct RequestAuthorisation {
  var urlPath: String
}

extension RequestAuthorisation {
  init?(jsonObject: JSON) {
    
    guard let urlPath = jsonObject["authorisation_page"] as? String else {
      return nil
    }
    
    self.urlPath = urlPath
    
  }
}
