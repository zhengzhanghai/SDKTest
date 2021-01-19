//
//  WMSFSafariViewController.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/12/2.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import SafariServices

class WMSFSafariViewController: UIViewController {

    var url: URL?
    var SFVC: SFSafariViewController?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            return
        }
    
        SFVC = SFSafariViewController(url: url)
        self.addChild(SFVC!)
        self.view.addSubview(SFVC!.view)
        SFVC?.view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    
  
}
