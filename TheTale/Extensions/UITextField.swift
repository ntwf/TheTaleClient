//
//  UITextField.swift
//  TheTaleClient
//
//  Created by Mikhail Vospennikov on 29/08/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

extension UITextField {
  var isEmail: Bool {
    // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                       options: String.CompareOptions.regularExpression,
                       range: nil, locale: nil) != nil
  }
  
  var isEmpty: Bool {
    return text?.isEmpty == true
  }
  
  func clear() {
    text = ""
    attributedText = NSAttributedString(string: "")
  }
}
