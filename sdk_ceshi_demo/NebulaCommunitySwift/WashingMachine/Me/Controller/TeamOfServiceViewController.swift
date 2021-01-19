//
//  TeamOfServiceViewController.swift
//  WashingMachine
//
//  Created by Harious on 2017/12/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class TeamOfServiceViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "服务条款"
        
        self.loadSeviceTerms()
    }

    fileprivate func loadSeviceTerms() {
        self.showWaitingView(self.view)
        NetworkEngine.get(API_GET_SEVICE_TERMS, parameters: nil) { (result) in
            self.hiddenWaitingView()
            ZZPrint(result.dataObj)
            if result.isSuccess {
                guard let text = result.sourceDict?["data"] as? String else {
                    return
                }
                self.makeUI(text)
            } else {
                showError(result.message, superView: self.view)
            }
        }
    }
    
    fileprivate func makeUI(_ text: String) {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        let paragrphStyle = NSMutableParagraphStyle()
        paragrphStyle.lineSpacing = 10
        let attmuStr = NSMutableAttributedString(string: text,
                                                 attributes: [NSAttributedString.Key.paragraphStyle: paragrphStyle,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        textView.attributedText = attmuStr
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
