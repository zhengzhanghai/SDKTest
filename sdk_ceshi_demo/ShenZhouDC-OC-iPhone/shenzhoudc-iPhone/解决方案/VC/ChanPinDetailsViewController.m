//
//  ChanPinDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "ChanPinDetailsViewController.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "ChanPinDetailsChanPinController.h"
#import "ChanPinDetailsDetailsController.h"
#import "CanPinDetailsCanShuViewController.h"
#import "ChanPinPingJiaViewController.h"
#import "CommentViewController.h"

@interface ChanPinDetailsViewController ()<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;
@end


@implementation ChanPinDetailsViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self maekDLTabed];
    [self makePingJiaBtn];
}

- (void)makePingJiaBtn {
    UIButton *pingJiaBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:pingJiaBtn];
    pingJiaBtn.frame = CGRectMake(SCREEN_WIDTH-40, 32, 30, 20);
    pingJiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pingJiaBtn setTitle:@"评价" forState:UIControlStateNormal];
    [pingJiaBtn setTitleColor:UIColorFromRGB(0xD71629) forState:UIControlStateNormal];
    [pingJiaBtn addTarget:self action:@selector(pingJia) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark  点击评价
- (void)pingJia {
    CommentViewController *vc = [[CommentViewController alloc] init];
    vc.commentId = 1;
    vc.resourceId = self.id;
    vc.orderId = @"123456789";
    [self pushControllerHiddenTabbar:vc];
    NSLog(@"评价");
}


-(void)maekDLTabed{
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBARHEIGHT) andTabbarHeight:NAVBARHEIGHT];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.tabItemNormalColor = UIColorFromRGB(0x2A2A2A);//
    self.tabedSlideView.tabItemSelectedColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarTrackColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@""];
    self.tabedSlideView.tabbarBackgroundColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"详细说明" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"产品参数" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"全部评价" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    self.tabedSlideView.tabbarItems = @[item1, item2, item3];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;
    
    
    //测试用
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, NAVBARHEIGHT, NAVBARHEIGHT);
    [back setImage:[UIImage imageNamed:@"返回深色"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.tabedSlideView addSubview:back];
    
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            ChanPinDetailsChanPinController *vc1 = [[ChanPinDetailsChanPinController alloc] init];
            vc1.id = self.id;
            return vc1;
        }
        case 1:
        {
            CanPinDetailsCanShuViewController *vc2 = [[CanPinDetailsCanShuViewController alloc] init];
            vc2.id = self.id;
            return vc2;
        }
        case 2:
        {
            ChanPinPingJiaViewController *vc3 = [[ChanPinPingJiaViewController alloc] init];
            vc3.id = self.id;
            return vc3;
        }
        default:
            return nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
