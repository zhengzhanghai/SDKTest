//
//  ChangeUserInfoViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/5/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeUserInfoViewController : BaseViewController
@property(nonatomic,copy) NSString *titleTxt;
@property(nonatomic,assign) int type; //0 修改姓名 1修改性别
//@property(nonatomic,assign) int sex; //1男 2女 0保密
@end
