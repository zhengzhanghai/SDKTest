//
//  SuccessCaseCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieJueModel.h"

@interface SuccessCaseCollectionViewCell : UICollectionViewCell

+ (instancetype)cell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)refreshCell;

- (void)refreshCell:(JieJueModel *)model;
@end
