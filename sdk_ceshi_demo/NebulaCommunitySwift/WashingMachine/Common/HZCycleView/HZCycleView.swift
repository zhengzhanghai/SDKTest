//
//  HZCycleView.swift
//  swift_base_test
//
//  Created by Harious on 2018/2/8.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit

class HZCycleView: UIView {

    /// 点击item回调
    var didSelectedItem: ((Int) -> ())?
    /// 自动切换时间
    var automaticUpdateTime: TimeInterval = 5
    var imageViewContentMode : UIView.ContentMode = .scaleAspectFill
    
    //CollectionView复用cell的机制,不管当前的section有道少了item,当cell的宽和屏幕的宽一致是,当前屏幕最多显示两个cell(图片切换时是两个cell),切换完成时有且仅有一个cell,即使放大1000倍,内存中最多加载两个cell,所以不会造成内存暴涨现象
    let KCount = 100
    
    //MARK: 获取图片URL数组
    var imageURLStringArr : [String]? {
        didSet{
            // 暂停即使器
            timer.fireDate = Date.distantFuture
            
            guard let imageArr = imageURLStringArr else {
                pageControl.numberOfPages = 0
                collectionView.reloadData()
                collectionView.isScrollEnabled = false
                return
            }
            
            pageControl.numberOfPages = imageArr.count
            collectionView.reloadData()
            
            if imageArr.count == 0 || imageArr.count == 1 {
                collectionView.isScrollEnabled = false
            } else {
                
                //滚动到中间位置
                let indexPath : IndexPath = IndexPath(item: imageArr.count * KCount, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                
                collectionView.isScrollEnabled = true
                timer.fireDate = Date(timeIntervalSinceNow: automaticUpdateTime)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 懒加载子控件
    //collectionView
    lazy var collectionView : UICollectionView = {
        let layout : CellFlowLayout = CellFlowLayout()
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = false
        collectionView.bounces = false;
        collectionView.isPagingEnabled = true;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.register(CycleCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    //指示器
    lazy var pageControl : UIPageControl = {
        let width : CGFloat = 120
        let height : CGFloat = 20
        let pointX : CGFloat = (UIScreen.main.bounds.size.width - width) * 0.5
        let pointY : CGFloat = bounds.size.height - height
        let pageControl = UIPageControl(frame: CGRect(x: pointX, y: pointY, width: width, height: height))
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor.lightText
        pageControl.currentPageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    //定时器
    lazy var timer : Timer = {
        let timer = Timer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
   
}

//MARK: 轮播逻辑处理
extension HZCycleView {
    //MARK: 更新定时器 获取当前位置,滚动到下一位置
    @objc func updateTimer() -> Void {
        let indexPath = collectionView.indexPathsForVisibleItems.last
        guard indexPath != nil else {
            return
        }
        let nextPath = IndexPath(item: (indexPath?.item)! + 1, section: (indexPath?.section)!)
        collectionView.scrollToItem(at: nextPath, at: .left, animated: true)
    }
    
    //MARK: 开始拖拽时,停止定时器
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    //MARK: 结束拖拽时,恢复定时器
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = Date(timeIntervalSinceNow: automaticUpdateTime)
    }
    
    //MARK: 监听手动减速完成(停止滚动)  - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let imageArr = imageURLStringArr else { return }
        
        let offsetX : CGFloat = scrollView.contentOffset.x
        let page : Int = Int(offsetX / bounds.size.width)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        if page == 0 { //第一页
            collectionView.contentOffset = CGPoint(x: offsetX + CGFloat(imageArr.count) * CGFloat(KCount) * bounds.size.width, y: 0)
        } else if page == itemsCount - 1 { //最后一页
            collectionView.contentOffset = CGPoint(x: offsetX - CGFloat(imageArr.count) * CGFloat(KCount) * bounds.size.width, y: 0)
        }
    }
    
    //MARK: 滚动动画结束的时候调用 - 获取当前页码,滚动到下一页,如果当前页码是第一页,继续往下滚动,如果是最后一页回到第一页
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(collectionView)
    }
    
    //MARK: 正在滚动(设置分页) -- 算出滚动位置,更新指示器
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let imageArr = imageURLStringArr else {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        var page = Int(offsetX / bounds.size.width + 0.5)
        page = page % imageArr.count
        pageControl.currentPage = page
    }
    
    //MARK: 随父控件的消失取消定时器
    internal override func removeFromSuperview() {
        super.removeFromSuperview()
        timer.invalidate()
    }
}

//MARK: 数据源和代理方法
extension HZCycleView: UICollectionViewDelegate, UICollectionViewDataSource {
    //FIXME: 点击cell的代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedItem?(indexPath.item % (imageURLStringArr?.count)!)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageURLStringArr?.count ?? 0) * 2 * KCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CycleCell
        cell.mode = imageViewContentMode
        cell.imageURLString = imageURLStringArr?[indexPath.item % (imageURLStringArr?.count)!] ?? ""
        return cell
    }

}

//MARK: 设置UI--轮播界面,指示器,定时器
extension HZCycleView {
    fileprivate func setUpUI() {
        addSubview(collectionView)
        addSubview(pageControl)
//        //启动定时器
//        timer.fireDate = Date(timeIntervalSinceNow: automaticUpdateTime)
    }
}
