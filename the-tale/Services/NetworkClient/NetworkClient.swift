//
//  NetworkClient.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

typealias JSONCompletionHandler = (JSON?, HTTPURLResponse?, Error?) -> Void
typealias JSONTask = URLSessionDataTask

enum RequestMethod: String {
  case get  = "GET"
  case post = "POST"
}

enum APIResult<T> {
  case success(T)
  case failure(Error)
}

protocol JSONDecodable {
  init?(jsonObject: JSON)
  init?()
}

protocol ArrayDecodable {
  init?(arrayObject: NSArray)
  init?()
}

protocol NetworkClient {
  var sessionConfiguration: URLSessionConfiguration { get }
  var session: URLSession { get }
  
  func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
  func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping (JSON) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
  
  init(sessionConfiguration: URLSessionConfiguration)
}

extension NetworkClient {
  func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
    
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      guard let HTTPResponse = response as? HTTPURLResponse else {
        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP response", comment: "")]
        let error    = NSError(domain: TALENetworkErrorDomain, code: 100, userInfo: userInfo)
        completionHandler(nil, nil, error)
        return
      }
      
      if data == nil {
        if let error = error {
          completionHandler(nil, HTTPResponse, error)
        }
      } else {
        switch HTTPResponse.statusCode {
        case 200:
          do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSON
            completionHandler(json, HTTPResponse, nil)
          } catch let error as NSError {
            completionHandler(nil, HTTPResponse, error)
          }
        default:
          debugPrint("We have got response status \(HTTPResponse.statusCode)")
        }
      }
    }
    
    return dataTask
  }
  
  func fetch<T>(request: URLRequest, parse: @escaping (JSON) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
    
    let dataTask = JSONTaskWith(request: request) { (json, _, error) in
      DispatchQueue.main.async {
        guard let json = json else {
          if let error = error {
            completionHandler(.failure(error))
          }
          return
        }
        
        if let value = parse(json) {
          completionHandler(.success(value))
        } else {
          let error = NSError(domain: TALENetworkErrorDomain, code: 200, userInfo: nil)
          completionHandler(.failure(error))
        }        
      }
    }
    
    dataTask.resume()
  }
  
}
