//
//  HZCycleViewCell.swift
//  swift_base_test
//
//  Created by Harious on 2018/2/8.
//  Copyright © 2018年 zzh. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension HZCycleView {
    
    class CycleCell: UICollectionViewCell {
        
        var mode : UIView.ContentMode = .scaleAspectFill {
            didSet{
                imageView.contentMode = mode
            }
        }
        
        //FIXME: 本地和网络下载走的不同路径
        var imageURLString : String? {
            didSet{
                guard let imageURLStr = imageURLString else {
                    imageView.image = nil
                    return
                }
                
                if imageURLStr.hasPrefix("http") {
                    imageView.kf.indicatorType = .activity
                    imageView.kf.setImage(with: URL(string: imageURLStr),
                                          placeholder: nil,
                                          options: [.transition(ImageTransition.fade(1))])
                } else {
                    //本地图片
                    imageView.image = UIImage(named: imageURLStr)
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubview(imageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: 懒加载
        lazy var imageView : UIImageView = {
            let imageView = UIImageView(frame: bounds)
            imageView.clipsToBounds = true
            return imageView
        }()
    }
}
