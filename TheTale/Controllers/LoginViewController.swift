//
//  LoginViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  enum Constants {
    static let segueJournal = "toJournalSegue"
  }
  
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginTextField.delegate    = self
    passwordTextField.delegate = self
    
    gestureSetup()
    
    activityIndicator.stopAnimating()
  }
  
  func gestureSetup() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  func checkLogin(email: String, password: String) {
    TaleAPI.shared.login(email: email, password: password) { [weak self] (result) in
      switch result {
        
      case .success:
        self?.activityIndicator.stopAnimating()
        
        self?.performSegue(withIdentifier: Constants.segueJournal, sender: self)
      
      case .failure(let error as NSError):
        self?.activityIndicator.stopAnimating()
        
        debugPrint("login \(error)")
      
        let alert = UIAlertController(title: "Ошибка авторизации.", message: "Неправильный логин или пароль.")
        self?.present(alert, animated: true, completion: nil)
      
      default: break
      }
    }
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    activityIndicator.startAnimating()
    
    guard let email    = loginTextField.text, email != "",
          let password = passwordTextField.text, password != "" else {
        let alert = UIAlertController(title: "Ошибка авторизации.", message: "Поле логина или пароля пустое.")
        present(alert, animated: true, completion: nil)
        
        activityIndicator.stopAnimating()
        return
    }
    
    checkLogin(email: email, password: password)
  }
  
  @IBAction func goToSiteButtonTapped(_ sender: UIButton) {
    if let baseURL = URL(string: TaleAPI.shared.baseURL) {
      UIApplication.shared.open(baseURL)
    }
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
  
}
