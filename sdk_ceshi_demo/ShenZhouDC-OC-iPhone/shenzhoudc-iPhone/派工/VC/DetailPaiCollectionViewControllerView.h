//
//  DetailPaiCollectionViewControllerView.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void(^refreshBlcok)();
@interface DetailPaiCollectionViewControllerView : BaseViewController
@property (nonatomic,assign) int ID;
@property (nonatomic,copy)refreshBlcok refreshBlcok;
@end
