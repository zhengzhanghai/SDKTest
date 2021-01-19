//
//  PictureCheckViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Photos

class PictureCheckViewController: UIViewController {
    
    var asset: PHAsset?
    var imageManager: PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        makeUI()
    }
    
    fileprivate func makeUI() {
        if asset != nil {
            let imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageManager.requestImage(for: asset!, targetSize: CGSize(width: asset!.pixelWidth, height: asset!.pixelHeight), contentMode: .aspectFill, options: nil) { (image, info) in
                imageView.image = image
            }
            self.view.addSubview(imageView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        windowUserEnabled(false)
        self.dismiss(animated: true) { 
            windowUserEnabled(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
