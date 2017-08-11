//
//  HeroViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 01/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  var statusBarView: UIView?
  
  let refreshControl = UIRefreshControl()
  
  let heroCell        = "HeroCell"
  let questCell       = "QuestsCell"
  let companionCell   = "CompanionCell"
  let equipmentCell   = "EquipmentCell"
  let dropBagItemCell = "DropBagItemCell"
  let bagCell         = "BagCell"
  
  let keyPathHeroBaseParameters      = #keyPath(TaleAPI.playerInformationManager.heroBaseParameters)
  let keyPathHeroSecondaryParameters = #keyPath(TaleAPI.playerInformationManager.heroSecondaryParameters)
  let keyPathEnergy                  = #keyPath(TaleAPI.playerInformationManager.energy)
  let keyPathQuests                  = #keyPath(TaleAPI.playerInformationManager.quests)
  let keyPathCompanion               = #keyPath(TaleAPI.playerInformationManager.companion)
  let keyPathEquipment               = #keyPath(TaleAPI.playerInformationManager.equipment)
  let keyPathBag                     = #keyPath(TaleAPI.playerInformationManager.bag)
  
  var hiddenDropItemBag = true

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNotification()
    setupTableView()
    setupBackgroundStatusBar()
    
    updateHeroUI()
  }
  
  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathHeroBaseParameters, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathHeroSecondaryParameters, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathEnergy, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathQuests, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathCompanion, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathEquipment, options: [.new], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathBag, options: [.new], context: nil)
  }
  
  deinit {
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathHeroBaseParameters)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathHeroSecondaryParameters)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathEnergy)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathQuests)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathCompanion)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathEquipment)
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathBag)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == keyPathHeroBaseParameters ||
       keyPath == keyPathHeroSecondaryParameters ||
       keyPath == keyPathEnergy {
      updateHeroUI()
    }
    
    if keyPath == keyPathQuests {
      updateQuestsUI()
    }
    
    if keyPath == keyPathCompanion {
      updateCompanionUI()
    }
    
    if keyPath == keyPathEquipment {
      updateEquipmentUI()
    }
    
    if keyPath == keyPathBag {
      updateBagUI()
    }
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(HeroViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.tableFooterView    = UIView()
  }
  
  func setupBackgroundStatusBar() {
    statusBarView                  = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView?.backgroundColor = UIColor(red: 255, green: 255, blue: 255, transparency: 0.8)
    view.addSubview(statusBarView!)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
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
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.playerInformationAutorefresh = .start
    refreshControl.endRefreshing()
  }
  
  func updateHeroUI() {
    UIView.performWithoutAnimation {
      tableView.reloadSections(IndexSet(integer: 0), with: .none)
      
      checkAvalibleDropItemBagButton()
      tableView.reloadSections(IndexSet(integer: 4), with: .none)
    }
  }
  
  func updateCompanionUI() {
    UIView.performWithoutAnimation {
      tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
  }

  func updateQuestsUI() {
    UIView.performWithoutAnimation {
      tableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
  }
  
  func updateEquipmentUI() {
    UIView.performWithoutAnimation {
      tableView.reloadSections(IndexSet(integer: 3), with: .none)
    }
  }
  
  func updateBagUI() {
    UIView.performWithoutAnimation {
      tableView.reloadSections(IndexSet(integer: 5), with: .none)
    }
  }
  
  func checkAvalibleDropItemBagButton() {
    if TaleAPI.shared.playerInformationManager.heroSecondaryParameters?.lootItemsCount == 0 {
      hiddenDropItemBag = true
      return
    }
    
    if let totalEnergy  = TaleAPI.shared.playerInformationManager.energy?.energyTotal(),
       let dropItemCost = TaleAPI.shared.gameInformationManager.gameInformation?.dropItem,
       totalEnergy >= dropItemCost {
      hiddenDropItemBag = false
      return
    }
    
    hiddenDropItemBag = true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toQuestSegue" {
      if let indexPath                 = tableView.indexPathForSelectedRow,
         let destinationViewController = segue.destination as? QuestViewController {
        destinationViewController.questIndex = indexPath.row
      }
    }
  }
  
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
      return TaleAPI.shared.playerInformationManager.quests.count
    case 3:
      return TaleAPI.shared.playerInformationManager.equipment.count
    case 4:
      if hiddenDropItemBag {
        return 0
      }
      return 1
    case 5:
      return TaleAPI.shared.playerInformationManager.bag.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return TaleAPI.shared.playerInformationManager.heroBaseParameters?.nameRepresentation()
    case 1:
      return TaleAPI.shared.playerInformationManager.companion?.nameRepresentation()
    case 2:
      return "Задания"
    case 3:
      return "Экипировка"
    case 4:
      return TaleAPI.shared.playerInformationManager.heroSecondaryParameters?.lootItemsCountRepresentation()
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
      let cell = tableView.dequeueReusableCell(withIdentifier: heroCell) as! HeroTableViewCell
            
      if let heroBaseParameters      = TaleAPI.shared.playerInformationManager.heroBaseParameters,
         let heroSecondaryParameters = TaleAPI.shared.playerInformationManager.heroSecondaryParameters,
         let energy                  = TaleAPI.shared.playerInformationManager.energy,
         let might                   = TaleAPI.shared.playerInformationManager.might {
        cell.configuredHeroBaseParameters(info: heroBaseParameters)
        cell.configuredHeroSecondParameters(info: heroSecondaryParameters)
        cell.configuredEnergy(info: energy)
        cell.configuredMight(info: might)
      }

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: companionCell) as! CompanionTableViewCell

      if let companion = TaleAPI.shared.playerInformationManager.companion {
        cell.configuredCompanion(info: companion)
      }
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: questCell)
      cell?.textLabel?.text = TaleAPI.shared.playerInformationManager.quests[indexPath.row].nameRepresentation()
      cell?.textLabel?.adjustsFontSizeToFitWidth = true
 
      if TaleAPI.shared.playerInformationManager.quests[indexPath.row].choiceAlternatives.count >= 1 {
        cell?.textLabel?.isHighlighted = true
      }
      
      return cell!
    case 3:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: equipmentCell) as! EquipmentTableViewCell
      cell.configuredEquipment(info: TaleAPI.shared.playerInformationManager.equipment[indexPath.row])

      return cell
    case 4:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: dropBagItemCell) as! DropBagItemTableViewCell
      cell.configuredDropItemButton(isHidden: hiddenDropItemBag)
      
      return cell
    case 5:
      let cell = tableView.dequeueReusableCell(withIdentifier: bagCell)
      
      guard let artifact = TaleAPI.shared.playerInformationManager.bag[indexPath.row].first?.key.name.capitalizeFirstLetter,
            let counter  = TaleAPI.shared.playerInformationManager.bag[indexPath.row].first?.value else {
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

extension HeroViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
