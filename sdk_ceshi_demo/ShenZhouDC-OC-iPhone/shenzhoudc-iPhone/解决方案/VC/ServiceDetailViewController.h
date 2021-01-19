//
//  ServiceDetailViewController.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface ServiceDetailViewController : BaseViewController
@property(nonatomic,assign)NSInteger id;//订单id
@property(nonatomic,strong)NSString *orderSn;//
@property(nonatomic,copy)NSString *userid;//发单人id
@end
