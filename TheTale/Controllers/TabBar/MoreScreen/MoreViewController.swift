//
//  MoreTableViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 02/06/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
  // MARK: - Internal constants
  enum Constatns {
    static let cellMenu = "Cell"
  }
  
  // MARK: - Internal variables
  var okActionButton: UIAlertAction?
  var loginTextField: UITextField?
  var emailTextField: UITextField?
  var passwordTextField: UITextField?
  
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isNavigationBarHidden = false
  }

  // MARK: - Work with interface
  func presentLoginScreen() {
    self.dismiss(animated: true, completion: nil)
  }

  func checkRegistration(_ sender: UITextField) {
    guard let loginTextField    = loginTextField,
          let emailTextField    = emailTextField,
          let passwordTextField = passwordTextField,
          let okActionButton    = okActionButton else {
      return
    }
    
    if emailTextField.isEmail && !passwordTextField.isEmpty && !loginTextField.isEmpty {
      okActionButton.isEnabled = true
    }
  }
  
  func presentAlertСompletionRegistration() {
    let alertController = UIAlertController(title: "Завершение регистрации",
                                            message: "Вы должны подтвердить указанный email. Для этого перейдите по ссылке в отправленном на него письме. Если письмо не придёт в течение часа, пожалуйста, обратитесь в службу поддержки: support@the-tale.org. Следующий вход в приложение будет осуществляться по паролю или авторизации через сайт.",
                                            defaultActionButtonTitle: "Ok")
    
    present(alertController, animated: true, completion: nil)
  }
  
  func presentAlertConfirmRegisteration() {
    // Alert controller
    let alertController = UIAlertController(title: "Регистрация",
                                            message: "До завершения регистрации Ваш аккаунт имеет ограниченную функциональность. Для завершения регистрации укажите имя, email и пароль в форме ниже.",
                                            preferredStyle: .alert)
    
    // Alert action
    let okAction = UIAlertAction(title: "Зарегестрироваться", style: .default, handler: { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.confirmRegistration()
    })
    okAction.isEnabled = false
    self.okActionButton = okAction
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    // Alert text field
    alertController.addTextField(configurationHandler: { [weak self] (textField) in
      guard let strongSelf = self else {
        return
      }
      
      textField.placeholder = "Логин"
      
      strongSelf.loginTextField = textField
      textField.addTarget(self, action: #selector(strongSelf.checkRegistration(_:)), for: .editingChanged)
    })
    
    alertController.addTextField(configurationHandler: { [weak self] (textField: UITextField) in
      guard let strongSelf = self else {
        return
      }
      
      textField.placeholder = "Email"
      textField.keyboardType = .emailAddress
      
      strongSelf.emailTextField = textField
      textField.addTarget(self, action: #selector(strongSelf.checkRegistration(_:)), for: .editingChanged)
    })
    
    alertController.addTextField(configurationHandler: { [weak self] textField in
      guard let strongSelf = self else {
        return
      }
      
      textField.placeholder = "Пароль"
      textField.isSecureTextEntry = true
      
      strongSelf.passwordTextField = textField
      textField.addTarget(self, action: #selector(strongSelf.checkRegistration(_:)), for: .editingChanged)
    })
    
    // Alert controller present
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Request to API
  func logout() {
    TaleAPI.shared.logout { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }
      
      switch result {
      case .success:
        TaleAPI.shared.playerInformationAutorefresh = .stop
        TaleAPI.shared.authorisationState           = AuthorisationState()
        
        strongSelf.presentLoginScreen()
      case .failure(let error as NSError):
        debugPrint("logout \(error)")
      default: break
      }
    }
  }
  
  func confirmRegistration() {
    guard let login    = loginTextField?.text,
          let email    = emailTextField?.text,
          let password = passwordTextField?.text else {
        return
    }

    TaleAPI.shared.confirmRegistration(nick: login, email: email, password: password) { [weak self] (result) in
      guard let strongSelf = self else {
        return
      }

      switch result {
      case .success:
        strongSelf.presentAlertConfirmRegisteration()
      case .failure(let error as NSError):
        debugPrint("confirmRegistration \(error)")
      default: break
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension MoreViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if let account = TaleAPI.shared.accountShow, account.registered == false {
        return 1
      }
      return 0
    case 1:
      return 3
    case 2:
      return 1
    case 3:
      return 1
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "Зарегестрироваться"
      return cell!
    case (1, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "Сайт игры"
      return cell!
    case (1, 1):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "Путеводитель"
      return cell!
    case (1, 2):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "Форум"
      return cell!
    case (2, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "О программе"
      return cell!
    case (3, 0):
      let cell = tableView.dequeueReusableCell(withIdentifier: Constatns.cellMenu)
      cell?.textLabel?.text = "Выход"
      return cell!
    default:
      fatalError("Wrong number of sections")
    }
  }
}

// MARK: - UITableViewDelegate
extension MoreViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
      presentAlertConfirmRegisteration()
    case (1, 0):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .main))
    case (1, 1):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .guide))
    case (1, 2):
      UIApplication.shared.open(TaleAPI.shared.networkManager.createURL(fromSite: .forum))
    case (2, 0):
      performSegue(withIdentifier: AppConfiguration.Segue.toAbout, sender: nil)
    case (3, 0):
      logout()
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}
