//
//  LoginRegisterNavigationController.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/15.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class LoginRegisterNavigationController: UINavigationController {
    
    var loginViewController: LoginViewController
    
    class func create() -> Self {
        return LoginRegisterNavigationController(rootViewController: LoginViewController()) as! Self
    }
    
    override init(rootViewController: UIViewController) {
        self.loginViewController = rootViewController as! LoginViewController
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隐藏导航栏
        navigationBar.isHidden = true
    }
    

    

}
