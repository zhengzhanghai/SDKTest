//
//  ChooseCityViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/4.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ChooseCityViewController: BaseViewController {
    
    weak var accreditationVC: SchoolAccreditationController?
    var provinceId: NSNumber?
    var tableView: UITableView!
    var finishChooseRegionClourse: ((String) -> ())?
    var cityList: [CityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "城市选择"
        self.makeUI()
        self.loadCityList()
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

extension ChooseCityViewController {
    func loadCityList() {
        if provinceId == nil {
            print("--- 选择城市，省Id为nil ----")
            return
        }
        
        let url = API_GET_CITY_LIST + provinceId!.stringValue
        self.showWaitingView(self.view)
        NetworkEngine.get(url, parameters: nil, completionClourse: { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                if let dict = result.dataObj as? [String: Any] {
                    if let list = dict["data"] as? [Any]{
                        var muArr = [CityModel]()
                        for i in 0 ..< list.count {
                            if let json = (list[i] as? [String: AnyObject]) {
                                let model = CityModel.create(json)
                                muArr.append(model)
                            }
                        }
                        self.cityList = muArr
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
}

extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regionCell = ChooseRegionCell.create(tableView: tableView)
        let model = self.cityList?[indexPath.row]
        regionCell.config(title: model?.name ?? "")
        return regionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if accreditationVC != nil {
            let model = cityList?[indexPath.row]
            accreditationVC?.finishCity(city: model ?? CityModel())
            self.navigationController?.popToViewController(accreditationVC!, animated: true)
        }
        
    }
}
