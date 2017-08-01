//
//  TaleAPIDiary.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func fetchDiary() {
    networkManager.fetchDiary { (result) in
      switch result {
      case .success(let data):
        self.dataManager.getNewDiaryMessages(recivedDiary: data)
      case .failure(let error as NSError):
        debugPrint("fetchDiary \(error)")
      default: break
      }
    }
  }
  
}
