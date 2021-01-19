//
//  DetailPaiViewControllerHeaderViewCollectionReusableView.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiModel.h"
@interface DetailPaiViewControllerHeaderViewCollectionReusableView : UICollectionReusableView
@property (nonatomic,assign) CGFloat selfHight;
+ (instancetype)customHeaaderFooterViewWith:(UICollectionView*)tableView andIndexPath:(NSIndexPath*)indexPath ;
@property (nonatomic,strong) PaiModel *model;

@end
