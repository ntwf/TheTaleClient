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
  
  var hiddenGetCard   = true
  var hiddenMergeCard = true

  var selectedCard = [String: CardInfo]()
  var currentCards = [CardInfo]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.stopAnimating()
    
    setupNotification()
    setupTableView()
    
    checkAvalibleGetCardButton()
  }
  
  func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateCard"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: NSNotification.Name("operationAlarm"), object: nil)
  }
  
  func setupTableView() {
    refreshControl.addTarget(self, action: #selector(CardViewController.refreshData(sender:)), for: .valueChanged)

    tableView.refreshControl     = refreshControl
    tableView.estimatedRowHeight = 46
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.tableFooterView    = UIView()
  }
  
  func refreshData(sender: UIRefreshControl) {
    TaleAPI.shared.refreshGameInformation()
    refreshControl.endRefreshing()
  }
  
  func updateUI() {
    activityIndicator.stopAnimating()

    showAlertNewCard()
    
    selectedCard.removeAll()

    hiddenMergeCard = true
    checkAvalibleGetCardButton()
    
    tableView.reloadData()
  }
  
  func checkAvalibleGetCardButton() {
    if let helpCount = TaleAPI.shared.cards?.helpCount,
       let helpBarrier = TaleAPI.shared.cards?.helpBarrier,
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
    guard let cards = TaleAPI.shared.cards?.info else { return }
    currentCards = cards
  }
  
  func showAlertNewCard() {
    guard let cards = TaleAPI.shared.cards?.info else { return }
    let newCard = Set(cards).subtracting(Set(currentCards))

    if newCard.count == 1,
       let cardName = newCard.first?.name {
      let alert = UIAlertController(title: "Получена новая карта.", message: cardName.capitalizeFirstLetter)
      let rootViewController = tabBarController?.selectedViewController
      rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    saveCurrentCard()
  }
  
  func showAlert() {
    let alert = UIAlertController(title: "Ошибка!", message: TaleAPI.shared.alarm)
    let rootViewController = tabBarController?.selectedViewController
    rootViewController?.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func getCardButtonTapped(_ sender: UIButton) {
    hiddenGetCard = true
    activityIndicator.startAnimating()
    TaleAPI.shared.tryGetCard()
    updateUI()
  }
  
  @IBAction func mergeCardButtonTapped(_ sender: UIButton) {
    hiddenGetCard = true
    activityIndicator.startAnimating()
    debugPrint(selectedCard)
    TaleAPI.shared.tryMergeCard(selectedCard)
    updateUI()
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
      return TaleAPI.shared.cards?.info.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: helpCell) as! HelpBarrierTableViewCell
      
      if let cards = TaleAPI.shared.cards {
        cell.configured()
        cell.configuredHelpBarrier(with: cards)
        cell.configuredGetCardButton(isHidden: hiddenGetCard)
        cell.configuredMergeCardButton(isHidden: hiddenMergeCard)
      }

      return cell
    case 1:
      // swiftlint:disable:next force_cast
      let cell = tableView.dequeueReusableCell(withIdentifier: cardCell) as! CardTableViewCell
      
      let cards = TaleAPI.shared.cards?.info
      
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
    guard let card = TaleAPI.shared.cards?.info[indexPath.row],
          let uid  = TaleAPI.shared.cards?.info[indexPath.row].uidRepresentation() else {
        return
    }
    debugPrint(card)
    selectedCard.updateValue(card, forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let uid = TaleAPI.shared.cards?.info[indexPath.row].uidRepresentation() else {
        return
    }
    selectedCard.removeValue(forKey: uid)
    checkAvalibleMergeCardButton()
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let useCard = UITableViewRowAction(style: .destructive, title: "Использовать") { (_, indexPath) in
      if let uidCard = TaleAPI.shared.cards?.info[indexPath.row].uidRepresentation() {
        TaleAPI.shared.tryUseCard(uidCard)
      }
    }
    
    useCard.backgroundColor = #colorLiteral(red: 0.4069784284, green: 0.6598457694, blue: 0.7288877368, alpha: 1)
    
    return [useCard]
  }
  
}
