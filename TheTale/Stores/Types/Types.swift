//
//  Types.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 22/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

protocol PListDecodable {
  init?(_ plistObject: PListData)
}

class Types {
  
  class var shared: Types {
    struct Singelton {
      static let instance = Types()
    }
    return Singelton.instance
  }
  
  var hero: TypesHero?
  var city: TypesCity?
  var quest: TypesQuest?
  var common: TypesCommon?
  var game: TypesGame?
  var master: TypesMaster?
  var project: TypesProject?
  var card: TypesCard?
  var artifact: TypesArtifact?
  
  init() {
    if let path = Bundle.main.path(forResource: "Types", ofType: "plist"), let data = NSData(contentsOfFile: path) {
      do {
        guard let dataSource = try PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil) as? PListData else { return }
        
        hero     = TypesHero(dataSource)
        city     = TypesCity(dataSource)
        quest    = TypesQuest(dataSource)
        common   = TypesCommon(dataSource)
        game     = TypesGame(dataSource)
        master   = TypesMaster(dataSource)
        project  = TypesProject(dataSource)
        card     = TypesCard(dataSource)
        artifact = TypesArtifact(dataSource)
      } catch let error as NSError {
        debugPrint(error)
      }
    }
  }
}

struct TypesHero: PListDecodable {
  var action: PListData
  var honor: PListData
  var peacefulness: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary   = plistObject["hero"] as? PListData,
          let action       = dictionary["action"] as? PListData,
          let honor        = dictionary["honor"] as? PListData,
          let peacefulness = dictionary["peacefulness"] as? PListData else {
      return nil
    }

    self.action       = action
    self.honor        = honor
    self.peacefulness = peacefulness
    
  }
}

struct TypesCity: PListDecodable {
  var peacefulness: PListData
  var honor: PListData
  var specialization: PListData
  var attribute: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary     = plistObject["city"] as? PListData,
          let peacefulness   = dictionary["peacefulness"] as? PListData,
          let honor          = dictionary["honor"] as? PListData,
          let specialization = dictionary["specialization"] as? PListData,
          let attribute      = dictionary["attribute"] as? PListData else {
        return nil
    }
    
    self.peacefulness   = peacefulness
    self.honor          = honor
    self.specialization = specialization
    self.attribute      = attribute
    
  }
}

struct TypesQuest: PListDecodable {
  var actor: PListData
  var type: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary = plistObject["quest"] as? PListData,
          let actor      = dictionary["actor"] as? PListData,
          let type       = dictionary["type"] as? PListData else {
        return nil
    }
    
    self.actor = actor
    self.type  = type
    
  }
}

struct TypesCommon: PListDecodable {
  var gender: PListData
  var race: PListData
  var traitInt: PListData
  var traitStr: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary = plistObject["common"] as? PListData,
          let gender     = dictionary["gender"] as? PListData,
          let race       = dictionary["race"] as? PListData,
          let traitInt   = dictionary["traitInt"] as? PListData,
          let traitStr   = dictionary["traitStr"] as? PListData else {
      return nil
    }
    
    self.gender   = gender
    self.race     = race
    self.traitInt = traitInt
    self.traitStr = traitStr
    
  }
}

struct TypesGame: PListDecodable {
  var authorizationStatus: PListData
  var state: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary          = plistObject["game"] as? PListData,
          let authorizationStatus = dictionary["authorizationStatus"] as? PListData,
          let state               = dictionary["state"] as? PListData else {
      return nil
    }
    
    self.authorizationStatus = authorizationStatus
    self.state               = state
    
  }
}

struct TypesMaster: PListDecodable {
  var profession: PListData
  var socialCommunication: PListData
  var cosmeticFeaturesOfCharacter: PListData
  var practicalFeaturesOfCharacter: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary                   = plistObject["master"] as? PListData,
          let profession                   = dictionary["profession"] as? PListData,
          let socialCommunication          = dictionary["socialCommunication"] as? PListData,
          let cosmeticFeaturesOfCharacter  = dictionary["cosmeticFeaturesOfCharacter"] as? PListData,
          let practicalFeaturesOfCharacter = dictionary["practicalFeaturesOfCharacter"] as? PListData else {
        return nil
    }
    
    self.profession                   = profession
    self.socialCommunication          = socialCommunication
    self.practicalFeaturesOfCharacter = practicalFeaturesOfCharacter
    self.cosmeticFeaturesOfCharacter  = cosmeticFeaturesOfCharacter
    
  }
}

struct TypesProject: PListDecodable {
  var culture: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary = plistObject["project"] as? PListData,
          let culture    = dictionary["culture"] as? PListData else {
        return nil
    }
    
    self.culture = culture
    
  }
}

struct TypesCard: PListDecodable {
  var type: PListData
  var rarity: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary = plistObject["card"] as? PListData,
          let type       = dictionary["type"] as? PListData,
          let rarity     = dictionary["rarity"] as? PListData else {
        return nil
    }
    
    self.type   = type
    self.rarity = rarity
    
  }
}

struct TypesArtifact: PListDecodable {
  var rarity: PListData
  var type: PListData
  var equipment: PListData
  var effect: PListData
  var imageName: PListData
  
  init?(_ plistObject: PListData) {
    guard let dictionary = plistObject["artifact"] as? PListData,
          let imageName  = dictionary["imageName"] as? PListData,
          let rarity     = dictionary["rarity"] as? PListData,
          let type       = dictionary["type"] as? PListData,
          let equipment  = dictionary["equipment"] as? PListData,
          let effect     = dictionary["effect"] as? PListData else {
        return nil
    }
    
    self.rarity    = rarity
    self.type      = type
    self.equipment = equipment
    self.effect    = effect
    self.imageName = imageName
    
  }
}
