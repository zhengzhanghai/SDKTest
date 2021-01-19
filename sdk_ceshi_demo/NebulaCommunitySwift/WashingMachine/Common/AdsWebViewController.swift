//
//  AdsWebViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/19.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class AdsWebViewController: BaseViewController {
    
    var titleStr: String = ""
    var urlStr: String = ""
    
    /// 旧进度条
    var oldProgress: Float = 0
    lazy fileprivate var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = UIColor.orange      // 进度条颜色
        progressView.trackTintColor = UIColor.white // 进度条背景色
        return progressView
    }()
    lazy fileprivate var webView: WKWebView = {
        return WKWebView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = titleStr
        
        self.loadWebView()
    }

    fileprivate func loadWebView() {
        
        guard let url = URL(string: urlStr) else { return }
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(URLRequest(url: url))
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            
            let webPorgress = Float(self.webView.estimatedProgress)
            
            if webPorgress <= oldProgress {
                return
            } else {
                oldProgress = webPorgress
            }
            
            if webPorgress > 0 && webPorgress < 1 {
                progressView.snp.updateConstraints({ (make) in
                    make.height.equalTo(2)
                })
                progressView.setProgress(webPorgress, animated: true)
            } else {
                
                if webPorgress >= 1 {
                    UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseOut, animations: {
                        self.progressView.setProgress(1, animated: false)
                    }, completion: { (finish) in
                        self.progressView.setProgress(0.0, animated: false)
                        self.progressView.snp.updateConstraints({ (make) in
                            make.height.equalTo(0)
                        })
                    })
                } else {
                    self.progressView.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                }
                
                oldProgress = 0
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension AdsWebViewController: WKUIDelegate, WKNavigationDelegate {
    
}
