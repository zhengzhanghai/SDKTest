//
//  CollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/8/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieJueModel.h"
#import "PlanModel.h"
#import "ChanPinModel.h"

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) PlanModel *model;
@property (strong, nonatomic) ChanPinModel *productModel;

+ (instancetype)create:(UICollectionView *)coll indexPath:(NSIndexPath *)indexPath;
    
@end
