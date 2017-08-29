//
//  JournalViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 29/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {
  // MARK: - Internal constants
  enum Constatns {
    static let cellAction  = "ActionCell"
    static let cellMessage = "MessageCell"
  }
  
  let refreshControl = UIRefreshControl()
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Internal variables
  var allMessages         = [JournalMessage]()
  var actionText          = ""
  var actionProgress      = 0.0
  var isEnabledHelpButton = false
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator.startAnimating()

    setupTableView()
    addNotification()
    
    TaleAPI.shared.playerInformationAutorefresh = .start
  }

  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(JournalViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
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
    
    navigationController?.isNavigationBarHidden = false
  }
  
  // MARK: - Notification
  func addNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.turn, options: [], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.action, options: [], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.energy, options: [], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroBaseParameters, options: [], context: nil)
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.journal, options: [], context: nil)
  }
  
  func removeNotification() {
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.turn)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.action)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.energy)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.heroBaseParameters)
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.journal)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == TaleAPI.NotificationKeyPath.turn {
      updateDateUI()
    }
    // I don't know how and when the API is updated. Necessary to update the cell several times over the course of the game turn.
    if keyPath == TaleAPI.NotificationKeyPath.action ||
       keyPath == TaleAPI.NotificationKeyPath.energy ||
       keyPath == TaleAPI.NotificationKeyPath.heroBaseParameters {
      updateActionUI()
    }
    if keyPath ==  TaleAPI.NotificationKeyPath.journal {
      updateMessages()
    }
  }
  
  // MARK: - Work with interface
  func updateDateUI() {
    timeLabel.text = TaleAPI.shared.playerInformationManager.turn?.timeRepresentation
  }
  
  func updateActionUI() {
    checkAvalibleHelpButton()
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  func updateMessages() {
    if allMessages.count > 0 || TaleAPI.shared.playerInformationManager.journal.count != 0 {
      activityIndicator.stopAnimating()
    }
    
    for message in TaleAPI.shared.playerInformationManager.journal {
      tableView.beginUpdates()
      
      allMessages.insert(message, at: 0)
      tableView.insertRows(at: [IndexPath(row:0, section: 1)], with: .bottom)
      
      while allMessages.count > 50 {
        allMessages.removeLast()
        tableView.deleteRows(at: [IndexPath(row: allMessages.count - 1, section: 1)], with: .fade)
      }
      
      tableView.endUpdates()
    }
  }
  
  func checkAvalibleHelpButton() {
    if let totalEnergy = TaleAPI.shared.playerInformationManager.energy?.energyTotal,
       let helpCost    = TaleAPI.shared.gameInformationManager.gameInformation?.help,
       totalEnergy >= helpCost {
      isEnabledHelpButton = true
      return
    }
    
    isEnabledHelpButton = false
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.playerInformationAutorefresh = .start
    refreshControl.endRefreshing()
  }
  
  // MARK: - Action sheet
  func showActionSheet(save text: String) {
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    
    let saveButton = UIAlertAction(title: "Скопировать", style: .default) { _ in
      let pasteboard = UIPasteboard.general
      
      pasteboard.string = text
    }
    
    let okButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    
    alertController.addAction(okButton)
    alertController.addAction(saveButton)
    
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Outlets action
  @IBAction func helpButtonTapped(_ sender: UIButton) {
    isEnabledHelpButton = false
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
    
    TaleAPI.shared.tryActionHelp { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryActionHelp \(error)")
      default: break
      }
    }
  }
  
  @IBAction func diaryButtonTapped(_ sender: UIButton) {
    performSegue(withIdentifier: AppConfiguration.Segue.toDiary, sender: nil)
  }
  
  // MARK: - Deinitialize
  deinit {
    removeNotification()
  }
}

// MARK: - UITableViewDataSource
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
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellAction) as! JournalTableViewActionCell
      
      if let action             = TaleAPI.shared.playerInformationManager.action,
         let heroBaseParameters = TaleAPI.shared.playerInformationManager.heroBaseParameters,
         let energy             = TaleAPI.shared.playerInformationManager.energy {
        cell.configuredAction(info: action)
        cell.configuredHeroBase(info: heroBaseParameters)
        cell.configuredEnergy(info: energy)
        cell.configuredHelpButton(isEnabled: isEnabledHelpButton)
      }

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMessage)
      
      cell?.textLabel?.text = allMessages[indexPath.row].text
      
      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
  
}

// MARK: - UITableViewDelegate
extension JournalViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      showActionSheet(save: allMessages[indexPath.row].text)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
