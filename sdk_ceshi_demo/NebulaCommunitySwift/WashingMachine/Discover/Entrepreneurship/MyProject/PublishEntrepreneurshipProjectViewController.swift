//
//  PublishEntrepreneurshipProjectViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/6.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class PublishEntrepreneurshipProjectViewController: BaseViewController {
    
    var plan: EntrepreneurshipPlan?
    
    lazy var contentView: ContentView = {
        return ContentView(controller: self)
    }()
    /// 必须写成属性，保证它的生命周期
    var viewModel: PublishViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        if !AuthSchool.isExist {
            self.loadSchoolMessage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "发布项目"
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    
        viewModel = PublishViewModel(self)
    }
    
    /// 获取认证的学校信息
    fileprivate func loadSchoolMessage() {
        MeViewModel.loadAuthenticationSchool(getUserId()) { (authSchool, message) in
            if let schoolId = authSchool?.schoolId {
                
                let schoolName = authSchool?.schoolName ?? ""
                
                AuthSchool.modifyAndSave(schoolId, schoolName)
                
            }
            
            self.contentView.configAuthSchoolData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
