//
//  LoginViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
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
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()

    loginView.isHidden = true
    
    configured(loginButton: loginButton)
    
    addNotification()
    setupGesture()
    setupTextField()
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
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !isCheckedAuthorisation {
      checkAuthorisation()
    }
  }
  
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
        strongSelf.activityIndicator.startAnimating()
        strongSelf.loginView.isHidden = true
        
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toJournal, sender: self)
      
      case .failure(let error as NSError):
        strongSelf.isCheckedAuthorisation = false
        strongSelf.activityIndicator.stopAnimating()
        strongSelf.loginView.isHidden = false
        
        let alert = UIAlertController(title: "Ошибка авторизации.", message: "Неправильный логин или пароль.")
        strongSelf.present(alert, animated: true, completion: nil)
        
        strongSelf.passwordTextField.clear()
        
        debugPrint("login \(error)")
        
      default: break
      }
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
        
        strongSelf.isCheckedAuthorisation = false
        strongSelf.activityIndicator.startAnimating()
        strongSelf.loginView.isHidden = true
        
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toJournal, sender: self)
      case .failure(let error as NSError):
        debugPrint("checkAuthorisation", error)
        
        strongSelf.isCheckedAuthorisation = true
        strongSelf.activityIndicator.stopAnimating()
        strongSelf.loginView.isHidden = false
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
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    activityIndicator.startAnimating()
    
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
        strongSelf.loginView.isHidden = true
        strongSelf.activityIndicator.startAnimating()
        
        strongSelf.authPath = data.urlPath
        strongSelf.performSegue(withIdentifier: AppConfiguration.Segue.toWeb, sender: nil)
      case .failure(let error as NSError):
        debugPrint("loginOnTheSite \(error)")
      default: break
      }
    }
  }
  
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

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
}
