//
//  DispatchDetailsViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "MySendModel.h"
#import "MyRecievedModel.h"

@interface DispatchDetailsViewController : BaseViewController
/*
 0:我的派单--进行中--本人验收--验收完工
 1：我的接单--进行中---确认完工
 */
@property(nonatomic,assign) NSInteger type;// 0 当前是发单人  1 当前是接单人
@property(nonatomic,strong)MySendModel *model;
@property(nonatomic,strong)MyRecievedModel *recModel;

@property(nonatomic,assign) int isOver;//获取接单人是否已点击确认完工 0 否 1是

@end
