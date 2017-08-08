//
//  URL.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 26/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension URL {
  init(baseURL: String, path: String, pathComponents: JSON, method: RequestMethod) {
    var urlComponents = URLComponents(string: baseURL)!
    urlComponents.path = path
    urlComponents.queryItems = pathComponents.map {
      URLQueryItem(name: $0.key, value: String(describing: $0.value))
    }
    
    self = urlComponents.url!
  }
}
