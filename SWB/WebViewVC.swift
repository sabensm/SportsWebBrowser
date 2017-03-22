//
//  WebViewVC.swift
//  SWB
//
//  Created by Sabens, Michael G. on 3/22/17.
//  Copyright © 2017 Sabens, Michael G. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    var urlToLoad: String?
    var webView = WKWebView()
    var progressView: UIProgressView!
    var allowedWebsites = supportedWebsites()

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //gets URL to load in webview
        let url = URL(string: "http://" + urlToLoad!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        //setting up the action button up top in the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //setting up the toolbar at the bottom
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        //KVO adding observer for changes to progress indicator
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        
        for website in allowedWebsites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "http://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //KVO - decide what to do when we get info
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    //decide if the link on a page is in our approved list
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url!.host {
            for website in allowedWebsites {
                if host.range(of: website) != nil {
                    decisionHandler(.allow)
                }
            }
        }
        decisionHandler(.cancel)
    }
    
    deinit {
        //KVO - Remove observer when view is deiniatalized
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

}
