//
//  StarCoinsRechargeProtocolViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/8.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class StarCoinsRechargeProtocolViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "充值协议"
        
        self.loadRechargeProtocolFile()
    }
    
    fileprivate func loadRechargeProtocolFile() {
        
        guard let filePath = Bundle.main.path(forResource: "recharge_protocol", ofType: "docx") else { return }
        let fileURL = URL(fileURLWithPath: filePath)
        
        let webView = WKWebView()
        let urlRequest = URLRequest(url: fileURL)
        webView.load(urlRequest)
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }

}
