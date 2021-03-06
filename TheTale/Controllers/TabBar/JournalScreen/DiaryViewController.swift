//
//  DiaryViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
  // MARK: - Internal constants
  enum Constants {
    static let cellDiary = "Cell"
  }
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: - Internal variables
  var allMessages    = [DiaryMessage]()
  let refreshControl = UIRefreshControl()

  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.startAnimating()
    
    setupTableView()
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(DiaryViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }

  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addNotification()
    
    allMessages = TaleAPI.shared.diaryManager.oldDiary
    fetchDiary()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    removeNotification()
    
    TaleAPI.shared.diaryManager.oldDiary = allMessages
  }
  
  // MARK: - Notification
  func addNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.diary, options: [], context: nil)
  }
  
  func removeNotification() {
    TaleAPI.shared.removeObserver(self, forKeyPath: TaleAPI.NotificationKeyPath.diary)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == TaleAPI.NotificationKeyPath.diary {
      updateUI()
    }
  }
  
  // MARK: - Request to API
  func fetchDiary() {
    TaleAPI.shared.getDiary { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.diaryManager.getNewMessages(jsonObject: data)
      case .failure(let error as NSError):
        debugPrint("fetchDiary \(error)")
      default: break
      }
    }
  }
  
  // MARK: - Work with interface
  func updateUI() {
    activityIndicator.stopAnimating()
    
    for message in TaleAPI.shared.diaryManager.diary {
      tableView.beginUpdates()
      
      allMessages.insert(message, at: 0)
      tableView.insertRows(at: [IndexPath(row:0, section: 0)], with: .automatic)
      
      while allMessages.count > 50 {
        allMessages.removeLast()
        tableView.deleteRows(at: [IndexPath(row: allMessages.count - 1, section: 0)], with: .fade)
      }
      
      tableView.endUpdates()
    }
  }
  
  func refreshData(sender: UIRefreshControl) {
    fetchDiary()
    refreshControl.endRefreshing()
  }
  
  // MARK: - Action sheet
  func showActionSheet(_ sender: UITableViewCell, text: String) {
    // [Warning] <_UIPopoverBackgroundVisualEffectView>
    // https://forums.developer.apple.com/thread/53677
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    let saveButton = UIAlertAction(title: "Скопировать", style: .default) { _ in
      let pasteboard = UIPasteboard.general
      
      pasteboard.string = text
    }
    
    let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    
    alertController.addAction(cancelButton)
    alertController.addAction(saveButton)
    
    if let popoverController = alertController.popoverPresentationController {
      popoverController.sourceView               = self.view
      popoverController.sourceRect               = sender.frame
      popoverController.permittedArrowDirections = []
    }
    
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension DiaryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allMessages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // swiftlint:disable:next force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellDiary) as! DiaryTableViewCell
    
    cell.configuredDiary(diary: allMessages[indexPath.row])
    
    return cell
  }
}

// MARK: - UITableViewDelegate
extension DiaryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0, let cell = tableView.cellForRow(at: indexPath) {
      let messageData = allMessages[indexPath.row]
      let text        = "\(messageData.positionRepresentation)\n\(messageData.messageRepresentation)\n\(messageData.gameDate)"
      showActionSheet(cell, text: text)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
