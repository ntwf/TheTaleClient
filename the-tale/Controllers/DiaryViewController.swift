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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.startAnimating()
    
    setupNotification()
    setupTableView()
  }
  
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateDiary"), object: nil)
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(DiaryViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 78
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.allowsSelection    = false
    tableView.tableFooterView    = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    allMessages = TaleAPI.shared.diaryMessages
    TaleAPI.shared.fetchDiary()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    TaleAPI.shared.diaryMessages = allMessages
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.fetchDiary()
    refreshControl.endRefreshing()
  }
  
  func updateUI() {
    activityIndicator.stopAnimating()
    
    for message in TaleAPI.shared.diaryMessages {
      tableView.beginUpdates()
      
      allMessages.insert(message, at: 0)
      tableView.insertRows(at: [IndexPath(row:0, section: 0)], with: .automatic)
      
      while allMessages.count > 40 {
        allMessages.removeLast()
        tableView.deleteRows(at: [IndexPath(row: allMessages.count - 1, section: 0)], with: .fade)
      }
      
      tableView.endUpdates()
    }
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
