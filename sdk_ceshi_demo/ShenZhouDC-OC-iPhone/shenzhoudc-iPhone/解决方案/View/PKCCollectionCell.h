//
//  PKCCollectionCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKGProjectModel.h"

@interface PKCCollectionCell : UICollectionViewCell

+ (instancetype)createNibCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

- (void)configWithPKG:(PKGProjectModel *)model;

@end
