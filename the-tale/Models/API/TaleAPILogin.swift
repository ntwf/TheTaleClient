//
//  TaleAPILogin.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func login(email: String, password: String) {
    networkManager.login(email: email, password: password) { (result) in
      switch result {
      case .success(let data):
        self.loginState = data
        NotificationCenter.default.post(name: NSNotification.Name("loginState"), object: nil)
      case .failure(let error as NSError):
        debugPrint("login \(error)")
        NotificationCenter.default.post(name: NSNotification.Name("loginState"), object: nil)
      default: break
      }
    }
  }
  
}
