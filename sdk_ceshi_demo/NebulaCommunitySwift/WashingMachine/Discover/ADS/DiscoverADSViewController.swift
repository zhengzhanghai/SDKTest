//
//  DiscoverADSViewController.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/6.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class DiscoverADSViewController: BaseViewController {
    
    lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.navigationDelegate = self
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "爱淘2020"
        return label
    }()
    
    lazy var backBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回", for: .normal)
        return button
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ADSManager.reportDiscoverADSAfterShowed()
    }
    
    func loadWebContent() {
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

}

// 添加视图相关
fileprivate extension DiscoverADSViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(separatorLine)
        view.addSubview(webView)
        view.addSubview(backBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_HEIGHT + 7)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(BOUNDS_WIDTH - 120)
            make.height.equalTo(30)
        }
        separatorLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.height.equalTo(0.5)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorLine.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
    }
}

//MARK: 事件相关
extension DiscoverADSViewController {
    func addEvent() {
        backBtn.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
    }
    
    @objc func onClickBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension DiscoverADSViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.title") { (title, error) in
//            guard let title = title as? String else {return}
//            self.titleLabel.text = title
//        }

    }
}
