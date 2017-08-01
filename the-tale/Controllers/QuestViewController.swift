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
  
  let questCell  = "QuestCell"
  let actorCell  = "ActorsCell"
  let choiceCell = "ChoiceCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
    setupNotification()
    setupTableView()
  }

  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateQuests"), object: nil)
  }
  
  func setupTableView() {
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }

  func updateUI() {
    activityIndicator.stopAnimating()
    tableView.reloadData()
  }
  
}

extension QuestViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 2 && TaleAPI.shared.quests[questIndex].choiceAlternatives.count != 0 {
      return "Как поступим?"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return TaleAPI.shared.quests[questIndex].actors.count
    case 2:
      return TaleAPI.shared.quests[questIndex].choiceAlternatives.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: questCell) as! QuestTableViewCell

      cell.configuredQuest(info: TaleAPI.shared.quests[questIndex])

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: actorCell)

      let nameActors = TaleAPI.shared.quests[questIndex].actors[indexPath.row].nameActorsRepresentation()
      
      if let goal = TaleAPI.shared.quests[questIndex].actors[indexPath.row].goal {
        cell?.textLabel?.text = "\(nameActors) \(goal)"
      } else if let name = TaleAPI.shared.quests[questIndex].actors[indexPath.row].name {
        cell?.textLabel?.text = "\(nameActors) \(name)"
      }
      
      cell?.detailTextLabel?.text = TaleAPI.shared.quests[questIndex].actors[indexPath.row].description
      
      return cell!
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: choiceCell)
      cell?.textLabel?.text = TaleAPI.shared.quests[questIndex].choiceAlternatives[indexPath.row].description.capitalizeFirstLetter

      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
  
}

extension QuestViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 2 else {
      return
    }
    activityIndicator.startAnimating()
    
    let uidChoose = TaleAPI.shared.quests[questIndex].choiceAlternatives[indexPath.row].choiceID
    TaleAPI.shared.tryChooseQuest(uidChoose)
  }
  
}
