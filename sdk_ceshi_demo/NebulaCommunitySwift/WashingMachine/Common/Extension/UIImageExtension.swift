//
//  UIImageExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// 通过颜色创建UIImage
    class func create(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    

}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {

        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}





