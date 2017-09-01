//
//  StartViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
  // MARK: - Internal variables
  var authPath: String?
  
  // MARK: - Outlets
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var loginContainer: UIView!
  @IBOutlet weak var registrationContainer: UIView!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginContainer.isHidden = true
    registrationContainer.isHidden = false
    
    addNotification()
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
  
  override var shouldAutorotate: Bool {
    return false
  }

  // MARK: - Notification
  func addNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(catchNotification(notification:)), name: .TaleAPINonblockingOperationStatusChanged, object: nil)
  }
  
  func catchNotification(notification: Notification) {
    guard let userInfo = notification.userInfo,
      let status   = userInfo[TaleAPI.UserInfoKey.nonblockingOperationStatus] as? TaleAPI.StatusOperation else {
        return
    }
    
    switch status {
    case .ok:
      checkAuthorisation()
    case .error:
      print("error")
    default: break
    }
  }
  
  func checkAuthorisation() {
    TaleAPI.shared.getAuthorisationState { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }
      
      switch result {
      case .success(let data):
        TaleAPI.shared.authorisationState = data
        
        // strongSelf.isCheckedAuthorisation = false
        // strongSelf.loginView.isHidden = true
        
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toJournal, sender: self)
      case .failure(let error as NSError):
        debugPrint("checkAuthorisation", error)
        
        // strongSelf.isCheckedAuthorisation = true
        // strongSelf.loginView.isHidden = false
      default: break
      }
    }
  }
  
  // MARK: - Prepare segue data
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == AppConfiguration.Segue.toWeb {
      if let navigationViewController = segue.destination as? UINavigationController,
         let webViewController        = navigationViewController.topViewController as? WebViewController,
        let authPath = authPath {
        webViewController.authPath = authPath
      }
    }
  }

  // MARK: - Outlets action
  @IBAction func showComponents(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      loginContainer.isHidden = true
      registrationContainer.isHidden = false
    } else {
      loginContainer.isHidden = false
      registrationContainer.isHidden = true
    }
  }

}
