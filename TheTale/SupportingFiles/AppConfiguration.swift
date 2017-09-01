//
//  AppConfiguration.swift.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 28/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import Foundation

typealias PListData = [String: AnyObject]
typealias JSON      = [String: Any]

struct AppConfiguration {
  enum Segue {
    static let toAbout        = "toAboutSegue"
    static let toDiary        = "toDiarySegue"
    static let toJournal      = "toJournalSegue"
    static let toLogin        = "toLoginSegue"
    static let toQuest        = "toQuestSegue"
    static let toRegistration = "toRegistrationSegue"
    static let toWeb          = "toWebSegue"
  }
  
  enum StoryboardID {
    static let loginScreen = "startScreen"
  }
}
