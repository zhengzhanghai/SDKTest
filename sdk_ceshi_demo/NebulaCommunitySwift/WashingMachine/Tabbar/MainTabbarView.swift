//
//  MainTabbarView.swift
//  TabbarTest
//
//  Created by 郑章海 on 2020/12/10.
//

import UIKit

extension MainTabbarView {
    enum ItemType {
        case home
        case discover
        case me
        case ads
    }
}

class MainTabbarView: UIView {
    
    var didSelectedItem: ((ItemType) -> ())?
    var selectedColor: UIColor = UIColorRGB(50, 173, 240)
    var normalColor: UIColor = UIColor(rgb: 0x666666)
   
    lazy var homeItem: TabbarItem = {
        let item = TabbarItem()
        item.title = "首页"
        item.color = normalColor
        item.selectedColor = selectedColor
        item.image = UIImage(named: "tab_home")
        item.selectedImage = UIImage(named: "tab_home_ed")
        return item
    }()
    
    lazy var discoverItem: TabbarItem = {
        let item = TabbarItem()
        item.title = "发现"
        item.color = normalColor
        item.selectedColor = selectedColor
        item.image = UIImage(named: "tab_discover")
        item.selectedImage = UIImage(named: "tab_discover_ed")
        return item
    }()
    
    lazy var meItem: TabbarItem = {
        let item = TabbarItem()
        item.title = "我的"
        item.color = normalColor
        item.selectedColor = selectedColor
        item.image = UIImage(named: "tab_me")
        item.selectedImage = UIImage(named: "tab_me_ed")
        return item
    }()
    
    lazy var adsItem: TabbarItem = {
        let item = TabbarItem()
        item.color = normalColor
        item.title = "爱淘2020"
        item.selectedColor = selectedColor
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
        addSubview(homeItem)
        addSubview(discoverItem)
        addSubview(meItem)
        addSubview(adsItem)
        homeItem.isSelected = true
    }
    
    func changeToAdsItemFromDiscoverItem(title: String, image: UIImage) {
        discoverItem.removeFromSuperview()
        adsItem.title = title
        adsItem.image = image
        addSubview(adsItem)
        adsItem.frame = CGRect(x: bounds.width/3, y: 0, width: bounds.width/3, height: 44)
    }
    
    func selectItem(selectedItemType type: ItemType) {
        if type == .ads { return }
        homeItem.isSelected = (type == .home)
        discoverItem.isSelected = (type == .discover)
        meItem.isSelected = (type == .me)
        adsItem.isSelected = (type == .ads)
    }
    
    override func layoutSubviews() {
        let itemWidth = bounds.width / 3
        homeItem.frame = CGRect(x: 0, y: 0, width: itemWidth, height: 44)
        discoverItem.frame = CGRect(x: itemWidth, y: 0, width: itemWidth, height: 44)
        meItem.frame = CGRect(x: itemWidth * 2, y: 0, width: itemWidth, height: 44)
    }
    
}

extension MainTabbarView {
    func addEvent() {
        let homeGes = UITapGestureRecognizer(target: self, action: #selector(onClickHome))
        homeItem.addGestureRecognizer(homeGes)

        let discoverGes = UITapGestureRecognizer(target: self, action: #selector(onClickDiscover))
        discoverItem.addGestureRecognizer(discoverGes)

        let meGes = UITapGestureRecognizer(target: self, action: #selector(onClickMe))
        meItem.addGestureRecognizer(meGes)

        let adsGes = UITapGestureRecognizer(target: self, action: #selector(onClickADS))
        adsItem.addGestureRecognizer(adsGes)
    }
    
    @objc func onClickHome() {
        selectItem(selectedItemType: .home)
        didSelectedItem?(.home)
    }
    
    @objc func onClickDiscover() {
        selectItem(selectedItemType: .discover)
        didSelectedItem?(.discover)
    }
    
    @objc func onClickMe() {
        selectItem(selectedItemType: .me)
        didSelectedItem?(.me)
    }
    
    @objc func onClickADS() {
        selectItem(selectedItemType: .ads)
        didSelectedItem?(.ads)
    }
}

extension MainTabbarView {
    class TabbarItem: UIView {
        
        var title: String = "" {
            didSet { titleLabel.text = title }
        }
        var color: UIColor? {
            didSet { refreshUI() }
        }
        var selectedColor: UIColor? {
            didSet { refreshUI() }
        }
        var image: UIImage? {
            didSet { refreshUI() }
        }
        var selectedImage: UIImage? {
            didSet { refreshUI() }
        }
        var isSelected = false {
            didSet { refreshUI() }
        }
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = font_PingFangSC_Regular(10)
            return label
        }()
        
        lazy var imageView: UIImageView = {
            return UIImageView()
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI() {
            addSubview(titleLabel)
            addSubview(imageView)
        }
        
        func refreshUI() {
            imageView.image = isSelected ? selectedImage : image
            titleLabel.textColor = (isSelected ? selectedColor : color) ?? UIColor.black
        }
        
        override func layoutSubviews() {
            imageView.frame = CGRect(x: (bounds.size.width - 28) / 2, y: 5, width: 28, height: 28)
            titleLabel.frame = CGRect(x: 0, y: 33, width: bounds.size.width, height: 14)
        }
    }
}


