//
//  CardViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
  
  // MARK: - Internal constants
  enum Constants {
    static let cellHelp = "HelpBarrierCell"
    static let cellCard = "CardCell"
    
    static let keyPathCardsInfo = #keyPath(TaleAPI.playerInformationManager.cardsInfo)
  }

  let refreshControl = UIRefreshControl()
  
  // MARK: - Internal variables
  var isHiddenGetCardButton   = true
  var isHiddenMergeCardButton = true
  
  var oldValueCards = [Card]()
  var selectedCards = [String: Card]()

  // MARK: Recived from API
  var cardsInfo    = CardsInfo(jsonObject: [:])
  var currentCards = [Card]()

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Load and setup view controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNotification()
    setupTableView()
  }
  
  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: Constants.keyPathCardsInfo, options: [.new, .initial], context: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(catchNotification(notification:)),
                                           name: .TaleAPINonblockingOperationRecivedAlarm,
                                           object: nil)
  }

  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(CardViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 46
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == Constants.keyPathCardsInfo, let newCardsInfo = change?[.newKey] as? CardsInfo {
      cardsInfo    = newCardsInfo
      currentCards = newCardsInfo.cards
      
      updateUI()
    }
  }

  func catchNotification(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let message  = userInfo[TaleAPI.UserInfoKey.nonblockingOperation] as? String else {
        return
    }
    
    let alertController = UIAlertController(title: "Ошибка!", message: message)
    present(alertController, animated: true, completion: nil)
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.playerInformationAutorefresh = .start
    refreshControl.endRefreshing()
  }
  
  // MARK: - Work with interface
  func updateUI() {
    activityIndicator.stopAnimating()

    showNewCard()
    
    selectedCards.removeAll()
    isHiddenMergeCardButton = true
    
    checkAvalibleGetCardButton()
    
    tableView.reloadData()
  }
  
  func checkAvalibleGetCardButton() {
    if let helpCount = cardsInfo?.helpCount, let helpBarrier = cardsInfo?.helpBarrier, helpCount >= helpBarrier {
      isHiddenGetCardButton = false
      return
    }
    
    isHiddenGetCardButton = true
  }
  
  func checkAvalibleMergeCardButton() {
    if selectedCards.count > 1 {
      isHiddenMergeCardButton = false
    } else {
      isHiddenMergeCardButton = true
    }
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  func showNewCard() {
    guard let cards = cardsInfo?.cards else { return }
    let newCard = cards.filter { !oldValueCards.contains($0) }

    if newCard.count == 1, let cardName = newCard.first?.nameRepresentation {
      let alertController = UIAlertController(title: "Получена новая карта.", message: cardName)
      present(alertController, animated: true, completion: nil)
    }
    
    oldValueCards = cards
  }
  
  // MARK: - Outlets action
  @IBAction func getCardButtonTapped(_ sender: UIButton) {
    isHiddenGetCardButton = true
    activityIndicator.startAnimating()
    
    TaleAPI.shared.tryGetCard { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryGetCard \(error)")
      default: break
      }
    }
    
    updateUI()
  }
  
  @IBAction func mergeCardButtonTapped(_ sender: UIButton) {
    isHiddenGetCardButton = true
    activityIndicator.startAnimating()
    
    let uidCards = selectedCards.map({ $0.key })
                                .joined(separator: ",")
      
    TaleAPI.shared.tryMergeCard(uidCards: uidCards) { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("tryMergeCard \(error)")
      default: break
      }
    }
    
    updateUI()
  }
  
  // MARK: - Unload controller
  deinit {
    TaleAPI.shared.removeObserver(self, forKeyPath: Constants.keyPathCardsInfo)
  }
  
}

// MARK: - UITableViewDataSource
extension CardViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return cardsInfo?.cards.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellHelp) as! HelpBarrierTableViewCell
      
      if let cards = cardsInfo {
        cell.configured()
        cell.configuredHelpBarrier(with: cards)
        cell.configuredGetCardButton(isHidden: isHiddenGetCardButton)
        cell.configuredMergeCardButton(isHidden: isHiddenMergeCardButton)
      }

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellCard) as! CardTableViewCell
      
      let cards = cardsInfo?.cards
      
      if let card           = cards?[indexPath.row],
         let cardDescription = Types.shared.card?.type[card.type] as? [String] {
        cell.configuredCard(info: card, description: cardDescription[1])
      }

      return cell
    default:
      fatalError("Wrong number of sections")
    }
  }

}

// MARK: - UITableViewDelegate
extension CardViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let card = cardsInfo?.cards[indexPath.row],
          let uid  = cardsInfo?.cards[indexPath.row].uidRepresentation else {
        return
    }

    selectedCards.updateValue(card, forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let uid = cardsInfo?.cards[indexPath.row].uidRepresentation else {
        return
    }
    selectedCards.removeValue(forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let useCard = UITableViewRowAction(style: .destructive, title: "Использовать") { [weak self] (_, indexPath) in
      guard let strongSelf = self else {
        return
      }
      
      if let uidCard = strongSelf.cardsInfo?.cards[indexPath.row].uidRepresentation {
        
        TaleAPI.shared.tryUseCard(uidCard: uidCard) { (result) in
          switch result {
          case .success(let data):
            TaleAPI.shared.checkStatusOperation(operation: data)
          case .failure(let error as NSError):
            debugPrint("tryUseCard \(error)")
          default: break
          }
        }
        
      }
    }
    
    useCard.backgroundColor = #colorLiteral(red: 0.4069784284, green: 0.6598457694, blue: 0.7288877368, alpha: 1)
    
    return [useCard]
  }
  
}
