//
//  UserAgreeViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import WebKit

class UserAgreeViewController: BaseViewController {

    fileprivate var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "使用协议"
        makeTextView()
        userAgreeMent()
    }

    func makeTextView() {
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT))
        self.view.addSubview(textView)
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
    }
    
    fileprivate func userAgreeMent() {
        let url = SERVICE_BASE_ADDRESS + API_GET_APP_REGISTER_AGREEMENT
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    let data = dict["data"] as? String ?? ""
                    self.textView.text = data
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
