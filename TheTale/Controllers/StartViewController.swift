//
//  StartViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  enum Constants {
    static let segueJournal = "toJournalSegue"
    static let segueLogin   = "toLoginSegue"
  }
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.startAnimating()
    checkAuthorisation()
  }
  
  func checkAuthorisation() {

    TaleAPI.shared.getAuthorisationState { [weak self] (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.authorisationState = data
        self?.performSegue(withIdentifier: Constants.segueJournal, sender: self)
      case .failure(let error as NSError):
        debugPrint("checkAuthorisation", error)
        self?.performSegue(withIdentifier: Constants.segueLogin, sender: self)
      default: break
      }
    }
    
    activityIndicator.stopAnimating()
    
  }
  
}
