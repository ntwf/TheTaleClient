//
//  StartViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

protocol SegueHandlerDelegate: class {
  func segueHandler(identifier: String)
}

protocol AuthPathDelegate: class {
  var authPath: String? { get set }
}

final class StartViewController: UIViewController, AuthPathDelegate {
  // MARK: - AuthPathDelegate
  var authPath: String?
  
  // MARK: - Outlets
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var loginContainer: UIView!
  @IBOutlet weak var registrationContainer: UIView!
  
  @IBOutlet var startingViewsCollection: [UIView]!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()

    startingViewsCollection.forEach { $0.isHidden = true }
    
    setupGesture()
    addNotification()
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
  
  override var shouldAutorotate: Bool {
    return false
  }

  func setupGesture() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    segmentedControl.selectedSegmentIndex = 0
    checkAuthorisation()
  }
  
  // MARK: - Notification
  func addNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(catchNotification(sender:)),
                                           name: .TaleAPINonblockingOperationStatusChanged,
                                           object: nil)
  }
  
  func catchNotification(sender: Notification) {
    guard let userInfo = sender.userInfo,
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
      case .success:
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toJournal, sender: self)
      case .failure(let error as NSError):
        debugPrint("checkAuthorisation", error)
        
        strongSelf.segmentedControl.isHidden = false
        strongSelf.loginContainer.isHidden = true
        strongSelf.registrationContainer.isHidden = false
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
    } else if segue.identifier == AppConfiguration.Segue.toLogin,
              let loginViewController = segue.destination as? LoginViewController {
      loginViewController.segueHandlerDelegate = self
      loginViewController.authPathDelegate     = self
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

// MARK: - SegueHandlerDelegate
extension StartViewController: SegueHandlerDelegate {

  func segueHandler(identifier: String) {
    performSegue(withIdentifier: identifier, sender: nil)
  }

}
