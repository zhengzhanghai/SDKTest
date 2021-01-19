//
//  ThreeHootViewController.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^classBlock)(BOOL isAll);
@interface ThreeHootViewController : UICollectionReusableView
@property (nonatomic,copy) classBlock classBlock;
+ (ThreeHootViewController*)threeCustomReusableViewWithCollectionView:(UICollectionView*)collctionView andIndexPath:(NSIndexPath*)indexPath;
@end
