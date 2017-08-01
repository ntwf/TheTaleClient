//
//  TabBarViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 31/05/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
  @IBInspectable var defaultIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    selectedIndex = defaultIndex
  }
}
