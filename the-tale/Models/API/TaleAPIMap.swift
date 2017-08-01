//
//  TaleAPIMap.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 11/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

extension TaleAPI {
  
  func fetchMap() {
    //    fetchMapVersions()
    //    guard let turn = mapVersion?.returnLastTurn() else { return }
    let turn = ""
    
    networkManager.fetchMap(turn: turn) { (result) in
      switch result {
      case .success(let data):
        let queue = DispatchQueue(label: "mapGenerate", qos: .userInitiated)
        queue.async {
          let map  = Map(jsonObject: data)
          self.map = map
          NotificationCenter.default.post(name: NSNotification.Name("updateMap"), object: nil)
        }
      case .failure(let error as NSError):
        debugPrint("fetchMap \(error)")
      default: break
      }
    }
    
  }
  
  private func fetchMapVersions() {
    networkManager.fetchMapVersions { (result) in
      switch result {
      case .success(let data):
        self.mapVersion = data
      case .failure(let error as NSError):
        debugPrint("fetchMapVersions \(error)")
      default: break
      }
    }
  }
  
}
