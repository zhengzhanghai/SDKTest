//
//  PaiMainViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2016/12/23.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PaiMainViewController.h"
#import "DLTabedSlideView.h"
#import "CommonMacro.h"
//#import "DLFixedTabbarView.h"


#import "MostNewViewController.h"
#import "GroomViewController.h"
#import "HootViewController.h"



@interface PaiMainViewController ()<DLTabedSlideViewDelegate>
@property (strong, nonatomic) DLTabedSlideView *tabedSlideView;

@end

@implementation PaiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self maekDLTabed];
}


-(void)maekDLTabed{
    self.tabedSlideView = [[DLTabedSlideView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT-NAVBARHEIGHT-STATUSBARHEIGHT) andTabbarHeight:44];
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.tabItemNormalColor = UIColorFromRGB(0x9E9E9E);
    self.tabedSlideView.tabItemSelectedColor = UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarTrackColor =  UIColorFromRGB(0xD71629);
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@""];
    self.tabedSlideView.tabbarBackgroundColor = [UIColor whiteColor];
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"最新派工" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"推荐派工" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"热门派工" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
    self.tabedSlideView.tabbarItems = @[item1, item2, item3];
    [self.tabedSlideView buildTabbar];
     self.tabedSlideView.selectedIndex = 0;
    
    
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            MostNewViewController *vc1 = [[MostNewViewController alloc] init];
            return vc1;
        }
        case 1:
        {
            GroomViewController *vc2 = [[GroomViewController alloc] init];
            return vc2;
        }
        case 2:
        {
            HootViewController *vc3 = [[HootViewController alloc] init];
            return vc3;
        }
            
        default:
            return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




