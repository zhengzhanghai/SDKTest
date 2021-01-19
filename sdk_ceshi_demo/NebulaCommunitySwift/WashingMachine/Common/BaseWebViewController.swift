//
//  BaseWebViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/11.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {
    
    var urlString: String?
    
    fileprivate var firstLoadUrlStr: String?
    fileprivate var progressBar: UIView?
    fileprivate var progressAnimated: Bool!
    fileprivate var finishLoad: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressAnimated = false
        finishLoad = false
        makeWebView()
    }
    
    private func makeWebView() {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: contentHeightNoTop))
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        progressBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 2))    
        progressBar?.backgroundColor = UIColor.orange
        webView.addSubview(progressBar ?? UIView())
        
        if let urlSt = urlString {
            if let url = URL(string: urlSt) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    fileprivate func progressBarStartLoad() {
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBar?.hz_width = BOUNDS_WIDTH*0.6
        }) { (_) in
            if !self.finishLoad {
                UIView.animate(withDuration: 0.5, animations: {
                    self.progressBar?.hz_width = BOUNDS_WIDTH*0.8
                }, completion: { (_) in
                    self.progressAnimated = true
                    if self.finishLoad {
                        self.progressBarFinishLoad()
                    }
                })
            } else {
                self.progressBarFinishLoad()
            }
        }
    }
    
    fileprivate func progressBarFinishLoad() {
        UIView.animate(withDuration: 0.8, animations: {
            self.progressBar?.hz_width = BOUNDS_WIDTH
        }) { (_) in
            self.progressBar?.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZZPrint(1)
        if firstLoadUrlStr == nil {
            ZZPrint(webView.url?.absoluteURL)
            firstLoadUrlStr = webView.url?.absoluteString
            progressBarStartLoad()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = webView.title
        ZZPrint(2)
        if firstLoadUrlStr == webView.url?.absoluteString {
            finishLoad = true
            ZZPrint(webView.url?.absoluteURL)
            if progressAnimated {
                progressBarFinishLoad()
            }
        }
    }
}
