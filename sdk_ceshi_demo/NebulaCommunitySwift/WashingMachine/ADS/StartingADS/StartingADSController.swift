//
//  StartingADSController.swift
//  WashingMachine
//
//  Created by ZZH on 2020/11/28.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class StartingADSController {
    
    fileprivate var time = 6
    fileprivate var timer: DispatchSourceTimer?
    /// 获取广告的最长时间
    fileprivate var loadingADSTime = 3
    /// 获取广告最长时间倒计时
    fileprivate var loadingTimer: DispatchSourceTimer?
    /// 是否还需要展示广告，如果获取广告的时间超过了loadingADSTime，将不再展示广告
    fileprivate var showADS: Bool = true
    fileprivate weak var curVC: UIViewController?
    fileprivate var adsModel: SSPADSModel?
    
    var adsView: StartingADSView = {
        let view = StartingADSView()
        return view
    }()
    
    func showADS(_ vc: UIViewController) {
        curVC = vc
        vc.tabBarController?.view.addSubview(adsView)
        adsView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addEvent()
        addLoadingADSTimer()
        loadStartingADS()
    }
    
    func dismissADS() {
        showADS = false
        adsView.removeFromSuperview()
        timer?.cancel()
        loadingTimer?.cancel()
    }
    
    func startShowADS(adsModel: SSPADSModel) {
        loadingTimer?.cancel()
        guard showADS else {
            return
        }
        self.adsModel = adsModel
        self.adsView.refresh(adsModel: adsModel)
        ADSManager.reportAfterShowed(adsModel: adsModel)
        addTimer()
    }
    
    func loadStartingADS() {
        ADSManager.getADSList(ADSID: ADSManager.StartingID, pageKeywords: "社区", adsSize: UIScreen.main.bounds.size) { (adses) in
            if let adsModel = adses.first {
                self.startShowADS(adsModel: adsModel)
            } else {
                self.dismissADS()
            }
        }
    }
}

//MARK: 事件相关
extension StartingADSController {
    func addEvent() {
        // 点击广告回调
        adsView.onTapADSClosures = { [unowned self] point in
            ADSManager.onClick(adsModel: self.adsModel!, vc: self.curVC!, tapPoint: point, adsSize: CGSize(width: BOUNDS_WIDTH * 2, height: BOUNDS_HEIGHT * 2))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                self.dismissADS()
            }
        }
        
        // 点击跳过回调
        adsView.onTapSkipClosures = { [unowned self] in
            self.dismissADS()
        }
    }
    
    func addTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(deadline: DispatchTime.now(),
                        repeating: .seconds(1),
                        leeway: .milliseconds(10))
        timer?.setEventHandler(handler: { [weak self] in
            guard let mySelf = self else {return}
            mySelf.time -= 1
            mySelf.adsView.updateTime(time: mySelf.time)
            if mySelf.time < 0 {
                DispatchQueue.main.async {
                    self?.dismissADS()
                }
            }
        })
        timer?.resume()
    }
    
    func addLoadingADSTimer() {
        loadingTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        loadingTimer?.schedule(deadline: DispatchTime.now(),
                        repeating: .seconds(1),
                        leeway: .milliseconds(0))
        loadingTimer?.setEventHandler(handler: { [weak self] in
            guard let mySelf = self else {return}
            mySelf.loadingADSTime -= 1
            if mySelf.loadingADSTime < 0 {
                DispatchQueue.main.async {
                    self?.showADS = false
                    self?.dismissADS()
                }
            }
        })
        loadingTimer?.resume()
    }
}
