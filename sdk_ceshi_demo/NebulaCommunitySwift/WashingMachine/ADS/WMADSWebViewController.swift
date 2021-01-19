//
//  WMADSWebViewController.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/12/2.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class WMADSWebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.navigationDelegate = self
        return view
    }()
    
    lazy var  finishBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("完成", for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    var url: URL?
    
    init(url: URL? = nil) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addEvent()
        loadWebContent()
    }
    
    func loadWebContent() {
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}

// 添加视图相关
fileprivate extension WMADSWebViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(finishBtn)
        view.addSubview(titleLabel)
        view.addSubview(separatorLine)
        view.addSubview(webView)
        
        finishBtn.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_HEIGHT + 7)
            make.left.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(finishBtn)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(BOUNDS_WIDTH - 120)
        }
        separatorLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(finishBtn.snp.bottom).offset(7)
            make.height.equalTo(0.5)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorLine.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
}

// 事件相关
fileprivate extension WMADSWebViewController {
    
    func addEvent() {
        finishBtn.addTarget(self, action: #selector(onClickFinish), for: .touchUpInside)
    }
    
    @objc func onClickFinish() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WMADSWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (title, error) in
            guard let title = title as? String else {return}
            self.titleLabel.text = title
        }

    }
}
