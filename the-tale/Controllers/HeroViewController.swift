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
  
  var hiddenDropItemBag = true

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNotification()
    setupTableView()
    setupBackgroundStatusBar()
    
    updateHeroUI()
  }
  
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateHeroUI), name: NSNotification.Name("updateHeroBaseParameters"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateHeroUI), name: NSNotification.Name("updateHeroSecondParameters"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateHeroUI), name: NSNotification.Name("updateEnergy"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateQuestsUI), name: NSNotification.Name("updateQuests"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateCompanionUI), name: NSNotification.Name("updateCompanion"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateEquipmentUI), name: NSNotification.Name("updateEquipment"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateBagUI), name: NSNotification.Name("updateBag"), object: nil)
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
    TaleAPI.shared.refreshGameInformation()
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
    if TaleAPI.shared.heroSecondaryParameters?.lootItemsCount == 0 {
      hiddenDropItemBag = true
      return
    }
    
    if let totalEnergy = TaleAPI.shared.energy?.energyTotal(),
       let dropItemCost = TaleAPI.shared.basicInformation?.dropItem,
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
    TaleAPI.shared.tryDropItem()
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
      if TaleAPI.shared.companion != nil {
        return 1
      }
      return 0
    case 2:
      return TaleAPI.shared.quests.count
    case 3:
      return TaleAPI.shared.equipment.count
    case 4:
      if hiddenDropItemBag {
        return 0
      }
      return 1
    case 5:
      return TaleAPI.shared.bag.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return TaleAPI.shared.heroBaseParameters?.nameRepresentation()
    case 1:
      return TaleAPI.shared.companion?.nameRepresentation()
    case 2:
      return "Задания"
    case 3:
      return "Экипировка"
    case 4:
      return TaleAPI.shared.heroSecondaryParameters?.lootItemsCountRepresentation()
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
            
      if let heroBaseParameters      = TaleAPI.shared.heroBaseParameters,
         let heroSecondaryParameters = TaleAPI.shared.heroSecondaryParameters,
         let energy                  = TaleAPI.shared.energy,
         let might                   = TaleAPI.shared.might {
        cell.configuredHeroBaseParameters(info: heroBaseParameters)
        cell.configuredHeroSecondParameters(info: heroSecondaryParameters)
        cell.configuredEnergy(info: energy)
        cell.configuredMight(info: might)
      }

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: companionCell) as! CompanionTableViewCell

      if let companion = TaleAPI.shared.companion {
        cell.configuredCompanion(info: companion)
      }
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: questCell)
      cell?.textLabel?.text = TaleAPI.shared.quests[indexPath.row].nameRepresentation()
      cell?.textLabel?.adjustsFontSizeToFitWidth = true
      
      return cell!
    case 3:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: equipmentCell) as! EquipmentTableViewCell
      cell.configuredEquipment(info: TaleAPI.shared.equipment[indexPath.row])
      
      return cell
    case 4:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: dropBagItemCell) as! DropBagItemTableViewCell
      cell.configuredDropItemButton(isHidden: hiddenDropItemBag)
      
      return cell
    case 5:
      let cell = tableView.dequeueReusableCell(withIdentifier: bagCell)
      cell?.textLabel?.text = TaleAPI.shared.bag[indexPath.row].name.capitalizeFirstLetter
      
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
