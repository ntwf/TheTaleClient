//
//  CardViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 25/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let refreshControl = UIRefreshControl()
  
  let helpCell = "HelpBarrierCell"
  let cardCell = "CardCell"
  
  let keyPathCardsInfo = #keyPath(TaleAPI.playerInformationManager.cardsInfo)
  
  var hiddenGetCard   = true
  var hiddenMergeCard = true

  var selectedCard = [String: Card]()
  var currentCards = [Card]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
    setupNotification()
    setupTableView()
    
    checkAvalibleGetCardButton()
  }
  
  func setupNotification() {
    TaleAPI.shared.addObserver(self, forKeyPath: keyPathCardsInfo, options: [.new], context: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(catchNotification(notification:)), name: .nonblockingOperationAlarm, object: nil)
  }

  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(CardViewController.refreshData(sender:)), for: .valueChanged)
    
    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 46
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == #keyPath(TaleAPI.playerInformationManager.cardsInfo) {
      updateUI()
    }
  }

  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.playerInformationAutorefresh = .start
    refreshControl.endRefreshing()
  }
  
  func updateUI() {
    activityIndicator.stopAnimating()

    showNewCard()
    
    selectedCard.removeAll()

    hiddenMergeCard = true
    checkAvalibleGetCardButton()
    
    tableView.reloadData()
  }
  
  func checkAvalibleGetCardButton() {
    if let helpCount = TaleAPI.shared.playerInformationManager.cardsInfo?.helpCount,
       let helpBarrier = TaleAPI.shared.playerInformationManager.cardsInfo?.helpBarrier,
       helpCount >= helpBarrier {
      hiddenGetCard = false
      return
    }
    
    hiddenGetCard = true
  }
  
  func checkAvalibleMergeCardButton() {
    if selectedCard.count > 1 {
      hiddenMergeCard = false
    } else {
      hiddenMergeCard = true
    }
    tableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  func saveCurrentCard() {
    guard let cards = TaleAPI.shared.playerInformationManager.cardsInfo?.cards else { return }
    currentCards = cards
  }
  
  func catchNotification(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let message  = userInfo["alarm"] as? String else {
        return
    }
    
    let alertController = UIAlertController(title: "Ошибка!", message: message)
    present(alertController, animated: true, completion: nil)
  }
  
  func showNewCard() {
    guard let cards = TaleAPI.shared.playerInformationManager.cardsInfo?.cards else { return }
    let newCard = Set(cards).subtracting(Set(currentCards))

    if newCard.count == 1,
       let cardName = newCard.first?.name {
      
      let alertController = UIAlertController(title: "Получена новая карта.", message: cardName)
      present(alertController, animated: true, completion: nil)
    }
    
    saveCurrentCard()
  }
  
  @IBAction func getCardButtonTapped(_ sender: UIButton) {
    hiddenGetCard = true
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
    hiddenGetCard = true
    activityIndicator.startAnimating()
    
    let uidCards = selectedCard.map({ $0.key })
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

  deinit {
    TaleAPI.shared.removeObserver(self, forKeyPath: keyPathCardsInfo)
  }
  
}

extension CardViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return TaleAPI.shared.playerInformationManager.cardsInfo?.cards.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: helpCell) as! HelpBarrierTableViewCell
      
      if let cards = TaleAPI.shared.playerInformationManager.cardsInfo {
        cell.configured()
        cell.configuredHelpBarrier(with: cards)
        cell.configuredGetCardButton(isHidden: hiddenGetCard)
        cell.configuredMergeCardButton(isHidden: hiddenMergeCard)
      }

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: cardCell) as! CardTableViewCell
      
      let cards = TaleAPI.shared.playerInformationManager.cardsInfo?.cards
      
      if let card            = cards?[indexPath.row],
         let cardDescription = Types.shared.card?.type[card.type] as? [String] {
        cell.configuredCard(info: card, description: cardDescription[1])
      }

      return cell
    default:
      fatalError("Wrong number of sections")
    }
  }

}

extension CardViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let card = TaleAPI.shared.playerInformationManager.cardsInfo?.cards[indexPath.row],
          let uid  = TaleAPI.shared.playerInformationManager.cardsInfo?.cards[indexPath.row].uidRepresentation() else {
        return
    }

    selectedCard.updateValue(card, forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let uid = TaleAPI.shared.playerInformationManager.cardsInfo?.cards[indexPath.row].uidRepresentation() else {
        return
    }
    selectedCard.removeValue(forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let useCard = UITableViewRowAction(style: .destructive, title: "Использовать") { (_, indexPath) in
      if let uidCard = TaleAPI.shared.playerInformationManager.cardsInfo?.cards[indexPath.row].uidRepresentation() {
        
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
