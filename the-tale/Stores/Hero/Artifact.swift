//
//  Artifact.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation
import UIKit

class Artifact: NSObject {
  var key: Int
  var name: String
  var pPower: Int?
  var mPower: Int?
  var type: Int
  var currentIntegrity: Int?
  var maxIntegrity: Int?
  var rarity: Int?
  var effect: Int
  var specialEffect: Int
  var preferenceRating: Double?
  var equipped: Bool
  var artifactID: Int
  var imageName: String
  
  override var hashValue: Int {
    return artifactID.hashValue
  }

  required init?(key: String, jsonObject: JSON) {
    guard let key           = Int(key),
          let name          = jsonObject["name"] as? String,
          let type          = jsonObject["type"] as? Int,
          let imageName     = Types.shared.artifact?.imageName[String(type)] as? String,
          let effect        = jsonObject["effect"] as? Int,
          let specialEffect = jsonObject["special_effect"] as? Int,
          let equipped      = jsonObject["equipped"] as? Bool,
          let artifactID    = jsonObject["id"] as? Int else {
      return nil
    }
    
    let power             = jsonObject["power"] as? [Int]
    let integrity         = jsonObject["integrity"] as? [Int]
    let rarity            = jsonObject["rarity"] as? Int
    let preferenceRating  = jsonObject["preference_rating"] as? Double
    
    self.key              = key
    self.name             = name
    self.mPower           = power?[0]
    self.pPower           = power?[1]
    self.type             = type
    self.currentIntegrity = integrity?[0]
    self.maxIntegrity     = integrity?[1]
    self.rarity           = rarity
    self.effect           = effect
    self.specialEffect    = specialEffect
    self.preferenceRating = preferenceRating
    self.equipped         = equipped
    self.artifactID       = artifactID
    self.imageName        = imageName
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    if let rhs = object as? Artifact {
      return artifactID == rhs.artifactID && artifactID == rhs.artifactID
    } else {
      return false
    }
  }
}

extension Artifact {
  static func == (rhs: Artifact, lhs: Artifact) -> Bool {
    return rhs.artifactID == lhs.artifactID
  }
}

extension Artifact {
  func mPowerRepresentation() -> String {
    return "\(self.mPower ?? 0)"
  }
  
  func pPowerRepresentation() -> String {
    return "\(self.pPower ?? 0)"
  }
}
