//
//  NCCollectionViewCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/6.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NCCollectionViewCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    
    static var identifier: String {
        return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last ?? "cell"
    }
    
    static func register(toCollectionView collectionView: UICollectionView) {
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: identifier)
    }
    
    static func registerXib(toCollectionView collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    static func create(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> NCCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! NCCollectionViewCell
        cell.indexPath = indexPath
        return cell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createContentView()
    }
    
    /// 如果是代码写的，留给子类重写
    func createContentView() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
