//
//  LoginViewController.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 31/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  // MARK: - Internal constants
  enum Constatns {
    static let borderColorTextFieldOK    = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
    static let borderColorTextFieldError = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
  }
  
  // MARK: - Internal variables
  var authPath: String?
  var isCheckedAuthorisation: Bool = false
  
  // MARK: - Outlets
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()

    configured(loginButton: loginButton)
    setupTextField()
  }
  
  func setupTextField() {
    loginTextField.delegate    = self
    passwordTextField.delegate = self
    
    loginTextField.addTarget(self, action: #selector(checkLogin(_:)), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(checkPassword(_:)), for: .editingChanged)
  }
  
  func configured(textField: UITextField, border color: UIColor) {
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 5.0
    textField.layer.borderColor = color.cgColor
    textField.layer.borderWidth = 0.5
  }
  
  func configured(loginButton: UIButton) {
    if loginTextField.isEmail && !passwordTextField.isEmpty {
      loginButton.isEnabled = true
      loginButton.alpha = 1
    } else {
      loginButton.isEnabled = false
      loginButton.alpha = 0.5
    }
  }
  
  // MARK: - Check text field
  func checkLogin(_ textField: UITextField) {
    var color = Constatns.borderColorTextFieldOK
    
    if !loginTextField.isEmail {
      color = Constatns.borderColorTextFieldError
    }
    
    configured(loginButton: loginButton)
    configured(textField: loginTextField, border: color)
  }
  
  func checkPassword(_ textField: UITextField) {
    var color = Constatns.borderColorTextFieldOK
    
    if passwordTextField.isEmpty {
      color = Constatns.borderColorTextFieldError
    }
    
    configured(loginButton: loginButton)
    configured(textField: passwordTextField, border: color)
  }
  
  // MARK: - View lifecycle
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    loginTextField.clear()
    passwordTextField.clear()
  }
  
  // MARK: - Request to API
  func tryLogin(email: String, password: String) {
    TaleAPI.shared.login(email: email, password: password) { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }
      
      switch result {
      case .success:
        strongSelf.isCheckedAuthorisation = false
        //        strongSelf.loginView.isHidden = true
        
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toJournal, sender: self)
        
      case .failure(let error as NSError):
        strongSelf.isCheckedAuthorisation = false
        //        strongSelf.loginView.isHidden = false
        
        let alert = UIAlertController(title: "Ошибка авторизации.", message: "Неправильный логин или пароль.")
        strongSelf.present(alert, animated: true, completion: nil)
        
        strongSelf.passwordTextField.clear()
        
        debugPrint("login \(error)")
        
      default: break
      }
    }
  }
  
  // MARK: - Outlets action
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    guard let email    = loginTextField.text,
      let password = passwordTextField.text else {
        return
    }
    
    tryLogin(email: email, password: password)
  }
  
  @IBAction func loginOnSiteButtonTapped(_ sender: UIButton) {
    isCheckedAuthorisation = false
    
    TaleAPI.shared.requestURLPathTologinIntoSite { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }
      
      switch result {
      case .success(let data):
        //        strongSelf.loginView.isHidden = true
        strongSelf.authPath = data.urlPath
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toWeb, sender: nil)
      case .failure(let error as NSError):
        debugPrint("loginOnTheSite \(error)")
      default: break
      }
    }
  }

}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
}
