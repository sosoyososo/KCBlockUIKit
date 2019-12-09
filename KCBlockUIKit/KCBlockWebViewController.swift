//
//  KCWebController.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/12/8.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

open class KCBlockWebViewController : UIViewController, UIWebViewDelegate {
    open var url : URL!
    open var webView = UIWebView()
    
    open var loadViewAction : (UIViewController)->() = { _ in
    }
    
    open var shouldStart : (UIWebView)->() = { _ in
        return true
    }
    open var didFinish : (UIWebView)->() = { _ in
    }
    open var didFail : (UIWebView, Error)->() = { _,_  in
    }
    
    deinit {
        webView.delegate = nil
    }
    
    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        webView.delegate = self
    }
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(white: 241.0/255, alpha: 1)        
        loadViewAction(self)
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        webView.loadRequest(URLRequest.init(url: url))
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        return shouldStart(webView)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        didFinish(webView)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        didFail(webView, error)
    }
}
