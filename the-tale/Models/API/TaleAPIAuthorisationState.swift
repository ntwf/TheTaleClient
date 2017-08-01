//
//  TaleAPIAuthorisationState.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func fetchAuthorisationState() {
    networkManager.fetchAuthorisationState { (result) in
      switch result {
      case .success(let data):
        self.authorisationState = data
        NotificationCenter.default.post(name: NSNotification.Name("authorisationState"), object: nil)
      case .failure(let error as NSError):
        debugPrint("fetchAuthorisationState \(error)")
        NotificationCenter.default.post(name: NSNotification.Name("authorisationState"), object: nil)
      default: break
      }
    }
  }
  
}
