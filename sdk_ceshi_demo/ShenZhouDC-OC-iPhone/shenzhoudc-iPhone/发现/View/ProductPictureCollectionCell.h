//
//  ProductPictureCollectionCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/9/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductPhotoView.h"

@interface ProductPictureCollectionCell : UICollectionViewCell

@property (strong, nonatomic) ProductPhotoView *photoView;

+ (instancetype)create:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

@end
