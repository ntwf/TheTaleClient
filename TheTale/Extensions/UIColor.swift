//
//  UIColor.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 12/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

// MARK: - Initializers
extension UIColor {
  
  /// SwifterSwift: Create UIColor from hexadecimal value with optional transparency.
  ///
  /// - Parameters:
  ///   - hex: hex Int (example: 0xDECEB5).
  ///   - transparency: optional transparency value (default is 1).
  public convenience init(hex: Int, transparency: CGFloat = 1) {
    var trans: CGFloat {
      if transparency > 1 {
        return 1
      } else if transparency < 0 {
        return 0
      } else {
        return transparency
      }
    }
    self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, transparency: trans)
  }
  
  /// SwifterSwift: Create UIColor from RGB values with optional transparency.
  ///
  /// - Parameters:
  ///   - red: red component.
  ///   - green: green component.
  ///   - blue: blue component.
  ///   - transparency: optional transparency value (default is 1).
  public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    var trans: CGFloat {
      if transparency > 1 {
        return 1
      } else if transparency < 0 {
        return 0
      } else {
        return transparency
      }
    }
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
  }
  
  /// SwifterSwift: Create UIColor from hexadecimal string with optional transparency (if applicable).
  ///
  /// - Parameters:
  ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
  ///   - transparency: optional transparency value (default is 1).
  public convenience init?(hexString: String, transparency: CGFloat = 1) {
    var string = ""
    if hexString.lowercased().hasPrefix("0x") {
      string =  hexString.replacingOccurrences(of: "0x", with: "")
    } else if hexString.hasPrefix("#") {
      string = hexString.replacingOccurrences(of: "#", with: "")
    } else {
      string = hexString
    }
    
    if string.count == 3 { // convert hex to 6 digit format if in short format
      var str = ""
      string.forEach({ str.append(String(repeatElement($0, count: 2))) })
      string = str
    }
    
    guard let hexValue = Int(string, radix: 16) else {
      return nil
    }
    
    self.init(hex: Int(hexValue), transparency: transparency)
  }
  
}
