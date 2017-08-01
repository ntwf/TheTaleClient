//
//  JournalViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 29/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var allMessages         = [Message]()
  var actionText          = ""
  var actionProgress      = 0.0
  var isEnabledHelpButton = false
  
  let actionCell  = "ActionCell"
  let messageCell = "MessageCell"
  let diarySegue  = "toDiarySegue"
  
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator.startAnimating()
    
    setupNotification()
    setupTableView()
    
    TaleAPI.shared.refreshGameInformation()
  }
  
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateMessages), name: NSNotification.Name("updateJournalMessages"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateActionUI), name: NSNotification.Name("updateJournalAction"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateDateUI), name: NSNotification.Name("updateTurn"), object: nil)
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(JournalViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.allowsSelection    = false
    tableView.tableFooterView    = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isNavigationBarHidden = false
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.refreshGameInformation()
    refreshControl.endRefreshing()
  }
  
  func updateDateUI() {
    timeLabel.text = TaleAPI.shared.turn?.timeRepresentation()
  }
  
  func updateActionUI() {
    checkAvalibleHelpButton()
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  func updateMessages() {
    if allMessages.count > 0 || TaleAPI.shared.messages.count != 0 {
      activityIndicator.stopAnimating()
    }
    
    for message in TaleAPI.shared.messages {
      tableView.beginUpdates()
      
      allMessages.insert(message, at: 0)
      tableView.insertRows(at: [IndexPath(row:0, section: 1)], with: .bottom)
      
      while allMessages.count > 35 {
        allMessages.removeLast()
        tableView.deleteRows(at: [IndexPath(row: allMessages.count - 1, section: 1)], with: .fade)
      }
      
      tableView.endUpdates()
    }
  }
  
  func checkAvalibleHelpButton() {
    if let totalEnergy = TaleAPI.shared.energy?.energyTotal(),
       let helpCost = TaleAPI.shared.basicInformation?.help,
       totalEnergy >= helpCost {
      isEnabledHelpButton = true
      return
    }
    
    isEnabledHelpButton = false
  }
  
  @IBAction func helpButtonTapped(_ sender: UIButton) {
    isEnabledHelpButton = false
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
    TaleAPI.shared.tryActionHelp()
  }
  
  @IBAction func diaryButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: diarySegue, sender: nil)
  }
  
}

extension JournalViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return allMessages.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: actionCell) as! JournalTableViewActionCell
      
      if let action = TaleAPI.shared.action,
         let heroBaseParameters = TaleAPI.shared.heroBaseParameters,
         let energy = TaleAPI.shared.energy {
        cell.configuredAction(info: action)
        cell.configuredHeroBase(info: heroBaseParameters)
        cell.configuredEnergy(info: energy)
        cell.configuredHelpButton(isEnabled: isEnabledHelpButton)
      }

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: messageCell)
      
      cell?.textLabel?.text = allMessages[indexPath.row].text
      
      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
  
}
