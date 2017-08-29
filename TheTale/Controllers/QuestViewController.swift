//
//  EquipViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {
  // MARK: - Internal constants
  enum Constants {
    static let cellQuest      = "QuestCell"
    static let cellActor      = "ActorsCell"
    static let cellMadeChoice = "MadeСhoiceCell"
    static let cellChoices    = "ChoicesCell"
  }
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Internal variables
  var questIndex: Int!

  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
    setupTableView()
  }
  
  func setupTableView() {
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeNotification()
  }
  
  // MARK: - Notification
  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.quests, options: [], context: nil)
  }
  
  func removeNotification() {
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.quests)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == TaleAPI.NotificationKeyPath.quests {
      updateUI()
    }
  }

  // MARK: - Work with interface
  func updateUI() {
    activityIndicator.stopAnimating()
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension QuestViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 2 && TaleAPI.shared.playerInformationManager.quests[questIndex].choice != nil {
      return "Поступки героя"
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
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellQuest) as! QuestTableViewCell

      cell.configuredQuest(info: TaleAPI.shared.playerInformationManager.quests[questIndex])

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellActor)

      let nameActors = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].nameActorsRepresentation
      
      if let goal = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].goal {
        cell?.textLabel?.text = "\(nameActors) \(goal)"
      } else if let name = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].name {
        cell?.textLabel?.text = "\(nameActors) \(name)"
      }
      
      cell?.detailTextLabel?.text = TaleAPI.shared.playerInformationManager.quests[questIndex].actors[indexPath.row].info
      
      return cell!
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellMadeChoice)
      
      guard let choice = TaleAPI.shared.playerInformationManager.quests[questIndex].choiceRepresentation else {
        return cell!
      }
      cell?.textLabel?.text = choice
      
      return cell!
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellChoices)
      cell?.textLabel?.text = TaleAPI.shared.playerInformationManager.quests[questIndex].choiceAlternatives[indexPath.row].infoRepresentation

      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
}

// MARK: - UITableViewDelegate
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
