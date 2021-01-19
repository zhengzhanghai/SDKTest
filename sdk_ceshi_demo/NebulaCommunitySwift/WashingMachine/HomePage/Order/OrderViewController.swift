//
//  OrderViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class OrderViewController: BaseViewController {
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var menuView: HZMenuView!
    fileprivate var isClickTitle: Bool = false
    fileprivate var titleCount: NSInteger = 0
    fileprivate var menuViewHieght: CGFloat = 50
    fileprivate var subControllerDict = [NSInteger: UIViewController]()
    
    fileprivate var titleArray: [OrderTitleModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "订单"
        configMenuView()
        configScrollView()
        
        if !isLogin() {
            let vc = LoginViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(tabbarSelected), name: NSNotification.Name(rawValue: tabbarSelectOrderNotifation), object: nil)
    }
    
    @objc func tabbarSelected() {
        if !isLogin() {
            let vc = LoginViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if titleArray == nil || titleArray?.count == 0 {
            loadOrderTitleList()
        }
    }
    
    fileprivate func configScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: menuViewHieght,
                                                width: BOUNDS_WIDTH,
                                                height: contentHeightNoTop-menuViewHieght))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    fileprivate func configMenuView() {
        menuView = HZMenuView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: BOUNDS_WIDTH,
                                            height: menuViewHieght))
        menuView.backgroundColor = UIColor.white
        menuView.leftMargin = 30
        menuView.middleMargin = 40
        menuView.textFont = UIFont.boldSystemFont(ofSize: 17)
        menuView.textNorColor = UIColor(rgb: 0x333333)
        menuView.textSelectedColor = UIColor(rgb: 0x2a79fa)
        menuView.bottomLineColor = UIColor(rgb: 0x2a79fa)
        view.addSubview(menuView)
        menuView.clickItemClourse = { [weak self] index in
            self?.isClickTitle = true
            self?.addSubController(index: index)
            self?.scrollView.contentOffset = CGPoint(x: (self?.scrollView.hz_width ?? 0)*CGFloat(index), y: 0)
        }
    }

    fileprivate func addMenuTitles(titles: [String]?) {
        if titles != nil && titles!.count > 0 {
            menuView.addTitles(titles: titles)
            scrollView.contentSize = CGSize(width: BOUNDS_WIDTH*CGFloat(titles!.count), height: scrollView.hz_height)
            titleCount = titles!.count
            addSubController(index: 0)
            addSubController(index: 1)
        }
    }
    
    fileprivate func addSubController(index: NSInteger) {
        if !isExistSubController(index: index) {
            let controller = AllOrderViewController()
            controller.titleId = titleArray?[index].id
            self.addChild(controller)
            controller.view.frame = CGRect(x: scrollView.hz_width*CGFloat(index), y: 0, width: scrollView.hz_width, height: scrollView.hz_height)
            controller.didMove(toParent: self)
            scrollView.addSubview(controller.view)
            subControllerDict[index] = controller
        }
    }
    
    
    fileprivate func isExistSubController(index: NSInteger) -> Bool {
        if subControllerDict.keys.contains(index) {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if memoryWarningCount >= 3 {
            for (key, _) in subControllerDict {
                if key != menuView.currentIndex || key != menuView.currentIndex+1 || key != menuView.currentIndex-1{
                    subControllerDict.removeValue(forKey: key)
                }
            }
        }
    }
}

//MARK:  _____________________________ UIScrollViewDelegate
extension OrderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isClickTitle {
            
        } else {
            let rate = scrollView.contentOffset.x/scrollView.hz_width
            menuView.lineFlowScroll(rate: rate)
            let index = NSInteger(rate)
            if index > 0 && index < titleCount {
                addSubController(index: index)
            }
            if index + 1 > 0 && index + 1 < titleCount {
                addSubController(index: index+1)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClickTitle = false
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        menuView.isUserInteractionEnabled = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        menuView.currentIndex = NSInteger(round(scrollView.contentOffset.x/scrollView.hz_width))
        addSubController(index: menuView.currentIndex)
        menuView.isUserInteractionEnabled = true
    }
}

//MARK:  _____________________________ Network
extension OrderViewController {
        //获取订单列表的标题
        fileprivate func loadOrderTitleList() {
            let url = SERVICE_BASE_ADDRESS + API_GET_ORDER_TITLE
            showWaitingView(scrollView)
            NetworkEngine.get(url, parameters: nil) { (result) in
                self.hiddenWaitingView()
                if result.isSuccess {
                    if let dict = result.dataObj as? [String: AnyObject] {
                        if let list = dict["data"] as? [AnyObject] {
                            var array = [OrderTitleModel]()
                            var titles = [String]()
                            for i in 0 ..< list.count {
                                if let json = list[i] as? [String: AnyObject]{
                                    let model = OrderTitleModel.create(json)
                                    array.append(model)
                                    titles.append(model.name ?? "")
                                }
                            }
                            self.titleArray = array
                            self.addMenuTitles(titles: titles)
                        }
                    }
                } else {
                    showError(result.message, superView: self.scrollView)
                }
            }
    }
}

