//
//  RegistrationViewController.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 31/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Outlets action
  @IBAction func goToSiteButtonTapped(_ sender: UIButton) {
    UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .main))
  }
  
  @IBAction func registrationButtonTapped(_ sender: UIButton) {
    TaleAPI.shared.fastRegistration { (result) in
      switch result {
      case .success(let data):
        TaleAPI.shared.checkStatusOperation(operation: data)
      case .failure(let error as NSError):
        debugPrint("fastRegistration \(error)")
      default: break
      }
    }
  }
  
}
