//
//  B_SelectedImagesViewController.h
//  Esalse
//
//  Created by 张丹丹 on 16/4/28.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectedImagesViewControllerDelegate <NSObject>

- (void)reloadUI;

@end

@interface SelectedImagesViewController : BaseViewController

//将选好的图片存放到这个数组中
@property(nonatomic,strong) NSMutableArray *photos;
@property(nonatomic, assign)NSInteger photoCount;// 发布数量限制条件
//代理
@property(nonatomic,weak) id<SelectedImagesViewControllerDelegate> delegate;



@end
