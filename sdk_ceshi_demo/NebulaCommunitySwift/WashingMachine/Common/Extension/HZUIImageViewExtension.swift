//
//  HZUIImageViewExtension.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/8.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

public func createCornerRadiusImageView(_ cornerRadius: CGFloat, image: UIImage? = nil, superVeiw: UIView? = nil) -> UIImageView {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = cornerRadius
    imageView.clipsToBounds = true
    imageView.image = image
    superVeiw?.addSubview(imageView)
    return imageView
}
