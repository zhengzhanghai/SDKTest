//
//  RequirementDetailCollectionViewCell.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequirementDetailCollectionViewCell : UICollectionViewCell

+ (instancetype)customCollectionViewCellWithCollectionView:(UICollectionView*)collectionView andIndexPath:(NSIndexPath*)indexPath;
- (void)refreshCell:(NSString *)icon title:(NSString *)title;
@end
