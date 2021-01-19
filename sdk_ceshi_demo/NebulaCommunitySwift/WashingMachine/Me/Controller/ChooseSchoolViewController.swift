//
//  ChooseSchoolViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ChooseSchoolViewController: BaseViewController {
    
    var cityId: NSNumber?
    var tableView: UITableView!
    var schoolList: [SchoolModel]?
    var finishChooseSchoolClourse: ((SchoolModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "学校选择"
        self.makeUI()
        self.loadSchoolList()
    }
    
    fileprivate func makeUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT),style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ChooseSchoolViewController {
    func loadSchoolList() {
        if cityId == nil {
            print("--- 选择学校，学校Id为nil ----")
            return
        }
        
        let url = API_GET_SCHOOL_LIST + cityId!.stringValue
        self.showWaitingView(self.view)
        NetworkEngine.get(url, parameters: nil, completionClourse: { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                if let dict = result.dataObj as? [String: Any] {
                    if let list = dict["data"] as? [Any]{
                        var muArr = [SchoolModel]()
                        for i in 0 ..< list.count {
                            if let json = (list[i] as? [String: AnyObject]) {
                                let model = SchoolModel.create(json)
                                muArr.append(model)
                            }
                        }
                        self.schoolList = muArr
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
}

extension ChooseSchoolViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChooseSchoolCell.create(tableView: tableView)
        let model = schoolList?[indexPath.row]
        cell.config(title: model?.name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.finishChooseSchoolClourse != nil {
            let model = schoolList?[indexPath.row]
            self.finishChooseSchoolClourse!(model ?? SchoolModel())
        }
        self.navigationController?.popViewController(animated: true)
    }
}
