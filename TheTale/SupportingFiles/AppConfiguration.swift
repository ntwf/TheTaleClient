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
  struct Segue {
    static let toJournal = "toJournalSegue"
    static let toWeb     = "toWebSegue"
    static let toQuest   = "toQuestSegue"
    static let toDiary   = "toDiarySegue"
    static let toAbout   = "toAboutSegue"
  }
  
  
  
  struct StoryboardID {
    static let waitScreen  = "waitScreen"
    static let loginScreen = "loginScreen"
  }
}
