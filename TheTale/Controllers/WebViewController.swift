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

  @IBOutlet weak var backButton: UIBarButtonItem!
  @IBOutlet weak var forwardButton: UIBarButtonItem!
  @IBOutlet weak var stopButton: UIBarButtonItem!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var progressView: UIProgressView!
  
  var webView: WKWebView!
  
  var myURL: URL!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setupWebView()
    setupButton()
    
    let myRequest = URLRequest(url: myURL)
    webView.load(myRequest)
  }
  
  func setupWebView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    webView.navigationDelegate = self
    
    view.insertSubview(webView, belowSubview: progressView)
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
    let width  = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
    view.addConstraints([height, width])
    
    webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
  }
  
  func setupButton() {
    backButton.isEnabled    = false
    forwardButton.isEnabled = false
    stopButton.isEnabled    = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    tabBarController?.tabBar.isHidden = false
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "loading" {
      backButton.isEnabled    = webView.canGoBack
      forwardButton.isEnabled = webView.canGoForward
    }
    
    if keyPath == "estimatedProgress" {
      stopButton.isEnabled  = webView.estimatedProgress != 1
      progressView.isHidden = webView.estimatedProgress == 1
      progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }
  }
  
  deinit {
    webView.removeObserver(self, forKeyPath: "loading")
    webView.removeObserver(self, forKeyPath: "estimatedProgress")
  }
  
  @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
    webView.goBack()
  }
  
  @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem) {
    webView.goForward()
  }
  
  @IBAction func stopButtonTapped(_ sender: UIBarButtonItem) {
    webView.stopLoading()
  }
  
  @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
    let request = URLRequest(url: webView.url!)
    webView.load(request)
  }
  
}

extension WebViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    progressView.setProgress(0.0, animated: false)
  }
  
}
