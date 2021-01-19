//
//  TwoMoreCollectionReusableView.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^classBlock)(BOOL isAll);
@interface TwoMoreCollectionReusableView : UICollectionReusableView
@property (nonatomic,copy) classBlock classBlock;
+ (TwoMoreCollectionReusableView*)twoCustomReusableViewWithCollectionView:(UICollectionView*)collctionView andIndexPath:(NSIndexPath*)indexPath;

@end
