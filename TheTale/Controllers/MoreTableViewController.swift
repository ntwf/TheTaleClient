//
//  MoreTableViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
  
  enum Constants {
    static let segueAbout = "toAboutSegue"
    
    static let storyboardLoginID = "loginScreen"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      UIApplication.shared.open(URL(string: TaleAPI.shared.baseURL)!)
    case (0, 1):
      UIApplication.shared.open(URL(string: TaleAPI.shared.gameGuideURL)!)
    case (0, 2):
      UIApplication.shared.open(URL(string: TaleAPI.shared.gameForumURL)!)
    case (1, 0):
      performSegue(withIdentifier: Constants.segueAbout, sender: nil)
    case (2, 0):
      logout()
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
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
  
  func presentLoginScreen() {
    let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.storyboardLoginID)
    present(loginViewController, animated: true, completion: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isNavigationBarHidden = false
  }
}
