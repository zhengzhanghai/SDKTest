//
//  MoreCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaiModel;
typedef void(^sendTagBlock)(NSInteger,NSInteger,BOOL);
@interface MoreCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) PaiModel *model;
@property (nonatomic,copy) sendTagBlock sendTagBlock;
+ (MoreCollectionViewCell*)customCellWithTableView:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath;
@end
