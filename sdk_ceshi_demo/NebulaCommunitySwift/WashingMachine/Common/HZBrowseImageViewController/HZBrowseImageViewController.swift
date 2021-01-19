//
//  HZBrowseImageViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/28.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class HZBrowseImageViewController: UIViewController {
    
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    fileprivate func makeScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView?.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
