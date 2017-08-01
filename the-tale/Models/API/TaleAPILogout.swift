//
//  TaleAPILogout.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func logout() {
    networkManager.logout { (result) in
      switch result {
      case .success:
        NotificationCenter.default.post(name: NSNotification.Name("logoutState"), object: nil)
      case .failure(let error as NSError):
        debugPrint("logout \(error)")
        NotificationCenter.default.post(name: NSNotification.Name("logoutState"), object: nil)
      default: break
      }
    }
  }
  
}
