//
//  SuccessCaseCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaiModel;
@interface DetailCaseCollectionViewCell : UICollectionViewCell

+ (instancetype)cell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)refreshCell;
@property (nonatomic,strong)PaiModel *model;
@end
