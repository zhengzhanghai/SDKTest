//
//  ManufacturerInfoViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ManufacturerInfoViewController.h"
#import "SelectedImagesViewController.h"
#import "MeMainViewController.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"

#define DESP_MAX_LENGTH 300

@interface ManufacturerInfoViewController ()<UITextFieldDelegate,SelectedImagesViewControllerDelegate>
{
    UITextField *companyName;//公司名字
    UITextField *establishTime;//成立时间
    UITextField *managerName;//管理员姓名
    UITextField *managerPhone;//管理员电话
    UITextField *referrer;//推荐人
    UITextField *managerEmail;//管理员邮箱
    UITextView  *companyQulification;//公司资质
    UITextField *companyWebset;//公司网站
    UITextField *registeredCapital;//注册资金
    UITextView  *businessScope;//经营范围
    UITextField *year;
    UITextField *month;
    UITextField *day;
    
    UIButton    *_navSureBtn;
    UIButton    *_unfoldBtn;
    NSArray     *_protocolArray;
    UIButton    *_selectedBtn;
}
@property (nonatomic, strong) UITextField *BusinessLicenseTextField;
@property (nonatomic, strong) UITextField *OrganizationCodeTextField;

@property(nonatomic, strong) SelectedImagesViewController *photoVC;//营业执照
@property(nonatomic, strong) SelectedImagesViewController *organizatioVC;//组织机构代码
@property(nonatomic, strong) SelectedImagesViewController *taxpayerVC;//纳税人
@property(nonatomic, strong) SelectedImagesViewController *companyVC;//公司资质

@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *protocolView;
@end

@implementation ManufacturerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公司认证";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadProtocol];
}
- (void)clickLeftItem {
    if (!_selectedBtn.isSelected) {
        [self showError:self.view message:@"必须同意相关服务条款和隐私政策" afterHidden:2];
        return;
    }
    [self registerAsCompany];

}

- (void)loadProtocol {
    NSString *url = API_GET_COMPANY_PROTOCOL;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [arr addObject:[ProtocolModel modelWithDictionary:list[i]]];
            }
            _protocolArray = arr;
            [self makeUI];
            _navSureBtn.enabled = true;
        } else {
            [self showError:self.view message:@"获取协议失败，请重试" afterHidden:1.5];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerAsCompany {
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    
    NSString *companyUrl = companyWebset.text;
    if (![companyUrl isEqualToString:@""]) {
        if ([companyUrl containsString:@"http://"] || [companyUrl containsString:@"https://"]) {
            companyUrl = companyUrl;
        } else {
            companyUrl = [NSString stringWithFormat:@"http://%@",companyUrl];
        }
    }
    
    if ([GlobleFunction isIncludeEmoji:companyQulification.text]) {
        [self showError:self.view message:@"不能输入表情" afterHidden:3];
        return;
    }
    if ([GlobleFunction isIncludeEmoji:businessScope.text]) {
        [self showError:self.view message:@"不能输入表情" afterHidden:3];
        return;
    }
    if (companyQulification.text.length > DESP_MAX_LENGTH) {
        [self showError:self.view message:[NSString stringWithFormat:@"公司资质描述不能超过%d个字", DESP_MAX_LENGTH] afterHidden:3];
        return ;
    }
    if (businessScope.text.length > DESP_MAX_LENGTH) {
        [self showError:self.view message:[NSString stringWithFormat:@"公司经营范围不能超过%d个字", DESP_MAX_LENGTH] afterHidden:3];
        return ;
    }
    
    NSString *api = [NSString stringWithFormat:@"%@v1/regist/Manufacturer",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyEmail"] = managerEmail.text;
    params[@"companyName"] = companyName.text;
    params[@"companyTest"] = companyQulification.text;
    if (![companyUrl isEqualToString:@""]) {
        params[@"companyWebsite"] = companyUrl;
    }
    params[@"keeperName"] = managerName.text;
    params[@"scope"] = businessScope.text;
    params[@"registerMoney"] = registeredCapital.text;
    params[@"mobile"] = managerPhone.text;
    params[@"startTime"] = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00",year.text,month.text,day.text];
    params[@"userId"] = [UserModel sharedModel].userId;
    params[@"checkbox"] = _selectedBtn.isEnabled ? @"1": @"0";
    if (referrer.text != nil && ![referrer.text isEqualToString:@""]) {
        params[@"referee"] = referrer.text;
    }
    
    NSLog(@"%@", params);
    __weak typeof (self)selfVC = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //营业执照
        for (int i = 0;i < selfVC.photoVC.photos.count; ++i) {
            UIImage *img = [selfVC.photoVC.photos objectAtIndex:i];
            UIImage *image = [selfVC fixrotation:img];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:@"files" fileName:[NSString stringWithFormat: @"file%d.png",i]mimeType:@"image/jpeg"];
        }
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"赋值image:%@",[NSThread currentThread]);
            [self showLoadingToView:self.view];
        });
        NSLog(@"ceshi   %f", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success = %@", responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        //上传成功
        if (code == 1000) {
             [self hiddenLoading];
            [self showSuccess:self.view message:@"认证成功" afterHidden:3];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"personalInfoRefresh" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
           
        }else{
             [self hiddenLoading];
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self hiddenLoading];
        [self showError:self.view message:@"认证失败" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];
}

//获取用户资料
-(void)loadUserBaseInfoRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/getUsers?id=%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSLog(@"%@",url);
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        
        if (result != nil) {
            NSLog(@"succeed:msg:%@", result.getMessage);
            if(result.isSucceed){
                NSDictionary *dic = result.getDataObj;
                NSLog(@"%@",dic);
                dic = [NSDictionary changeType:dic];
                
                UserBaseInfoModel *model = [UserBaseInfoModel modelWithDictionary:dic];
                [model writeToLocal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMe" object:nil];
            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:3];
        }
    }];
}

- (void)makeUI {
    
    _navSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navSureBtn.frame = CGRectMake(15, SCREEN_HEIGHT, SCREEN_WIDTH-30, 40);
    [_navSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_navSureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_navSureBtn setTitleColor:[UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    _navSureBtn.backgroundColor = MainColor;
    _navSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_navSureBtn addTarget: self action: @selector(clickLeftItem) forControlEvents: UIControlEventTouchUpInside];
    _navSureBtn.clipsToBounds = true;
    _navSureBtn.layer.cornerRadius = 3;
    [self.view addSubview:_navSureBtn];
    [_navSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-LandscapeNumber(51)-60)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_navSureBtn.mas_top).offset(-10);
    }];
    
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"公司名称";
    label1.textColor = UIColorFromRGB(0x3D4245);
    label1.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(16);
        make.top.mas_equalTo(_scrollView.mas_top).with.offset(16);
    }];
    
    companyName = [self makeTextField];
    [_scrollView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
    UILabel *laber1 = [[UILabel alloc]init];
    laber1.text = @"成立时间";
    laber1.textColor = UIColorFromRGB(0x3D4245);
    laber1.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:laber1];
    [laber1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyName.mas_bottom).with.offset(10);
    }];
    
    year = [[UITextField alloc]init];
    year.textAlignment = NSTextAlignmentCenter;
    year.textColor = UIColorFromRGB(0x0F0F0F);
    year.font = [UIFont systemFontOfSize:16];
    year.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:year];
    [year mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(laber1.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 40));
    }];
    
    UIView *line7 = [[UIView alloc]init];
    line7.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line7];
    [line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(year.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 1));
    }];
    
    
    
    UILabel *laber2 = [[UILabel alloc]init];
    laber2.text = @"年";
    laber2.textAlignment = NSTextAlignmentCenter;
    laber2.textColor = UIColorFromRGB(0x333333);
    laber2.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:laber2];
    [laber2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(year.mas_right);
        make.bottom.mas_equalTo(year.mas_bottom);
        make.width.mas_equalTo(20);
    }];
    
    month = [[UITextField alloc]init];
    month.textAlignment = NSTextAlignmentCenter;
    month.textColor = UIColorFromRGB(0x0F0F0F);
    month.font = [UIFont systemFontOfSize:16];
    month.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:month];
    [month mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(laber2.mas_right);
        make.centerY.mas_equalTo(year.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 40));
    }];
    
    UIView *line8 = [[UIView alloc]init];
    line8.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line8];
    [line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(month.mas_left);
        make.top.mas_equalTo(month.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 1));
    }];
    
    UILabel *laber3 = [[UILabel alloc]init];
    laber3.text = @"月";
    laber3.textAlignment = NSTextAlignmentCenter;
    laber3.textColor = UIColorFromRGB(0x333333);
    laber3.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:laber3];
    [laber3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(month.mas_right);
        make.bottom.mas_equalTo(month.mas_bottom);
        make.width.mas_equalTo(20);
    }];
    
    day = [[UITextField alloc]init];
    day.textAlignment = NSTextAlignmentCenter;
    day.textColor = UIColorFromRGB(0x0F0F0F);
    day.font = [UIFont systemFontOfSize:16];
    day.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:day];
    [day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(laber3.mas_right);
        make.centerY.mas_equalTo(year.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 40));
    }];
    
    UIView *line9 = [[UIView alloc]init];
    line9.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line9];
    [line9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day.mas_left);
        make.top.mas_equalTo(day.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-92)/3, 1));
    }];
    
    UILabel *laber4 = [[UILabel alloc]init];
    laber4.text = @"日";
    laber4.textAlignment = NSTextAlignmentCenter;
    laber4.textColor = UIColorFromRGB(0x333333);
    laber4.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:laber4];
    [laber4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day.mas_right);
        make.bottom.mas_equalTo(day.mas_bottom);
        make.width.mas_equalTo(20);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"公司网站（例如：http://www.baidu.com）";
    label2.textColor = UIColorFromRGB(0x3D4245);
    label2.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(year.mas_bottom).with.offset(15);
    }];
    
    companyWebset = [self makeTextField];
    companyWebset.keyboardType = UIKeyboardTypeURL;
    companyWebset.placeholder = @"请输入（选填）";
    [_scrollView addSubview:companyWebset];
    [companyWebset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label2.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyWebset.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"公司邮箱";
    label3.textColor = UIColorFromRGB(0x3D4245);
    label3.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyWebset.mas_bottom).with.offset(10);
    }];
    
    managerEmail = [self makeTextField];
    managerEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [_scrollView addSubview:managerEmail];
    [managerEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label3.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerEmail.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"注册资金";
    label4.textColor = UIColorFromRGB(0x3D4245);
    label4.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerEmail.mas_bottom).with.offset(10);
    }];
    
    registeredCapital = [self makeTextField];
    registeredCapital.placeholder = @"单位（万元）";
    registeredCapital.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:registeredCapital];
    [registeredCapital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label4.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(registeredCapital.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"管理员姓名";
    label5.textColor = UIColorFromRGB(0x3D4245);
    label5.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(registeredCapital.mas_bottom).with.offset(10);
    }];
    
    managerName = [self makeTextField];
    [_scrollView addSubview:managerName];
    [managerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label5.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line5 = [[UIView alloc]init];
    line5.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"管理员手机";
    label6.textColor = UIColorFromRGB(0x3D4245);
    label6.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerName.mas_bottom).with.offset(10);
    }];
    
    managerPhone = [self makeTextField];
    managerPhone.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:managerPhone];
    [managerPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label6.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line6 = [[UIView alloc]init];
    line6.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line6];
    [line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerPhone.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label22 = [[UILabel alloc]init];
    label22.text = @"推荐人";
    label22.textColor = UIColorFromRGB(0x3D4245);
    label22.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label22];
    [label22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(managerPhone.mas_bottom).with.offset(10);
    }];
    
    referrer = [self makeTextField];
    referrer.placeholder = @"(选填)";
    [_scrollView addSubview:referrer];
    [referrer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label22.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line22 = [[UIView alloc]init];
    line22.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line22];
    [line22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(referrer.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"公司资质描述";
    label7.textColor = UIColorFromRGB(0x3D4245);
    label7.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(referrer.mas_bottom).with.offset(10);
    }];
    
    companyQulification = [[UITextView alloc]init];
    companyQulification.textColor = UIColorFromRGB(0x0F0F0F);
    companyQulification.font = [UIFont systemFontOfSize:16];
    companyQulification.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    companyQulification.layer.borderWidth = 1;
    [_scrollView addSubview:companyQulification];
    [companyQulification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label7.mas_bottom).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_greaterThanOrEqualTo(100);
    }];
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"公司经营范围";
    label8.textColor = UIColorFromRGB(0x3D4245);
    label8.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(companyQulification.mas_bottom).with.offset(10);
    }];
    
    businessScope = [[UITextView alloc]init];
    businessScope.textColor = UIColorFromRGB(0x0F0F0F);
    businessScope.font = [UIFont systemFontOfSize:16];
    businessScope.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    businessScope.layer.borderWidth = 1;
    [_scrollView addSubview:businessScope];
    [businessScope mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label8.mas_bottom).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_greaterThanOrEqualTo(100);
    }];
    
    
    UILabel *label9 = [[UILabel alloc]init];
    label9.text = @"营业执照副本扫描件";
    label9.textColor = UIColorFromRGB(0x3D4245);
    label9.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(businessScope.mas_bottom).with.offset(10);
    }];

    //照片选择
    UIView *photoView = [[UIView alloc] init];
    [self.scrollView addSubview:photoView];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 4;
    photoView.backgroundColor = UIColorFromRGB(0xECECEC);
    self.photoVC = [[SelectedImagesViewController alloc] init];
    self.photoVC.delegate = self;
    self.photoVC.photoCount = 1;
    [self addChildViewController:self.photoVC];
    [photoView addSubview:self.photoVC.view];
    [self.photoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_top);
        make.left.mas_equalTo(photoView.mas_left);
        make.right.mas_equalTo(photoView.mas_right);
        make.bottom.mas_equalTo(photoView.mas_bottom);
    }];
    
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label9.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - LandscapeNumber(32), ((self.photoVC.photos.count+1)/3+1)*270 - 5));
    }];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.selected = true;
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_normal"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_selected"] forState:UIControlStateSelected];
    [_selectedBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selectedBtn];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(photoView.mas_bottom).offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-70);
    }];
    
    UILabel *protocolTextLabel = [[UILabel alloc] init];
    protocolTextLabel.textColor = UIColorFromRGB(0x999999);
    protocolTextLabel.font = [UIFont systemFontOfSize:13];
    protocolTextLabel.text = @"我已阅读并同意相关服务条款和隐私政策";
    [_scrollView addSubview:protocolTextLabel];
    [protocolTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectedBtn.mas_right);
        make.centerY.mas_equalTo(_selectedBtn.mas_centerY);
    }];
    
    _unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unfoldBtn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [_unfoldBtn setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateSelected];
    [_unfoldBtn addTarget:self action:@selector(clickUnfoldBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_unfoldBtn];
    [_unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(protocolTextLabel.mas_right);
        make.centerY.mas_equalTo(_selectedBtn.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
  
}

- (void)clickSelectedBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
//    _navSureBtn.enabled = btn.isSelected;
}

- (void)clickUnfoldBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [_scrollView addSubview:self.protocolView];
        [_protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_unfoldBtn.mas_bottom);
            make.centerX.mas_equalTo(_unfoldBtn.mas_centerX);
        }];
    } else {
        [_protocolView removeFromSuperview];
    }
}

- (void)clickProtocolBtn:(UIButton *)btn {
    ProtocolModel *model = _protocolArray[btn.tag];
    ProtocolPDFViewController *vc = [[ProtocolPDFViewController alloc] init];
    vc.loadURLString = model.protocolPdf;
    vc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (UIView *)protocolView {
    if (!_protocolView) {
        _protocolView = [[UIView alloc] init];
        
        for (NSUInteger i = 0; i < _protocolArray.count; i++) {
            ProtocolModel *model = _protocolArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:model.protocolName forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_protocolView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(i*30);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(30);
                if (i == _protocolArray.count-1) {
                    make.bottom.mas_equalTo(0);
                }
            }];
        }
        
    }
    return _protocolView;
}

- (UITextField *)makeTextField {
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"请输入";
    textField.textColor = UIColorFromRGB(0x0F0F0F);
    textField.font = [UIFont systemFontOfSize:16];
    
    return textField;
}

-(void)reloadUI{
    
    [self.scrollView reloadInputViews];
}

//- (void)clickNextBtn {
//    if ([self.OrganizationCodeTextField.text isEqualToString:@""]) {
//        [self showError:self.view message:@"组织机构代码不能为空" afterHidden:3];
//        return;
//    }
//    if ([self.BusinessLicenseTextField.text isEqualToString:@""]) {
//        [self showError:self.view message:@"营业执照号不能为空" afterHidden:3];
//        return;
//    }
//    
//    [self sendDispatchInfoToServer];
//}
//
//-(void)sendDispatchInfoToServer {
//    
//    __weak ManufacturerInfoViewController *selfVC = self;
//    
//    NSString *url = [NSString stringWithFormat:@"%@v1/user/manufacturer",DOMAIN_NAME];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"accountId"] = [UserBaseInfoModel sharedModel].id;//用户id
//    params[@"id"] = [UserBaseInfoModel sharedModel].id;//评论人id,修改传，添加不传
//    params[@"licenseNo"] = self.BusinessLicenseTextField.text;//营业执号
//    params[@"organizationCode"] = self.OrganizationCodeTextField.text;//组织机构代码
//    
//    NSLog(@"%@ <<<<<<-------->>>>>> %@",params,url);
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        for (UIImage *img in selfVC.photoVC.photos) {
//        UIImage *image = [selfVC fixrotation:img];
//        NSData* data = UIImageJPEGRepresentation(image, 0.5);
//        [formData appendPartWithFileData:data name:@"file" fileName: @"file1.png"mimeType:@"image/jpeg"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"赋值image:%@",[NSThread currentThread]);
//        });
//        
//        
//        NSLog(@"ceshi   %f", progress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"Success = %@", responseObject);
//        
//        int code = [[responseObject objectForKey:@"code"] intValue];
//        //上传成功
//        if (code == 1000) {
//            [self loadingSubtractCount];
//            [self showSuccess:self.view message:@"上传成功" afterHidden:3];
//            NSLog(@"全部上传成功了");
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"AuthSuccess" object:nil];
//            
//            UIViewController *getVC = nil;
//            for (UIViewController *vc in self.navigationController.viewControllers) {
//                NSLog(@"%@",vc);
//                
//                if ([vc isKindOfClass:[MeMainViewController class]]) {
//                    getVC = vc;
//                    break;
//                }
//            }
//            
//            if (getVC) {
//                [self.navigationController popToViewController:getVC animated:YES];
//            }
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self loadingSubtractCount];
//        [self showError:self.view message:@"上传失败" afterHidden:3];
//        NSLog(@"Failure %@", error.description);
//    }];
//    
//    
//    
//    
//}
//上传服务器时，设置图片都是竖直方向
- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

@end
