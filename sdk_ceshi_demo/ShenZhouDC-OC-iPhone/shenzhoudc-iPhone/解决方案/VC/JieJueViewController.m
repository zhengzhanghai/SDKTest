//
//  JieJueViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "JieJueViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "JieJueMoreViewController.h"
#import "JieJueDetailsViewController.h"
#import "AINetworkEngine.h"
#import "JieJueTableViewCell.h"
#import "NetAPI.h"
#import "JieJueModel.h"
#import "ADSModel.h"
//导入头文件
#import "ScanViewController.h"
#import "PlanModel.h"
#import "SearchViewController.h"
#import "TestView.h"

//#import "SubLBXScanViewController.h"


@interface JieJueViewController ()
@property (weak, nonatomic)   UITextView *textV;
@property (assign, nonatomic) NSInteger index;

@end

@implementation JieJueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [TestView showToWindow];
    
    
    
}


@end
