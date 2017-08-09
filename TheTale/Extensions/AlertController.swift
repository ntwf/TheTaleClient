//
//  AlertController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 17/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension UIAlertController {

  convenience init(title: String, message: String, defaultActionButtonTitle: String = "Ok") {
    self.init(title: title, message: message, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
    addAction(defaultAction)
  }
  
}
