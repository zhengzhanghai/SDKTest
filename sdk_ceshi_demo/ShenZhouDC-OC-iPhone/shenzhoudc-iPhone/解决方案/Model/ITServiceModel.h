//
//  ITServiceModel.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseModel.h"

@interface ITServiceModel : BaseModel

@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *businessType;//业务类型 7测试 1安装 2调试 3巡检 4故障处理 5培训 6售前交流 8其他
@property(nonatomic,strong)NSNumber *technicalDirection;//技术方向 1网络类 2安全 3服务器 4 开发 5软件 6储存 7其他
@property(nonatomic,strong)NSString *serviceContent;//服务内容
@property(nonatomic,assign)NSInteger isovertime;//是否加班
@property(nonatomic,strong)NSNumber *orderPrice;//价格
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,strong)NSNumber *userid;
@property(nonatomic,copy)NSString *orderTime;
@property(nonatomic,copy)NSString *serviceTime;
@property(nonatomic,copy)NSString *serviceAddress;


- (NSString *)getTechnicalDirectionString;

@end
