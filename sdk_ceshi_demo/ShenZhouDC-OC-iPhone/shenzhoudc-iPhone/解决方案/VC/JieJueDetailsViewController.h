//
//  JieJueDetailsViewController.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"

@interface JieJueDetailsViewController : BaseViewController
@property (copy, nonatomic) NSString *id;//方案ID  或者需求ID  产品ID
@property (assign, nonatomic) float price;
@property (assign, nonatomic) BOOL isShowEvaluate;
@end
