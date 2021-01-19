//
//  PhotoAlbumCollectionCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumCollectionCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    
    func config(_ imageManager: PHCachingImageManager, photo: PhotoModel, _ itemSize: CGSize) {
        let size = CGSize(width: itemSize.width*2, height: itemSize.width*2)
        imageManager.requestImage(for: photo.asset ?? PHAsset(), targetSize: size, contentMode: .aspectFill, options: nil) { (image, info) in
            self.pictureImageView.image = image
        }
    }
    
    class func cell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> PhotoAlbumCollectionCell {
        let identifier = NSStringFromClass(self.classForCoder())
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: identifier)
        let cell: PhotoAlbumCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoAlbumCollectionCell
        cell.indexPath = indexPath
        return cell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        contentView.addSubview(pictureImageView)
        pictureImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    fileprivate var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.green
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
}
