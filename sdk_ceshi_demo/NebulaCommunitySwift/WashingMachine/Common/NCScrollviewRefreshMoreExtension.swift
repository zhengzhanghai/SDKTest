//
//  NCScrollviewRefreshMoreExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView {
    
    /// 删除下拉刷新header
    func nc_delegateRefreshHeader() {
        self.mj_header = nil
    }
    
    /// 删除下拉刷新footer
    func nc_delegateRefreshFooter() {
        self.mj_footer = nil
    }
    
    /// 添加下拉刷新header
    func nc_addRefreshHeader(_ refreshClourse: (()->())?) {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            refreshClourse?()
        })
        // 隐藏最后刷新时间
        header?.lastUpdatedTimeLabel.isHidden = true
        self.mj_header = header
    }
    
    /// 添加上拉加载footer
    func nc_addLoadMoreFooter(_ loadMoreClourse: (()->())?) {
        let footer = MJRefreshBackNormalFooter(refreshingBlock: {
            loadMoreClourse?()
        })
        // 将箭头取消掉
        footer?.arrowView.image = UIImage()
        self.mj_footer = footer
    }
    
    /// 添加自动上拉上拉加载footer
    func nc_addLoadMoreAutoFooter(_ loadMoreClourse: (()->())?) {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            loadMoreClourse?()
        })
        self.mj_footer = footer
    }
    
    /// 结束header刷新
    func nc_endHeaderRefresh() {
        self.mj_header?.endRefreshing()
    }
    
    /// 结束footer刷新
    func nc_endFooterRefresh() {
        self.mj_footer?.endRefreshing()
    }
    
    /// 重置没有更多数据
    func nc_resetNotMoreData() {
        self.mj_footer?.resetNoMoreData()
    }
    
    /// 结束header、footer刷新
    func nc_endRefresh() {
        nc_endHeaderRefresh()
        nc_endFooterRefresh()
    }
    
    /// 手动调用代码刷新
    func nc_beginFefresh() {
        self.mj_header?.beginRefreshing()
    }
    
    /// 结束footer刷新,并展示没有更多数据
    func nc_endRefreshingWithNoMoreData() {
        self.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    /// 设置header是否显示
    func nc_hiddenRefreshHeader(_ hidden: Bool) {
        self.mj_header?.alpha = hidden ? 0.01 : 1
    }
    
    /// 设置footer是否显示
    func nc_hiddenRefreshFooter(_ hidden: Bool) {
        self.mj_footer?.alpha = hidden ? 0.01 : 1
    }
}
