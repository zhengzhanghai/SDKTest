//
//  BannerADSView.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/10.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class BannerADSView: UIView {
    
    var touchSelfClosure: ((CGPoint) -> ())?
    var clickCloseClosure: (() -> ())?
    
    lazy var launchImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    lazy var adsBGView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close_normal_white"), for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ icon: String, _ title: String?, _ subTitle: String?) {
        if let imageUrl = URL(string: icon) {
            iconImageView.kf.setImage(with: imageUrl)
        }
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    //MARK: - setupUI
    
    func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 5
        clipsToBounds = true
        
        addSubview(iconImageView)
//        addSubview(titleLabel)
//        addSubview(subTitleLabel)
        addSubview(closeBtn)
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
  
}

///MARK: - Event

extension BannerADSView {
    func addEvent() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(onTouchSelf))
        addGestureRecognizer(tapGes)
        
        closeBtn.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
    }
    
    @objc func onTouchSelf(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        touchSelfClosure?(point)
    }
    
    @objc func onClickClose() {
        clickCloseClosure?()
    }
}
