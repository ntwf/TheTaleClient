//
//  WebViewController.swift
//  the-tale
//
//  Created by Mikhail Vospennikov on 19/07/2017.
//  Copyright © 2017 Mikhail Vospennikov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
  // MARK: - Internal constants
  enum Constants {
    static let keyPathLoading           = "loading"
    static let ketPathEstimatedProgress = "estimatedProgress"
  }
  
  // MARK: - Internal variables
  var webView: WKWebView!
  var authPath: String!
  
  // MARK: - Outlets
  @IBOutlet weak var progressView: UIProgressView!

  // MARK: - Load controller
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setupWebView()
  }
  
  func setupWebView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    webView.navigationDelegate = self
    
    view.insertSubview(webView, belowSubview: progressView)

    webView.translatesAutoresizingMaskIntoConstraints = false
    
    let top      = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal,
                                      toItem: view, attribute: .top,
                                      multiplier: 1, constant: 0)

    let bottom   = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal,
                                      toItem: view, attribute: .bottom,
                                      multiplier: 1, constant: 0)

    let leading  = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal,
                                      toItem: view, attribute: .leading,
                                      multiplier: 1, constant: 0)

    let trailing = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal,
                                      toItem: view, attribute: .trailing,
                                      multiplier: 1, constant: 0)
    
    view.addConstraints([top, bottom, leading, trailing])
  }
  
  // MARK: - View lifecycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addNotification()
    
    requestToWeb()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    removeNotification()
  }
  
  // MARK: - Notification
  func addNotification() {
    webView.addObserver(self, forKeyPath: Constants.ketPathEstimatedProgress, options: .new, context: nil)
  }
  
  func removeNotification() {
    webView.removeObserver(self, forKeyPath: Constants.ketPathEstimatedProgress)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == Constants.ketPathEstimatedProgress {
      progressView.isHidden = webView.estimatedProgress == 1
      progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }
  }

  // MARK: - Request to web
  func requestToWeb() {
    let request = TaleAPI.shared.networkManager.createRequest(fromString: authPath, method: .get)
    webView.load(request!)
  }
  
  // MARK: - Outlets action
  @IBAction func doneButtonTapped(_ sender: Any) {
    webView.stopLoading()
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    progressView.setProgress(0.0, animated: false)
  }
}
