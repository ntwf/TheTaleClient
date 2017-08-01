//
//  APIDataManager.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 28/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

final class DataManager {

  private var accountInformation = AccountInformation(jsonObject: [:])
  private var journal            = JournalMessages(jsonObject: [:])
  private var diary              = Diary(jsonObject: [:])
  
  func getAccountInformation() {
    guard let account        = TaleAPI.shared.gameInformation?.account,
          let recivedAccount = AccountInformation(jsonObject: account) else {
        return
    }
    accountInformation = recivedAccount
  }
  
  func getJournalMessages() {
    guard let hero            = accountInformation?.hero,
          let recivedJournal  = JournalMessages(jsonObject: hero),
          let messages        = getNewJournalMessages(recivedMessages: recivedJournal) else {
        return
    }
    journal = recivedJournal
    TaleAPI.shared.messages = messages

    NotificationCenter.default.post(name: NSNotification.Name("updateJournalMessages"), object: nil)
  }
  
  func getJournalAction() {
    guard let hero          = accountInformation?.hero,
          let actionJSON    = hero["action"] as? JSON,
          let recivedAction = Action(jsonObject: actionJSON) else {
        return
    }
    TaleAPI.shared.action = recivedAction
    NotificationCenter.default.post(name: NSNotification.Name("updateJournalAction"), object: nil)
  }
  
  func getHeroInformation() {
    getEquipment()
    getBag()
    getCompanion()
    getEnergy()
    getHero()
    getHeroBaseParameters()
    getHeroSecondatyParameters()
    getHeroPosition()
    getMight()
    getQuest()
    getCards()
    getTurn()
  }

  func getTurn() {
    guard let jsonTurn    = TaleAPI.shared.gameInformation?.turn,
          let recivedTurn = Turn(jsonObject: jsonTurn) else {
        return
    }
    TaleAPI.shared.turn = recivedTurn
    NotificationCenter.default.post(name: NSNotification.Name("updateTurn"), object: nil)
  }
  
  func getNewDiaryMessages(recivedDiary: Diary) {
    var currentMessages: [DiaryMessage] = []
    if let messages = diary?.messages {
      currentMessages = messages
    }
    
    let newMessages    = Set(recivedDiary.messages).subtracting(Set(currentMessages))
    let sortedMessages = newMessages.sorted(by: { $0.timestamp < $1.timestamp })
    
    diary = recivedDiary
    TaleAPI.shared.diaryMessages = sortedMessages
    NotificationCenter.default.post(name: NSNotification.Name("updateDiary"), object: nil)
  }

  func getCards() {
    guard let hero         = accountInformation?.hero,
          let cardsJSON    = hero["cards"] as? JSON,
          let recivedCards = Cards(jsonObject: cardsJSON) else {
        return
    }
    
    if TaleAPI.shared.cards != recivedCards {
      TaleAPI.shared.cards = recivedCards
      NotificationCenter.default.post(name: NSNotification.Name("updateCard"), object: nil)
    }
  }
  
  private func getEquipment() {
    guard let hero             = accountInformation?.hero,
          let equipmentJSON    = hero["equipment"] as? JSON,
          let recivedArtifacts = getArtifacts(jsonObject: equipmentJSON) else {
        return
    }
    
    uid: for artifact in recivedArtifacts {
      if !TaleAPI.shared.equipment.contains(artifact) {
        TaleAPI.shared.equipment = recivedArtifacts.sorted(by: { $0.type < $1.type })
        NotificationCenter.default.post(name: NSNotification.Name("updateEquipment"), object: nil)
        break uid
      }
    }
  }
  
  private func getBag() {
    guard let hero             = accountInformation?.hero,
          let equipmentJSON    = hero["bag"] as? JSON,
          let recivedBags      = getArtifacts(jsonObject: equipmentJSON) else {
        return
    }
    
    uid: for artifact in recivedBags {
      if !TaleAPI.shared.bag.contains(artifact) {
        TaleAPI.shared.bag = recivedBags.sorted(by: { $0.name < $1.name })
        NotificationCenter.default.post(name: NSNotification.Name("updateBag"), object: nil)
        break uid
      }
    }
  }
  
  private func getCompanion() {
    guard let hero             = accountInformation?.hero,
          let companionJSON    = hero["companion"] as? JSON,
          let recivedCompanion = Companion(jsonObject: companionJSON) else {
        return
    }
    TaleAPI.shared.companion = recivedCompanion
    NotificationCenter.default.post(name: NSNotification.Name("updateCompanion"), object: nil)
  }
  
  private func getEnergy() {
    guard let hero          = accountInformation?.hero,
          let energyJSON    = hero["energy"] as? JSON,
          let recivedEnergy = Energy(jsonObject: energyJSON) else {
        return
    }
    TaleAPI.shared.energy = recivedEnergy
    NotificationCenter.default.post(name: NSNotification.Name("updateEnergy"), object: nil)
  }
  
  private func getHero() {
    guard let hero        = accountInformation?.hero,
          let recivedHero = Hero(jsonObject: hero) else {
        return
    }
    TaleAPI.shared.hero = recivedHero
    NotificationCenter.default.post(name: NSNotification.Name("updateHero"), object: nil)
  }
  
  private func getHeroBaseParameters() {
    guard let hero        = accountInformation?.hero,
          let baseJSON    = hero["base"] as? JSON,
          let recivedBase = HeroBaseParameters(jsonObject: baseJSON) else {
        return
    }
    TaleAPI.shared.heroBaseParameters = recivedBase
    NotificationCenter.default.post(name: NSNotification.Name("updateHeroBaseParameters"), object: nil)
  }
  
  private func getHeroSecondatyParameters() {
    guard let hero             = accountInformation?.hero,
          let secondaryJSON    = hero["secondary"] as? JSON,
          let recivedSecondary = HeroSecondaryParameters(jsonObject: secondaryJSON) else {
        return
    }
    TaleAPI.shared.heroSecondaryParameters = recivedSecondary
    NotificationCenter.default.post(name: NSNotification.Name("updateHeroSecondParameters"), object: nil)
  }
  
  private func getHeroPosition() {
    guard let hero            = accountInformation?.hero,
          let positionJSON    = hero["position"] as? JSON,
          let recivedPosition = Position(jsonObject: positionJSON) else {
        return
    }
    
    if let heroPosition = TaleAPI.shared.heroPosition {
      if heroPosition.xCoordinate != recivedPosition.xCoordinate || heroPosition.yCoordinate != recivedPosition.yCoordinate {
        TaleAPI.shared.heroPosition = recivedPosition
        NotificationCenter.default.post(name: NSNotification.Name("updateMap"), object: nil)
      }
    } else {
      TaleAPI.shared.heroPosition = recivedPosition
      NotificationCenter.default.post(name: NSNotification.Name("updateMap"), object: nil)
    }
  }
  
  private func getMight() {
    guard let hero         = accountInformation?.hero,
          let mightJSON    = hero["might"] as? JSON,
          let recivedMight = Might(jsonObject: mightJSON) else {
        return
    }
    TaleAPI.shared.might = recivedMight
    NotificationCenter.default.post(name: NSNotification.Name("updateMight"), object: nil)
  }
  
  private func getQuest() {
    var quests: [Quest] = []
    guard let hero       = accountInformation?.hero,
          let questJSON  = hero["quests"] as? JSON,
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
    
    TaleAPI.shared.quests = quests
    NotificationCenter.default.post(name: NSNotification.Name("updateQuests"), object: nil)
  }
  
  private func getArtifacts(jsonObject: JSON) -> [Artifact]? {
    var artifacts: [Artifact] = []
    
    for jsonArtifact in jsonObject {
      guard let (key, value) = jsonArtifact as? (key: String, value: JSON),
            let artifact = Artifact(key: key, jsonObject: value) else {
          return nil
      }
      
      artifacts.append(artifact)
    }
    
    return artifacts
  }
  
  private func getNewJournalMessages(recivedMessages: JournalMessages) -> [Message]? {
    var currentMessages: [Message] = []
    if let messages = journal?.messages {
      currentMessages = messages
    }

    let newMessages    = Set(recivedMessages.messages).subtracting(Set(currentMessages))
    let sortedMessages = newMessages.sorted(by: { $0.timestamp < $1.timestamp })
    
    return sortedMessages
  }

}
