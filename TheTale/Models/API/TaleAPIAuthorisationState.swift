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
    guard let request = networkManager.createRequest(fromAPI: .authState) else {
      return
    }
    
    fetch(request: request, parse: { (json) -> AuthorisationState? in

      if let dictionary = json["data"] as? JSON {
        let authorisationState = AuthorisationState(jsonObject: dictionary)
        
        if let accountID = authorisationState?.accountID {
          self.getAccountInfo(accountID: accountID) { (result) in
            switch result {
            case .success(let data):
              TaleAPI.shared.accountShow = data
            case .failure(let error as NSError):
              debugPrint("showAccount", error)
            default: break
            }
          }
        }
        
        return authorisationState
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}
