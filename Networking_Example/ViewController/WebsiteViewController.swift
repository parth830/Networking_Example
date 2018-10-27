//
//  WebsiteViewController.swift
//  Networking_Example
//
//  Created by Ayaan Ruhi on 10/25/18.
//  Copyright © 2018 parth. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var website = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Website"
        print(website)
        loadWebView()
        addKVObserver()
    }

    func loadWebView() {
        let urlString = "https://\(website)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // MARK: Add key value observer when webview is loading
    func addKVObserver() {
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
//Could not signal service com.apple.WebKit.Networking: 113: Could not find specified service
