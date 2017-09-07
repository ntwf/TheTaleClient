//
//  HeroViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {
  // MARK: - Internal constants
  enum Constatns {
    static let cellHero        = "HeroCell"
    static let cellQuest       = "QuestsCell"
    static let cellCompanion   = "CompanionCell"
    static let cellEquipment   = "EquipmentCell"
    static let cellDropBagItem = "DropBagItemCell"
    static let cellBag         = "BagCell"
  }
  
  let refreshControl = UIRefreshControl()
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Internal variables
  var statusBarView: UIView?
  
  var quests: [Quest] = []
  var equipment: [Artifact] = []
  var bag: [[Artifact : Int]] = [[:]]
  
  var hiddenDropItemBag = true

  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupBackgroundStatusBar()
    
    updateHeroUI()
  }

  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(HeroViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl  = refreshControl
    tableView.tableFooterView = UIView()
  }
  
  func setupBackgroundStatusBar() {
    statusBarView                  = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, transparency: 0.8)
    view.addSubview(statusBarView!)
  }
  
  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addNotification()
    
    navigationController?.isNavigationBarHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeNotification()
    
    navigationController?.isNavigationBarHidden = false
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    switch UIDevice.current.orientation {
    case UIDeviceOrientation.portrait, UIDeviceOrientation.portraitUpsideDown:
      statusBarView?.isHidden = false
    case UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight:
      statusBarView?.isHidden = true
    default:
      break
    }
  }
  
  // MARK: - Notification
  func addNotification() {
    DispatchQueue.main.async {
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroBaseParameters, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroSecondaryParameters, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.energy, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.quests, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.companion, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.equipment, options: [.initial, .new], context: nil)
      TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.bag, options: [.initial, .new], context: nil)
    }
  }
  
  func removeNotification() {
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroBaseParameters)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroSecondaryParameters)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.energy)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.quests)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.companion)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.equipment)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.bag)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == TaleAPI.NotificationKeyPath.heroBaseParameters ||
       keyPath == TaleAPI.NotificationKeyPath.heroSecondaryParameters ||
       keyPath == TaleAPI.NotificationKeyPath.energy {
      updateHeroUI()
    }
    
    if keyPath == TaleAPI.NotificationKeyPath.quests, let newQuests = change?[.newKey] as? [Quest] {
      quests = newQuests
      updateUITableSection(IndexSet(integer: 2))
    }
    
    if keyPath == TaleAPI.NotificationKeyPath.companion {
      updateUITableSection(IndexSet(integer: 1))
    }
    
    if keyPath == TaleAPI.NotificationKeyPath.equipment, let newEquipment = change?[.newKey] as? [Artifact] {
      equipment = newEquipment
      updateUITableSection(IndexSet(integer: 3))
    }
    
    if keyPath == TaleAPI.NotificationKeyPath.bag, let newBag = change?[.newKey] as? [[Artifact: Int]] {
      bag = newBag
      updateUITableSection(IndexSet(integer: 5))
    }
  }

  // MARK: - Work with interface
  func updateHeroUI() {
    updateUITableSection(IndexSet(integer: 0))
    
    checkAvalibleDropItemBagButton()
    updateUITableSection(IndexSet(integer: 4))
  }

  func updateUITableSection(_ section: IndexSet) {
    UIView.performWithoutAnimation {
      tableView.reloadSections(section, with: .none)
    }
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.playerInformationAutorefresh = .start
    refreshControl.endRefreshing()
  }

  func checkAvalibleDropItemBagButton() {
    if TaleAPI.shared.playerInformationManager.heroSecondaryParameters?.lootItemsCount == 0 {
      hiddenDropItemBag = true
      return
    }
    
    if let totalEnergy  = TaleAPI.shared.playerInformationManager.energy?.energyTotal,
       let dropItemCost = TaleAPI.shared.gameInformationManager.gameInformation?.dropItem,
       totalEnergy >= dropItemCost {
      hiddenDropItemBag = false
      return
    }
    
    hiddenDropItemBag = true
  }

  // MARK: - Prepare segue data
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == AppConfiguration.Segue.toQuest {
      if let indexPath                 = tableView.indexPathForSelectedRow,
         let destinationViewController = segue.destination as? QuestViewController {
        destinationViewController.questIndex = indexPath.row
      }
    }
  }
  
  // MARK: - Outlets action
  @IBAction func dropItemBagTapped(_ sender: UIButton) {
    hiddenDropItemBag = false
    tableView.reloadSections(IndexSet(integer: 4), with: .none)
    
    TaleAPI.shared.tryDropItem { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryDropItem \(error)")
      default: break
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension HeroViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      if TaleAPI.shared.playerInformationManager.companion != nil {
        return 1
      }
      return 0
    case 2:
      return quests.count
    case 3:
      return equipment.count
    case 4:
      if hiddenDropItemBag {
        return 0
      }
      return 1
    case 5:
      return bag.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return TaleAPI.shared.playerInformationManager.heroBaseParameters?.nameRepresentation
    case 1:
      return TaleAPI.shared.playerInformationManager.companion?.nameRepresentation
    case 2:
      return "Задания"
    case 3:
      return "Экипировка"
    case 4:
      return TaleAPI.shared.playerInformationManager.heroSecondaryParameters?.lootItemsCountRepresentation
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return CGFloat(132)
    case 1:
      return CGFloat(76)
    default:
      return CGFloat(44)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellHero) as! HeroTableViewCell
      
      cell.configuredHeroBaseParameters(info: TaleAPI.shared.playerInformationManager.heroBaseParameters!)
      cell.configuredHeroSecondParameters(info: TaleAPI.shared.playerInformationManager.heroSecondaryParameters!)
      cell.configuredEnergy(info: TaleAPI.shared.playerInformationManager.energy!)
      cell.configuredMight(info: TaleAPI.shared.playerInformationManager.might!)

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellCompanion) as! CompanionTableViewCell
      cell.configuredCompanion(info: TaleAPI.shared.playerInformationManager.companion!)
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellQuest)
      cell?.textLabel?.text = quests[indexPath.row].nameRepresentation
      cell?.textLabel?.adjustsFontSizeToFitWidth = true
 
      if quests[indexPath.row].choiceAlternatives.count >= 1 {
        cell?.textLabel?.isHighlighted = true
      }
      
      return cell!
    case 3:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellEquipment) as! EquipmentTableViewCell
      cell.configuredEquipment(info: equipment[indexPath.row])

      return cell
    case 4:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellDropBagItem) as! DropBagItemTableViewCell
      cell.configuredDropItemButton(isHidden: hiddenDropItemBag)
      
      return cell
    case 5:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellBag)
      
      guard let artifact = bag[indexPath.row].first?.key.nameRepresentation,
            let counter  = bag[indexPath.row].first?.value else {
        return cell!
      }
      
      if counter >= 2 {
        cell?.textLabel?.text = "\(artifact) (x\(counter))"
      } else {
        cell?.textLabel?.text = "\(artifact)"
      }
      
      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
}

// MARK: - UITableViewDelegate
extension HeroViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
