//
//  ChooseRegionViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/2.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ChooseRegionViewController: BaseViewController {
    
    weak var accreditationVC: SchoolAccreditationController?
    var tableView: UITableView!
    var provinceList: [ProvinceModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "地区选择"
        self.makeUI()
        self.loadProvinceList()
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

extension ChooseRegionViewController {
    func loadProvinceList() {
        let url = API_GET_PROVINCE_LIST
        self.showWaitingView(self.view)
        NetworkEngine.get(url, parameters: nil, completionClourse: { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                if let dict = result.dataObj as? [String: Any] {
                    if let list = dict["data"] as? [Any]{
                        var muArr = [ProvinceModel]()
                        for i in 0 ..< list.count {
                            if let json = (list[i] as? [String: AnyObject]) {
                                let model = ProvinceModel.create(json)
                                muArr.append(model)
                            }
                        }
                        self.provinceList = muArr
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
}

extension ChooseRegionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if NCLocation.message.address == "" {
                return 0
            }
            return 0
        }
        return self.provinceList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 {
            let locationCell = LocationChooseRegionCell.create(tableView: tableView)
            locationCell.config(title: NCLocation.message.address)
            cell = locationCell
        } else {
            let regionCell = ChooseRegionCell.create(tableView: tableView)
            let model = self.provinceList?[indexPath.row]
            regionCell.config(title: model?.name ?? "")
            cell = regionCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = provinceList?[indexPath.row]
            let vc = ChooseCityViewController()
            vc.accreditationVC = self.accreditationVC
            vc.provinceId = model?.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
