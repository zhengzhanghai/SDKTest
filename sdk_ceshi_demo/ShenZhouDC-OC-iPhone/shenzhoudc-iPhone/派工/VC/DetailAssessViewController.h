//
//  DetailAssessViewController.h
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DetailAssessRefreshBlcok)();
@interface DetailAssessViewController : UIViewController
@property(nonatomic,assign) int ID;
@property (nonatomic,copy) DetailAssessRefreshBlcok DetailAssessRefreshBlcok;
@end
