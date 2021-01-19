//
//  PayResultViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

typedef NS_ENUM(NSInteger, PayResultType) {
    PayResultTypeFailure,
    PayResultTypeSuccess,
    PayResultTypeOther
};

#import "BaseViewController.h"

@interface PayResultViewController : BaseViewController
@property (assign, nonatomic) PayResultType payResult;
@end
