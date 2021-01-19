//
//  ProductCollectionCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/9/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanPinModel.h"

@interface ProductCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *categrayLabel;
@property (strong, nonatomic) UIButton *priseBtn;
@property (strong, nonatomic) UIImageView *priseIcon;
@property (strong, nonatomic) UILabel *priseLabel;
@property (strong, nonatomic) UIButton *badBtn;
@property (strong, nonatomic) UIImageView *badIcon;
@property (strong, nonatomic) UILabel *badLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic)   void(^clickItemBlock)(int ,NSIndexPath *);
@property (strong, nonatomic) ChanPinModel *productModel;

+ (instancetype)create:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
