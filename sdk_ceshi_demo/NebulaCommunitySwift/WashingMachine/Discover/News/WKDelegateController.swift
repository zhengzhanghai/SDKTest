//
//  WKDelegateController.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

protocol WKDelegateControllerDelegate: NSObjectProtocol {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

class WKDelegateController: BaseViewController, WKScriptMessageHandler {
    weak var delegate: WKDelegateControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
