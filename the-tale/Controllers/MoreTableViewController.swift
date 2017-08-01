//
//  MoreTableViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
  
  let aboutSegue = "toAboutSegue"
  let webSegue   = "toWebViewSegue"
  
  var url = URL(string: "")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isNavigationBarHidden = false
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      url = URL(string: "http://the-tale.org")
      performSegue(withIdentifier: webSegue, sender: nil)
    case (0, 1):
      url = URL(string: "http://the-tale.org/guide/game")
      performSegue(withIdentifier: webSegue, sender: nil)
    case (0, 2):
      url = URL(string: "http://the-tale.org/forum")
      performSegue(withIdentifier: webSegue, sender: nil)
    case (1, 0):
      performSegue(withIdentifier: aboutSegue, sender: nil)
    case (2, 0):
      logout()
    default:
      break
    }
  }
  
  func logout() {
    TaleAPI.shared.stopRefreshGameInformation()
    TaleAPI.shared.logout()
    
    presentLoginScreen()
  }
  
  func presentLoginScreen() {
    let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScreen")
    present(loginViewController, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toWebViewSegue" {
      guard let destinationViewController = segue.destination as? WebViewController else { return }
      destinationViewController.myURL = url
    }
  }
  
}
