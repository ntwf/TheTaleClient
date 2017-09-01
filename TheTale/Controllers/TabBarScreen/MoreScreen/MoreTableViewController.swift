//
//  MoreTableViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .main))
    case (0, 1):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .guide))
    case (0, 2):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .forum))
    case (1, 0):
      performSegue(withIdentifier: AppConfiguration.Segue.toAbout, sender: nil)
    case (2, 0):
      logout()
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
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

  // MARK: - Work with interface
  func presentLoginScreen() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Request to API
  func logout() {
    TaleAPI.shared.logout { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }
      
      switch result {
      case .success:
        TaleAPI.shared.playerInformationAutorefresh = .stop
        TaleAPI.shared.authorisationState           = AuthorisationState()
        
        strongSelf.presentLoginScreen()
      case .failure(let error as NSError):
        debugPrint("logout \(error)")
      default: break
      }
    }
  }
}
