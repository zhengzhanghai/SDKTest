//
//  PhotoAlbumCollectionController.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//


import UIKit
import Photos

class PhotoAlbumCollectionController: UIViewController {
    
    fileprivate let itemWidth = (BOUNDS_WIDTH - 25)/4
    fileprivate let itemHeight = (BOUNDS_WIDTH - 25)/4
    var assetsFetchResults: PHFetchResult<PHAsset>?
    var photoArray: [PhotoModel]?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
        photoAlbumOriginImage()
    }
    
    fileprivate var imageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    
    fileprivate func makeCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    fileprivate func photoAlbumOriginImage() {
        let allPhotoOptions = PHFetchOptions()
        allPhotoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
        allPhotoOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.image.rawValue)
        assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allPhotoOptions)
        if assetsFetchResults != nil {
            var photoes = [PhotoModel]()
            for i in 0 ..< assetsFetchResults!.count {
                let photo = PhotoModel()
                photo.asset = assetsFetchResults![i]
                photoes.append(photo)
            }
            photoArray = photoes
        }
        imageManager.stopCachingImagesForAllAssets()
        collectionView.reloadData()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PhotoAlbumCollectionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PhotoAlbumCollectionCell.cell(collectionView, indexPath)
        let photo = self.photoArray?[indexPath.row] ?? PhotoModel()
        cell.config(imageManager, photo: photo, CGSize(width: itemWidth, height: itemHeight))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        windowUserEnabled(false)
        let checkVC = PictureCheckViewController()
        checkVC.imageManager = imageManager
        checkVC.asset = self.photoArray?[indexPath.row].asset
        self.present(checkVC, animated: true) { 
            windowUserEnabled(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)
    }
}
