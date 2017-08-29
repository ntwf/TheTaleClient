//
//  AccountInformationManager.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 28/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

class PlayerInformationManager: NSObject {
  
  dynamic var playerInformation         = PlayerInformation(jsonObject: [:])
  dynamic var accountInformation        = AccountInformation(jsonObject: [:])
  dynamic var turn                      = Turn(jsonObject: [:])
  dynamic var hero                      = Hero(jsonObject: [:])
  dynamic var journal: [JournalMessage] = []
  dynamic var action                    = Action(jsonObject: [:])
  dynamic var cardsInfo                 = CardsInfo(jsonObject: [:])
  dynamic var equipment: [Artifact]     = []
  dynamic var bag: [[Artifact: Int]]    = [[:]]
  dynamic var companion                 = Companion(jsonObject: [:])
  dynamic var energy                    = Energy(jsonObject: [:])
  dynamic var heroBaseParameters        = HeroBaseParameters(jsonObject: [:])
  dynamic var heroSecondaryParameters   = HeroSecondaryParameters(jsonObject: [:])
  dynamic var heroPosition              = Position(jsonObject: [:])
  dynamic var might                     = Might(jsonObject: [:])
  dynamic var quests: [Quest]           = []
  
  private var heroJSON: JSON                    = [:]
  private var recivedMessages: [JournalMessage] = []
  
  // MARK: - Player information
  func getPlayerInformation(from player: PlayerInformation) {
    // Order is important! This is structure of JSON
    
    // Player information
    playerInformation = player
    getTurn()
    
    // Account information
    getAccountInformation()
    getHero()
    
    // Hero information
    getMessages()
    getAction()
    getCards()
    getEquipment()
    getBag()
    getCompanion()
    getEnergy()
    getHeroBaseParameters()
    getHeroSecondatyParameters()
    getHeroPosition()
    getMight()
    getQuests()
  }
  
  private func getTurn() {
    guard let recivedTurnJSON = playerInformation?.turn,
          let recivedTurn     = Turn(jsonObject: recivedTurnJSON) else {
      return
    }
    turn = recivedTurn
  }
  
  // MARK: - Account information
  private func getAccountInformation() {
    guard let recivedAccountJSON = playerInformation?.account,
          let recivedAccount     = AccountInformation(jsonObject: recivedAccountJSON) else {
      return
    }
    
    accountInformation = recivedAccount
    getHero()
  }
  
  private func getHero() {
    guard let recivedHeroJSON = accountInformation?.hero else {
      return
    }
    heroJSON = recivedHeroJSON
    
    guard let recivedHero = Hero(jsonObject: recivedHeroJSON) else {
      return
    }
    hero     = recivedHero
  }
  
  // MARK: - Hero information
  private func getMessages() {
    var messages: [JournalMessage] = []

    guard let arrayMessages = heroJSON["messages"] as? NSArray else {
      return
    }
    
    for arrayMessage in arrayMessages {
      guard let arrayMessage = arrayMessage as? NSArray,
            let message      = JournalMessage(arrayObject: arrayMessage) else {
        return
      }
      messages.append(message)
    }
    
    let newMessages    = messages.filter { !recivedMessages.contains($0) }
    let sortedMessages = newMessages.sorted(by: { $0.timestamp < $1.timestamp })
    
    recivedMessages = messages
    journal         = sortedMessages
  }
  
  private func getAction() {
    guard let actionJSON    = heroJSON["action"] as? JSON,
          let recivedAction = Action(jsonObject: actionJSON) else {
      return
    }
    action = recivedAction
  }
  
  private func getCards() {
    guard let cardsJSON    = heroJSON["cards"] as? JSON,
          let recivedCards = CardsInfo(jsonObject: cardsJSON) else {
      return
    }
    cardsInfo = recivedCards
  }
  
  private func getEquipment() {
    guard let equipmentJSON    = heroJSON["equipment"] as? JSON,
          let recivedArtifacts = getArtifacts(jsonObject: equipmentJSON) else {
      return
    }
    
    for artifact in recivedArtifacts {
      if !equipment.contains(artifact) {
        equipment = recivedArtifacts.sorted(by: { $0.type < $1.type })
        return
      }
    }
  }
  
  private func getBag() {
    guard let equipmentJSON = heroJSON["bag"] as? JSON,
          let recivedBags   = getArtifacts(jsonObject: equipmentJSON) else {
      return
    }
    
    var bagCounts: [Artifact: Int]   = [:]
    var uniqueBag: [[Artifact: Int]] = [[:]]
    
    for artifact in recivedBags {
      bagCounts[artifact] = (bagCounts[artifact] ?? 0) + 1
    }
    
    uniqueBag.removeAll()
    for (artifact, counter) in bagCounts.sorted(by: { $0.key.name < $1.key.name }) {
      uniqueBag.append([artifact: counter])
    }
    
    bag = uniqueBag
  }
  
  private func getArtifacts(jsonObject: JSON) -> [Artifact]? {
    var artifacts: [Artifact] = []
    
    for jsonArtifact in jsonObject {
      guard let (key, value) = jsonArtifact as? (key: String, value: JSON),
            let artifact     = Artifact(key: key, jsonObject: value) else {
          return nil
      }
      
      artifacts.append(artifact)
    }
    
    return artifacts
  }
  
  private func getCompanion() {
    guard let companionJSON    = heroJSON["companion"] as? JSON,
          let recivedCompanion = Companion(jsonObject: companionJSON) else {
      return
    }
    companion = recivedCompanion
  }
  
  private func getEnergy() {
    guard let energyJSON    = heroJSON["energy"] as? JSON,
          let recivedEnergy = Energy(jsonObject: energyJSON) else {
        return
    }
    energy = recivedEnergy
  }
  
  private func getHeroBaseParameters() {
    guard let baseJSON    = heroJSON["base"] as? JSON,
          let recivedBase = HeroBaseParameters(jsonObject: baseJSON) else {
      return
    }
    heroBaseParameters = recivedBase
  }
  
  private func getHeroSecondatyParameters() {
    guard let secondaryJSON    = heroJSON["secondary"] as? JSON,
          let recivedSecondary = HeroSecondaryParameters(jsonObject: secondaryJSON) else {
      return
    }
    heroSecondaryParameters = recivedSecondary
  }
  
  private func getHeroPosition() {

    guard let positionJSON    = heroJSON["position"] as? JSON,
          let recivedPosition = Position(jsonObject: positionJSON) else {
        return
    }

    if heroPosition?.xCoordinate != recivedPosition.xCoordinate ||
       heroPosition?.yCoordinate != recivedPosition.yCoordinate {
      heroPosition = recivedPosition
    }
  }
  
  private func getMight() {
    guard let mightJSON    = heroJSON["might"] as? JSON,
          let recivedMight = Might(jsonObject: mightJSON) else {
      return
    }
    might = recivedMight
  }
  
  private func getQuests() {
    var quests: [Quest] = []
    
    guard let questJSON  = heroJSON["quests"] as? JSON,
          let questArray = questJSON["quests"] as? NSArray else {
        return
    }
    
    for quest in questArray {
      guard let jsonQuest      = quest as? JSON,
            let arrayLineQuest = jsonQuest["line"] as? NSArray else {
          return
      }
      
      for lineQuest in arrayLineQuest {
        guard let quest = lineQuest as? JSON,
              let data  = Quest(jsonObject: quest) else {
          return
        }
        quests.append(data)
      }
    }
    
    self.quests = quests
  }
}
