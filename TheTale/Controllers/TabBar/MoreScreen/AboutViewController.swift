//
//  AboutViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 19/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var textView: UITextView!
  
  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextView()
  }

  func setupTextView() {
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.textView.dataDetectorTypes = [.link]
      strongSelf.textView.isSelectable      = true
    }
  }
  
  // MARK: - Work with interface
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    // Fix text view bug. See http://www.openradar.me/24435091
    textView.isScrollEnabled = false
    textView.isScrollEnabled = true
  }
}
