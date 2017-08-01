//
//  LoginViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 21/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let journalSegue = "toJournalSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginTextField.delegate = self
    passwordTextField.delegate = self
    
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
     
    activityIndicator.stopAnimating()
    
    NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: NSNotification.Name("loginState"), object: nil)
  }
  
  func checkLogin() {
    activityIndicator.stopAnimating()
    
    let accountID = TaleAPI.shared.loginState?.accountID
    
    if accountID != nil {
      performSegue(withIdentifier: journalSegue, sender: self)
    } else {
      let alert = UIAlertController(title: "Ошибка авторизации.", message: "Неправильный логин или пароль.")
      present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    activityIndicator.startAnimating()
    
    guard let email = loginTextField.text, email != "",
          let password = passwordTextField.text, password != "" else {
        let alert = UIAlertController(title: "Ошибка авторизации.", message: "Поле логина или пароля пустое.")
        present(alert, animated: true, completion: nil)
        
        activityIndicator.stopAnimating()
        return
    }
  
    TaleAPI.shared.login(email: email, password: password)
  }
  
  @IBAction func goToSiteButtonTapped(_ sender: UIButton) {
    UIApplication.shared.open(URL(string: "http://the-tale.org/")!)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
}
