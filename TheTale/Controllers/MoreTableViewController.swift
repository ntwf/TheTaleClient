//
//  MoreTableViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
  
  let aboutSegue      = "toAboutSegue"
  let webSegue        = "toWebViewSegue"
  let loginStoryboard = "loginScreen"
  
  let gameURL      = "http://the-tale.org"
  let gameGuideURL = "http://the-tale.org/guide/game"
  let gameForumURL = "http://the-tale.org/forum"
  
  // Apple did not approve of using the built-in browser. Now opens a Safari.
  // var url = URL(string: "")
  
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
      UIApplication.shared.open(URL(string: gameURL)!)
      // url = URL(string: gameURL)
      // performSegue(withIdentifier: webSegue, sender: nil)
    case (0, 1):
      UIApplication.shared.open(URL(string: gameGuideURL)!)
      // url = URL(string: gameGuideURL)
      // performSegue(withIdentifier: webSegue, sender: nil)
    case (0, 2):
      UIApplication.shared.open(URL(string: gameForumURL)!)
      // url = URL(string: gameForumURL)
      // performSegue(withIdentifier: webSegue, sender: nil)
    case (1, 0):
      performSegue(withIdentifier: aboutSegue, sender: nil)
    case (2, 0):
      logout()
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func logout() {
    TaleAPI.shared.logout { [weak self] (result) in
      switch result {
      case .success:
        TaleAPI.shared.playerInformationAutorefresh = .stop
        TaleAPI.shared.authorisationState = AuthorisationState()
        
        self?.presentLoginScreen()
      case .failure(let error as NSError):
        debugPrint("logout \(error)")
      default: break
      }
    }
  }
  
  func presentLoginScreen() {
    let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: loginStoryboard)
    present(loginViewController, animated: true, completion: nil)
  }
  
  // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //   if segue.identifier == "toWebViewSegue" {
  //     guard let destinationViewController = segue.destination as? WebViewController else { return }
  //     destinationViewController.myURL = url
  //   }
  // }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isNavigationBarHidden = false
  }
}
