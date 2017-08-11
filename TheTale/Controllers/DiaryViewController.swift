//
//  DiaryViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  let diaryCell = "Cell"
  
  var allMessages    = [DiaryMessage]()
  let refreshControl = UIRefreshControl()
  
  let keyPathDiary = #keyPath(TaleAPI.diaryManager.diary)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.startAnimating()
    
    setupNotification()
    setupTableView()
  }
  
  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathDiary, options: [.new], context: nil)
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(DiaryViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == keyPathDiary {
      updateUI()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    allMessages = TaleAPI.shared.diaryManager.oldDiary
    fetchDiary()
  }

  func refreshData(sender: UIRefreshControl) {
    fetchDiary()
    refreshControl.endRefreshing()
  }
  
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    TaleAPI.shared.diaryManager.oldDiary = allMessages
  }
  
  deinit {
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathDiary)
  }
  
}

extension DiaryViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allMessages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // swiftlint:disable:next force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: diaryCell) as! DiaryTableViewCell
    
    cell.configuredDiary(diary: allMessages[indexPath.row])
    
    return cell
  }
  
}

extension DiaryViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      let messageData = allMessages[indexPath.row]
      let text        = "\(messageData.positionRepresentation())\n\(messageData.messageRepresentation())\n\(messageData.gameDate)"
      
      showActionSheet(save: text)
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
