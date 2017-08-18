//
//  TaleAPIGameInformation.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 05/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func getGameInformation() {
    fetchGameInformation { [weak self] (result) in
      switch result {
      case .success(let data):
        self?.gameInformationManager.gameInformation = data
      case .failure(let error as NSError):
        debugPrint("fetchGameInformation \(error)")
      default: break
      }
    }
  }
  
  private func fetchGameInformation(completionHandler: @escaping (APIResult<GameInformation>) -> Void) {
    pathComponents.removeAll()
    pathComponents["api_client"]  = APIConfiguration.client.rawValue
    pathComponents["api_version"] = APIPath.info.version
    
    httpParams.removeAll()
    
    let request = URLRequest(baseURL: baseURL, path: APIPath.info.rawValue, pathComponents: pathComponents, method: .get, httpParams: httpParams)
    
    fetch(request: request, parse: { (json) -> GameInformation? in
      if let dictionary = json["data"] as? JSON {
        return GameInformation(jsonObject: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}
