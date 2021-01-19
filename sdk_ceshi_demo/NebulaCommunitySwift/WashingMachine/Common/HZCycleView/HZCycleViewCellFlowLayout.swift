//
//  HZCycleViewCellFlowLayout.swift
//  swift_base_test
//
//  Created by Harious on 2018/2/8.
//  Copyright © 2018年 zzh. All rights reserved.
//

import Foundation
import UIKit

extension HZCycleView {
    
    class CellFlowLayout: UICollectionViewFlowLayout {
        
        override func prepare() {
            super.prepare()
            //尺寸
            itemSize = (collectionView?.bounds.size)!
            //间距
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            //滚动方向
            scrollDirection = .horizontal
        }
    }
}
