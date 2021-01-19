//
//  StartingADSView.swift
//  WashingMachine
//
//  Created by ZZH on 2020/11/28.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class StartingADSView: UIView {
    
    var onTapADSClosures: ((CGPoint) -> ())?
    var onTapSkipClosures:(() -> ())?
    
    lazy var launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launch_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var adsBGView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var adsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = font_PingFangSC_Semibold(15)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.setTitle("跳过", for: .normal)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    lazy var appInfoBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "星云社区"
        label.font = font_PingFangSC_Regular(25)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh(adsModel: SSPADSModel) {
        var adsImageUrlStr = adsModel.image
        if let fullimage = adsModel.fullimage, BOUNDS_HEIGHT/BOUNDS_WIDTH > 2 {
            adsImageUrlStr = fullimage
        }
        if let addLogo = adsModel.add_logo, let url = URL(string: adsImageUrlStr), addLogo == 1 {
            ImageDownloader.default.downloadImage(with: url, retrieveImageTask: nil, progressBlock: nil) { (image, error, url, data) in
                if let image = image {
                    self.adsBGView.isHidden = false
                    let size = image.size
                    let height = size.height * BOUNDS_WIDTH / size.width
                    self.adsImageView.snp.updateConstraints { (make) in
                        make.bottom.equalTo(-max(BOUNDS_HEIGHT-height, 90))
                    }
                }
                self.adsImageView.image = image
                self.adsBGView.isHidden = false
            }
        } else {
            adsImageView.snp.updateConstraints { (make) in
                make.bottom.equalTo(0)
            }
            adsImageView.kf.setImage(with: URL(string: adsModel.image))
            adsBGView.isHidden = false
        }
        
    }
    
    func updateTime(time: Int) {
        DispatchQueue.main.async {
            self.skipBtn.isHidden = false
            self.skipBtn.setTitle( "\(time) 跳过", for: .normal)
        }
    }
    
    func setupUI() {
        backgroundColor = UIColor.red
        adsBGView.isHidden = true
        
        addSubview(launchImageView)
        addSubview(adsBGView)
        adsBGView.addSubview(adsImageView)
        adsBGView.addSubview(skipBtn)
        adsBGView.addSubview(bottomView)
        bottomView.addSubview(appInfoBGView)
        appInfoBGView.addSubview(logoImageView)
        appInfoBGView.addSubview(appNameLabel)
        
        launchImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        adsBGView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        adsImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        skipBtn.snp.makeConstraints { (make) in
            make.top.equalTo(is_iPhoneX ? 40 : 30)
            make.right.equalTo(-20)
            make.width.equalTo(53)
            make.height.equalTo(30)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(adsImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        appInfoBGView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        logoImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        appNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.centerY.right.equalToSuperview()
        }
    }
}

//MARK: 事件相关
extension StartingADSView {
    func addEvent() {
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTapADS))
        adsBGView.addGestureRecognizer(ges)
        
        skipBtn.addTarget(self, action: #selector(onTapSkip), for: .touchUpInside)
    }
    
    @objc fileprivate func onTapADS(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        onTapADSClosures?(point)
    }
    
    @objc fileprivate func onTapSkip() {
        onTapSkipClosures?()
    }
}
