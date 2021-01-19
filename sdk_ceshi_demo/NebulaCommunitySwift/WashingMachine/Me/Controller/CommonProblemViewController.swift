//
//  CommonProblemViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/11/2.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommonProblemViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

   fileprivate var appKey:String?
   fileprivate var questionArray:[QustionModel]?
   fileprivate var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "常见问题"
        self.makeUI()
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func makeUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) ,style:.plain)
        tableView?.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommonProblemTableCell.create(tableView: tableView)
        cell.refreshUI(questionArray![indexPath.row])
        return cell
    }


    fileprivate func loadData() {
        self.showWaitingView(self.view)
        MeViewModel.loadCommonProblemList { (models, message) in
            self.hiddenWaitingView()
            self.questionArray = models
            self.tableView?.reloadData()
        }
    }

}
