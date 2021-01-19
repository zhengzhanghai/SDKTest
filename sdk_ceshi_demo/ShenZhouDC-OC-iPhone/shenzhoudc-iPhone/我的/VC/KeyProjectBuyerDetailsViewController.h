//
//  KeyProjectBuyerDetailsViewController.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/27.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyProjectBuyerModel.h"

@interface KeyProjectBuyerDetailsViewController : BaseViewController

@property (strong, nonatomic) KeyProjectBuyerModel *buyerModel;

@property (copy, nonatomic)   NSString *pkgId;

@end
