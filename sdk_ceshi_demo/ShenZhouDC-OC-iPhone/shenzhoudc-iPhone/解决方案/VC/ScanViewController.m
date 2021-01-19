//
//  ScanViewController.m
//  shenzhoudc-iPhone
//
//  Created by Moguilay on 2017/5/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ScanViewController.h"
#import "ChargeViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码付款";
    // Do any additional setup after loading the view.
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    NSLog(@"%@",strResult);
   
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    if (!strResult) {
        
        NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"没找到相关信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //确定申诉
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
       
    }
    
    NSString *userId = strResult.strScanned;
    
    if ([[UserModel sharedModel].userId isEqualToString:userId]) {//如果是本用户  进入账户充值
        ChargeViewController *vc = [[ChargeViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else
    {
        NoAutorotateAlertController *alert = [NoAutorotateAlertController alertControllerWithTitle:@"提示" message:@"不是当前用户，请退出重新登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //确定申诉
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];


        
    }
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
