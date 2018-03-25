//
//  URLRequest.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 26/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension URLRequest {
  
  init(_ url: URL, method: RequestMethod, httpParams: [String: String]) {
    self.init(url: url)

    httpMethod = method.rawValue
    
    var csrftoken: String!
    
    let readCookies = HTTPCookieStorage.shared.cookies(for: url)

    for cookie in readCookies! where cookie.name == "csrftoken" {
      csrftoken = cookie.value
    }

    setValue(csrftoken, forHTTPHeaderField: "X-CSRFToken")
    setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let postString = httpParams.map { (key, value) -> String in
      return "\(key)=\(value)"
    }.joined(separator: "&")
    
    switch method {
    case .post:
      httpBody = postString.data(using: .utf8)
    default:
      break
    }
  }
  
}
