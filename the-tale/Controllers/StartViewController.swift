//
//  StartViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let journalSegue = "toJournalSegue"
  let loginSegue   = "toLoginSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator.startAnimating()
    
    NotificationCenter.default.addObserver(self, selector: #selector(checkAuthorisation), name: NSNotification.Name("authorisationState"), object: nil)
    
    TaleAPI.shared.fetchAuthorisationState()
  }
  
  func checkAuthorisation() {
    activityIndicator.stopAnimating()

    let account = TaleAPI.shared.authorisationState?.accountID
    if account != nil {
      self.performSegue(withIdentifier: journalSegue, sender: self)
    } else {
      self.performSegue(withIdentifier: loginSegue, sender: self)
    }
  }
  
}
