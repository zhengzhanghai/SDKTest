//
//  WatchOnlineViewController.h
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"
#import "JieJueModel.h"
@interface WatchOnlineViewController : BaseViewController
@property (strong, nonatomic) JieJueModel *model;
@property (copy, nonatomic)   NSString *url;
@end
