//
//  TechnicianDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/25.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "TechnicianDetailsViewController.h"
#import "ChooseButton.h"
#import "NSString+CustomString.h"
#import "SelectedImagesViewController.h"
#import "PickerChoiceView.h"
#import "MeMainViewController.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"

#define DESP_MAX_LENGTH 300

@interface TechnicianDetailsViewController ()<SelectedImagesViewControllerDelegate,TFPickerDelegate>
{
    UITextField *realName;
    UITextField *email;
    UITextField *age;
    UITextField *referrer;
    
    ChooseButton *provinceBtn;
    ChooseButton *cityBtn;
    ChooseButton *regionBtn;
    UIButton *maleBtn;
    UIButton *femaleBtn;
    
    NSString *province;
    NSString *city;
    NSString *region;
    
    UITextField *jogAge;
    UITextView *charactoRistic;//专业特长
    UITextView *introduce;
    
    PickerChoiceView *picker;

    NSString *provinceName;
    NSString *cityName;
    NSString *regionName;
    
    int sex;//1男 2女
    
    UIButton    *_navSureBtn;
    UIButton    *_unfoldBtn;
    NSArray     *_protocolArray;
    UIButton    *_selectedBtn;
  
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic, strong) SelectedImagesViewController *photoVC;
@property(nonatomic, strong) SelectedImagesViewController *identifierVC;
@property(nonatomic, strong) SelectedImagesViewController *shouchiVC;
@property(nonatomic,assign)int type;

@property (nonatomic,assign) NSInteger selectedProvinceId;//被选择的id（省份、城市、区）
@property (nonatomic,assign) NSInteger selectedCityId;
@property (nonatomic,assign) NSInteger selectedRegionId;

@property(nonatomic,strong)NSMutableArray *cityArr;
@property(nonatomic,strong)NSMutableArray *provinceArr;
@property(nonatomic,strong)NSMutableArray *regionArr;
@property (strong, nonatomic) UIView *protocolView;
@end

@implementation TechnicianDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sex = 0;
    self.navigationItem.title = @"技术达人认证";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self makeUI];

    
    [self loadProtocol];
}

- (void)loadProtocol {
    NSString *url = API_GET_TANLENT_PROTOCOL;
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

- (void)clickLeftItem {
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    if ([GlobleFunction isIncludeEmoji:charactoRistic.text]) {
        [self showError:self.view message:@"不能输入表情" afterHidden:3];
        return;
    }
    if ([GlobleFunction isIncludeEmoji:introduce.text]) {
        [self showError:self.view message:@"不能输入表情" afterHidden:3];
        return;
    }
    if (charactoRistic.text.length > DESP_MAX_LENGTH) {
        [self showError:self.view message:[NSString stringWithFormat:@"专业特长不能超过%d个字", DESP_MAX_LENGTH] afterHidden:3];
        return ;
    }
    if (introduce.text.length > DESP_MAX_LENGTH) {
        [self showError:self.view message:[NSString stringWithFormat:@"个人简介不能超过%d个字", DESP_MAX_LENGTH] afterHidden:3];
        return ;
    }
    
    if (realName.text.length == 0) {
        [self showError:self.view message:@"真实姓名不能为空" afterHidden:2];
        return;
    }else if (age.text.length == 0) {
        [self showError:self.view message:@"年龄不能为空" afterHidden:2];
        return;
    }else if (provinceName.length == 0) {
        [self showError:self.view message:@"省份不能为空" afterHidden:2];
        return;
    }else if (cityName.length == 0) {
        [self showError:self.view message:@"城市不能为空" afterHidden:2];
        return;
    }else if (regionName.length == 0) {
        [self showError:self.view message:@"区/县不能为空" afterHidden:2];
        return;
    }else if (introduce.text.length == 0) {
        [self showError:self.view message:@"个人简介不能为空" afterHidden:2];
        return;
    }else if (email.text.length == 0) {
        [self showError:self.view message:@"邮箱不能为空" afterHidden:2];
        return;
    }
    else if (jogAge.text.length == 0) {
        [self showError:self.view message:@"工作年限不能为空" afterHidden:2];
        return;
    }else if (charactoRistic.text.length == 0) {
        [self showError:self.view message:@"专业特长不能为空" afterHidden:2];
        return;
    }else if(sex == 0) {
        [self showError:self.view message:@"请选择性别" afterHidden:2];
        return;
    }else if(self.photoVC.photos.count == 0) {
        [self showError:self.view message:@"请上传身份证照片" afterHidden:2];
        return;
    }else if(self.shouchiVC.photos.count == 0) {
        [self showError:self.view message:@"请上传手持身份证照片" afterHidden:2];
        return;
    }else if(self.identifierVC.photos.count == 0) {
        [self showError:self.view message:@"请上传资质证书" afterHidden:2];
        return;
    } else if (!_selectedBtn.isSelected) {
        [self showError:self.view message:@"必须同意相关服务条款和隐私政策" afterHidden:2];
        return;
    }
    
    

    //上传用户个人信息
    [self registerAsAnTalent];
//    [self uploadQulificationImage];
//    [self uploadIDCardImage];
}
- (void)registerAsAnTalent {
    
//    NSString *api = [NSString stringWithFormat:@"%@v1/regist/talent",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,regionName];
    params[@"realName"] = realName.text;
    params[@"age"] = age.text;
    params[@"desp"] = introduce.text;
    params[@"email"] = email.text;
    params[@"jobAge"] = jogAge.text;
    params[@"majorThey"] = charactoRistic.text;
    params[@"sex"] = [NSString stringWithFormat:@"%d",sex];
    params[@"userId"] = [UserModel sharedModel].userId;
    params[@"checkbox"] = _selectedBtn.isEnabled ? @"1": @"0";
    if (referrer.text != nil && ![referrer.text isEqualToString:@""]) {
        params[@"referee"] = referrer.text;
    }
    
    NSLog(@"参数 ------> %@",params);
    [self uploadQulificationImageWithParams:params];
    

    
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoRefresh" object:nil];
                
//                [self uploadIDCardImage];

            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:3];
        }
        
    }];
}

#pragma -mark 上传用户信息  身份证  资质证书
- (void)uploadQulificationImageWithParams:(NSDictionary *)params{
    
    __weak typeof (self)selfVC = self;
    if (selfVC.photoVC.photos.count < 2){
        [self showError:self.view message:@"身份证必须上传正反面照片" afterHidden:2];
        return;
    }
    
    
//    NSString *api = [NSString stringWithFormat:@"%@v1/regist/uploadQcimages/%@",DOMAIN_NAME,[UserModel sharedModel].userId];
    NSString *api = [NSString stringWithFormat:@"%@v1/regist/talent",DOMAIN_NAME];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0;i < self.identifierVC.photos.count;++i) {
            UIImage *img  =  [selfVC.identifierVC.photos objectAtIndex:i];
            
            UIImage *image = [selfVC fixrotation:img];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:@"files" fileName: [NSString stringWithFormat:@"file%d.png",i+1]mimeType:@"image/jpeg"];
        }
        
        for (int i = 0;i < selfVC.photoVC.photos.count;++i) {
            UIImage *img  =  [selfVC.photoVC.photos objectAtIndex:i];
            
            UIImage *image = [selfVC fixrotation:img];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%d",i+1] fileName: [NSString stringWithFormat:@"file%d.png",i+1]mimeType:@"image/jpeg"];
        }
        for (int i = 0;i < selfVC.shouchiVC.photos.count;++i) {
            UIImage *img  =  [selfVC.shouchiVC.photos objectAtIndex:i];
            
            UIImage *image = [selfVC fixrotation:img];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file3"] fileName: [NSString stringWithFormat:@"file%d.png",i+1]mimeType:@"image/jpeg"];
        }
        
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }];
        
        
//        for (UIImage *img in selfVC.identifierVC.photos) {
//            UIImage *image = [selfVC fixrotation:img];
//            NSData* data = UIImageJPEGRepresentation(image, 0.5);
//            [formData appendPartWithFileData:data name:@"files" fileName: @"file1.png"mimeType:@"image/jpeg"];
//        }
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
            [self loadUserBaseInfoRequest];
            [self hiddenLoading];
            
//            [self showSuccess:self.view message:@"认证成功" afterHidden:3];
            [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"认证成功" afterHidden:4];
           
            [[NSNotificationCenter defaultCenter]postNotificationName:@"personalInfoRefresh" object:nil];
            
            UIViewController *getVC = nil;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                NSLog(@"%@",vc);
                
                if ([vc isKindOfClass:[MeMainViewController class]]) {
                    getVC = vc;
                    break;
                }
            }
            
            if (getVC) {
                [self.navigationController popToViewController:getVC animated:YES];
            }
            
        }else{
              [self hiddenLoading];
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self hiddenLoading];
        [self showError:self.view message:@"网络错误" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    UserBaseInfoModel *model= [UserBaseInfoModel sharedModel];
    
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
    
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_navSureBtn.mas_top).offset(-10);
    }];
    
//    NSString *str = @"真实姓名：";
//    CGFloat width = [str getWidthWithContent:str height:18 font:16];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"真实姓名";
    label1.textColor = UIColorFromRGB(0x3D4245);
    label1.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(16);
        make.top.mas_equalTo(_scrollView.mas_top).with.offset(15);
    }];
    
    realName = [[UITextField alloc]init];
    realName.placeholder = @"请输入...";
    realName.text = model.realName;
    realName.keyboardType = UIKeyboardTypeDefault;
    realName.textColor = UIColorFromRGB(0x0F0F0F);
    realName.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:realName];
    [realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(realName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
//    NSString *ageStr = @"年龄：";
//    CGFloat ageWidth = [str getWidthWithContent:ageStr height:18 font:16];
    
    UILabel *labelage = [[UILabel alloc]init];
    labelage.text = @"年龄";
    labelage.textColor = UIColorFromRGB(0x3D4245);
    labelage.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:labelage];
    [labelage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(16);
        make.top.mas_equalTo(realName.mas_bottom).with.offset(15);
    }];
    
    age = [[UITextField alloc]init];
    age.placeholder = @"请输入...";
    age.text = [NSString stringWithFormat:@"%@",model.age ? model.age: @""];
    age.keyboardType = UIKeyboardTypeDecimalPad;
    age.textColor = UIColorFromRGB(0x0F0F0F);
    age.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:age];
    [age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelage.mas_left);
        make.top.mas_equalTo(labelage.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *lineage = [[UIView alloc]init];
    lineage.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:lineage];
    [lineage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineage.mas_left);
        make.top.mas_equalTo(realName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
    
    
   
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"邮箱地址";
    label5.textColor = UIColorFromRGB(0x3D4245);
    label5.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(age.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    email = [[UITextField alloc]init];
    email.placeholder = @"请输入...";
    email.text = model.email;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.textColor = [UIColor darkGrayColor];
    email.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:email];
    [email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label5.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(email.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"工作年限";
    label6.textColor = UIColorFromRGB(0x3D4245);
    label6.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(email.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    jogAge = [[UITextField alloc]init];
    jogAge.placeholder = @"年";
    jogAge.text = model.jobAge;
    jogAge.keyboardType = UIKeyboardTypeDecimalPad;
    jogAge.textColor = UIColorFromRGB(0x0F0F0F);
    jogAge.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:jogAge];
    [jogAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label6.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 40));
    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = UIColorFromRGB(0xECECEC);
    [_scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(jogAge.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-32, 1));
    }];
    
    UILabel *label22 = [[UILabel alloc]init];
    label22.text = @"推荐人";
    label22.textColor = UIColorFromRGB(0x3D4245);
    label22.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label22];
    [label22 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jogAge.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    referrer = [[UITextField alloc]init];
    referrer.placeholder = @"(选填)";
    referrer.textColor = UIColorFromRGB(0x0F0F0F);
    referrer.font = [UIFont systemFontOfSize:16];
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
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"性别";
    label2.textColor = UIColorFromRGB(0x3D4245);
    label2.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line22.mas_bottom).with.offset(20);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    maleBtn = [[UIButton alloc]init];
    maleBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    maleBtn.layer.borderWidth = 1;
    maleBtn.layer.masksToBounds = YES;
    maleBtn.layer.cornerRadius = 4;
    [maleBtn addTarget:self action:@selector(chooseMale:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:maleBtn];
    [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).with.offset(15);
        make.centerY.mas_equalTo(label2.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"男";
    label3.textColor = UIColorFromRGB(0x3D4245);
    label3.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(maleBtn.mas_centerY);
        make.left.mas_equalTo(maleBtn.mas_right).with.offset(10);
    }];
    
    femaleBtn = [[UIButton alloc]init];
    femaleBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    femaleBtn.layer.borderWidth = 1;
    femaleBtn.layer.masksToBounds = YES;
    femaleBtn.layer.cornerRadius = 4;
    [femaleBtn setImage:[UIImage imageNamed:@"maleBtn"] forState:UIControlStateSelected];
    [femaleBtn addTarget:self action:@selector(chooseFemale:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:femaleBtn];
    [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).with.offset(15);
        make.centerY.mas_equalTo(label3.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"女";
    label4.textColor = UIColorFromRGB(0x3D4245);
    label4.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(femaleBtn.mas_centerY);
        make.left.mas_equalTo(femaleBtn.mas_right).with.offset(10);
    }];
    
    if ([model.sex intValue] == 1) {
           maleBtn.selected = YES;
        femaleBtn.selected = NO;
        [maleBtn setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
    }else if([model.sex intValue] == 2){
        maleBtn.selected = NO;
         femaleBtn.selected = YES;
        [femaleBtn setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
    }
 
    
    
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"工作地点";
    label8.textColor = UIColorFromRGB(0x333333);
    label8.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(maleBtn.mas_bottom).with.offset(18);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    
    provinceBtn = [[ChooseButton alloc]init];
    [provinceBtn addTarget:self action:@selector(chooseProvince:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:provinceBtn];
    [provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label8.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-60)/2, 40));
    }];
    
    UILabel *provinceLabel = [[UILabel alloc]init];
    provinceLabel.text = @"省";
    provinceLabel.textAlignment = NSTextAlignmentCenter;
    provinceLabel.textColor = UIColorFromRGB(0x666666);
    provinceLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:provinceLabel];
    [provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(provinceBtn.mas_centerY);
        make.left.mas_equalTo(provinceBtn.mas_right);
        make.width.mas_equalTo(20);
    }];
    
    cityBtn = [[ChooseButton alloc]init];
    [cityBtn addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:cityBtn];
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(provinceLabel.mas_right);
        make.centerY.mas_equalTo(provinceBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-60)/2, 40));
    }];
    
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"市";
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.textColor = UIColorFromRGB(0x666666);
    cityLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cityBtn.mas_centerY);
        make.left.mas_equalTo(cityBtn.mas_right);
        make.width.mas_equalTo(20);
    }];
    
    regionBtn = [[ChooseButton alloc]init];
    [regionBtn addTarget:self action:@selector(chooseRegion:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:regionBtn];
    [regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(provinceBtn.mas_left);
        make.top.mas_equalTo(provinceBtn.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-60)/2, 40));
    }];
    
    UILabel *regionLabel = [[UILabel alloc]init];
    regionLabel.text = @"区/县";
    regionLabel.textAlignment = NSTextAlignmentCenter;
    regionLabel.textColor = UIColorFromRGB(0x666666);
    regionLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:regionLabel];
    [regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(regionBtn.mas_centerY);
        make.left.mas_equalTo(regionBtn.mas_right);
        make.width.mas_equalTo(40);
    }];
    

    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"专业特长：";
    label7.textColor = UIColorFromRGB(0x333333);
    label7.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(regionBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    

    charactoRistic = [[UITextView alloc]init];
    charactoRistic.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    charactoRistic.layer.borderWidth = 1;
    charactoRistic.text = model.majorThey;
    charactoRistic.textColor = [UIColor darkGrayColor];
    charactoRistic.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:charactoRistic];
    [charactoRistic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label7.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 80));
    }];

    
    UILabel *label9 = [[UILabel alloc]init];
    label9.text = @"个人简介：";
    label9.textColor = UIColorFromRGB(0x333333);
    label9.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(charactoRistic.mas_bottom).with.offset(20);
        make.left.mas_equalTo(label1.mas_left);
    }];

    
    introduce = [[UITextView alloc]init];
    introduce.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    introduce.layer.borderWidth = 1;
    introduce.text = model.desp;
    introduce.textColor = [UIColor darkGrayColor];
    introduce.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:introduce];
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label9.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 80));
    }];

    UILabel *label10 = [[UILabel alloc]init];
    label10.text = @"上传身份证正反面照片";
    label10.textColor = UIColorFromRGB(0x333333);
    label10.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label10];
    [label10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(introduce.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    
    //照片选择
    UIView *photoView = [[UIView alloc] init];
    [_scrollView addSubview:photoView];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 4;
//    photoView.backgroundColor = [UIColor clearColor];
    photoView.backgroundColor = UIColorFromRGB(0xECECEC);//[UIColor yellowColor];
    self.photoVC = [[SelectedImagesViewController alloc] init];
    self.photoVC.delegate = self;
    self.photoVC.photoCount = 2;
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
        make.top.mas_equalTo(label10.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - LandscapeNumber(20), ((self.photoVC.photos.count+1)/3+1)*270 - 5));
        make.height.mas_greaterThanOrEqualTo(150);
//        make.bottom.mas_equalTo(self.scrollView.mas_bottom).with.offset(-16);
        
    }];
    
    
    
    UILabel *label11 = [[UILabel alloc]init];
    label11.text = @"手持身份证照片";
    label11.textColor = UIColorFromRGB(0x333333);
    label11.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label11];
    [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    
    //照片选择
    UIView *photoView1 = [[UIView alloc] init];
    [_scrollView addSubview:photoView1];
    photoView1.layer.masksToBounds = YES;
    photoView1.layer.cornerRadius = 4;
    //    photoView.backgroundColor = [UIColor clearColor];
    photoView1.backgroundColor = UIColorFromRGB(0xECECEC);//[UIColor yellowColor];
    self.shouchiVC = [[SelectedImagesViewController alloc] init];
    self.shouchiVC.delegate = self;
    self.shouchiVC.photoCount = 1;
    [self addChildViewController:self.shouchiVC];
    [photoView1 addSubview:self.shouchiVC.view];
    [self.shouchiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView1.mas_top);
        make.left.mas_equalTo(photoView1.mas_left);
        make.right.mas_equalTo(photoView1.mas_right);
        make.bottom.mas_equalTo(photoView1.mas_bottom);
    }];
    
    
    [photoView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label11.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - LandscapeNumber(20), ((self.shouchiVC.photos.count+1)/3+1)*270 - 5));
        make.height.mas_greaterThanOrEqualTo(150);
        //        make.bottom.mas_equalTo(self.scrollView.mas_bottom).with.offset(-16);
        
    }];
    
    
    
   

   
    UILabel *label12 = [[UILabel alloc]init];
    label12.text = @"上传职业资质证书照片";
    label12.textColor = UIColorFromRGB(0x333333);
    label12.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label12];
    [label12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView1.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    //照片选择
    UIView *pictureView = [[UIView alloc] init];
    [_scrollView addSubview:pictureView];
    pictureView.layer.masksToBounds = YES;
    pictureView.layer.cornerRadius = 4;
//    pictureView.backgroundColor = [UIColor clearColor];
    pictureView.backgroundColor = UIColorFromRGB(0xECECEC);//[UIColor blueColor];
    self.identifierVC = [[SelectedImagesViewController alloc] init];
    self.identifierVC.delegate = self;
    self.identifierVC.photoCount = 1000;
    [self addChildViewController:self.identifierVC];
    [pictureView addSubview:self.identifierVC.view];
    [self.identifierVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pictureView.mas_top);
        make.left.mas_equalTo(pictureView.mas_left);
        make.right.mas_equalTo(pictureView.mas_right);
        make.bottom.mas_equalTo(pictureView.mas_bottom);
    }];
    
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label12.mas_bottom).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - LandscapeNumber(20), ((self.identifierVC.photos.count+1)/3+1)*270 - 5));
        make.width.mas_equalTo(SCREEN_WIDTH - LandscapeNumber(20));
        make.height.mas_greaterThanOrEqualTo(((self.identifierVC.photos.count+1)/3+1)*270 - 5);
        
        
//        make.bottom.mas_equalTo(-100);
    }];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.selected = true;
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_normal"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_selected"] forState:UIControlStateSelected];
    [_selectedBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selectedBtn];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(pictureView.mas_bottom).offset(15);
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
                              
- (void)chooseMale:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        femaleBtn.selected = NO;
        sex = 1;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];

    }
                                  

 }
- (void)chooseFemale:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        maleBtn.selected = NO;
        sex = 2;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
        
    }
    
}


-(void)reloadUI{
    
    CGRect frame = self.identifierVC.view.frame;
    frame.size.height = 10+((self.identifierVC.photos.count+1)/3+1)*270;
    self.identifierVC.view.frame = frame;
    
    
    [self.scrollView reloadInputViews];
}
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

//选择省份
- (void)chooseProvince :(UIButton *)sender{
    [cityBtn setTitle:@"" forState:UIControlStateNormal];
    [regionBtn setTitle:@"" forState:UIControlStateNormal];
    
    NSString *api = @"v1/dict/province";
    [[AINetworkEngine sharedClient] getWithApi:api parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSMutableArray *nameArr = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    ProvinceModel  *model = [ProvinceModel modelWithDictionary:ads[i]];
                    [list addObject:model.id];
                    [nameArr addObject:model.name];
                    
                }
                _provinceArr = list;
                picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
                picker.delegate = self;
                picker.selectLb.text = @"选择省份";
                picker.customArr = [nameArr mutableCopy];
                [self.view addSubview:picker];
                self.type = 4;
                
            } else {
                
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
    
}

- (void)chooseCity:(UIButton *)sender {
    [regionBtn setTitle:@"" forState:UIControlStateNormal];
    
    NSString *api = [NSString stringWithFormat:@"v1/dict/province/%ld",(long)self.selectedProvinceId];
    [[AINetworkEngine sharedClient] getWithApi:api parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                NSMutableArray *nameArr = [NSMutableArray array];
                for (int i = 0; i < ads.count; i++) {
                    CityModel  *model = [CityModel modelWithDictionary:ads[i]];
                    [list addObject:model.id];
                    [nameArr addObject:model.name];
                    
                }
                _cityArr = list;
                picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
                picker.delegate = self;
                [self.view addSubview:picker];
                picker.customArr = [NSArray arrayWithArray:nameArr];
                picker.selectLb.text = @"选择城市";
                
                self.type = 5;
                
            } else {
                
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}
- (void)chooseRegion:(UIButton *)sender {
    NSString *api = [NSString stringWithFormat:@"v1/dict/city/%ld",(long)self.selectedCityId];
    [[AINetworkEngine sharedClient] getWithApi:api parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                NSMutableArray *nameArr = [NSMutableArray array];
                for (int i = 0; i < ads.count; i++) {
                    RegionModel  *model = [RegionModel modelWithDictionary:ads[i]];
                    [list addObject:model.id];
                    [nameArr addObject:model.name];
                    
                }
                _regionArr = list;
                picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
                picker.delegate = self;
                picker.customArr = [nameArr mutableCopy];
                picker.selectLb.text = @"选择区/县";
                [self.view addSubview:picker];
                self.type = 6;
                
            } else {
                
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];
}



#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str AndIndex:(NSInteger)index{
    
    NSLog(@"下标下标 == %ld",(long)index);
    
   if(self.type == 4) {
        NSLog(@"被选择的省份 == %@",str);
       provinceName = str;
       self.selectedProvinceId = [[_provinceArr objectAtIndex:index] integerValue];
       NSLog(@"被选择的省份id == %ld",(long)self.selectedProvinceId);
        [provinceBtn setTitle:str forState:UIControlStateNormal];
    }else if(self.type == 5) {
        cityName = str;
        self.selectedCityId = [[_cityArr objectAtIndex:index] integerValue];
        NSLog(@"被选择的城市id == %ld",(long)self.selectedCityId);
        NSLog(@"被选择的城市 == %@",str);
        [cityBtn setTitle:str forState:UIControlStateNormal];
    }else if(self.type == 6) {
        regionName = str;
        self.selectedRegionId = [[_regionArr objectAtIndex:index] integerValue];
        NSLog(@"被选择的区/县id == %ld",(long)self.selectedRegionId);
        NSLog(@"被选择的区/县 == %@",str);
        [regionBtn setTitle:str forState:UIControlStateNormal];
    }
}




@end

