//
//  EquipViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var questIndex: Int!
  
  let questCell      = "QuestCell"
  let actorCell      = "ActorsCell"
  let madeChoiceCell = "MadeСhoiceCell"
  let choicesCell    = "ChoicesCell"
  
  let keyPathQuests = #keyPath(TaleAPI.playerInformationManager.quests)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
    setupNotification()
    setupTableView()
  }

  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathQuests, options: [.new], context: nil)
  }
  
  func setupTableView() {
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == keyPathQuests {
      updateUI()
    }
  }

  func updateUI() {
    activityIndicator.stopAnimating()
    tableView.reloadData()
  }
  
  deinit {
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathQuests)
  }
  
}

extension QuestViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 2 && TaleAPI.shared.playerInformationManager.quests[questIndex].choice != nil {
      return "Поступки героя."
    }
    if section == 3 && TaleAPI.shared.playerInformationManager.quests[questIndex].choiceAlternatives.count != 0 {
      return "Как поступим?"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return TaleAPI.shared.playerInformationManager.quests[questIndex].actors.count
    case 2:
      if TaleAPI.shared.playerInformationManager.quests[questIndex].choice != nil {
        return 1
      }
      return 0
    case 3:
      return TaleAPI.shared.playerInformationManager.quests[questIndex].choiceAlternatives.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: questCell) as! QuestTableViewCell

      cell.configuredQuest(info: TaleAPI.shared.playerInformationManager.quests[questIndex])

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: actorCell)

      let nameActors = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].nameActorsRepresentation()
      
      if let goal = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].goal {
        cell?.textLabel?.text = "\(nameActors) \(goal)"
      } else if let name = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].name {
        cell?.textLabel?.text = "\(nameActors) \(name)"
      }
      
      cell?.detailTextLabel?.text = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].info
      
      return cell!
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: madeChoiceCell)
      
      guard let choice = TaleAPI.shared.playerInformationManager.quests[questIndex].choice else {
        return cell!
      }
      cell?.textLabel?.text = choice.capitalizeFirstLetter
      
      return cell!
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: choicesCell)
      cell?.textLabel?.text = TaleAPI.shared.playerInformationManager.quests[questIndex].choiceAlternatives[indexPath.row].info.capitalizeFirstLetter

      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
  
}

extension QuestViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 3 else {
      return
    }
    activityIndicator.startAnimating()
    
    let uidChoose = TaleAPI.shared.playerInformationManager.quests[questIndex].choiceAlternatives[indexPath.row].choiceID
    
    TaleAPI.shared.tryChooseQuest(uidChoose: uidChoose) { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryChooseQuest \(error)")
      default: break
      }
    }
    
  }
  
}
