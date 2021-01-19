//
//  TechnicallyLiterateInfoViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "TechnicallyLiterateInfoViewController.h"
#import "AFNetworking.h"
#import "MeMainViewController.h"

@interface TechnicallyLiterateInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *authIDTextField;
@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation TechnicallyLiterateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技术达人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, NAVBARHEIGHT+STATUSBARHEIGHT+16, 100, 20)];
    label1.text = @"身份证号码";
    label1.textColor = UIColorFromRGB(0x3D4245);
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    
    self.authIDTextField = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(label1.frame) + 10, SCREEN_WIDTH-32, 44)];
    self.authIDTextField.placeholder = @"请输入";
    self.authIDTextField.delegate = self;
    self.authIDTextField.tag = 1;
    self.authIDTextField.textColor = UIColorFromRGB(0x0F0F0F);
    self.authIDTextField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.authIDTextField];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.authIDTextField.frame)+10, SCREEN_WIDTH, 1)];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:line1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(line1.frame)+16, 60, 20)];
    label2.text = @"姓名";
    label2.textColor = UIColorFromRGB(0x3D4245);
    label2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
    
    
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(label2.frame) + 10, SCREEN_WIDTH-32, 44)];
    self.nameTextField.placeholder = @"请输入";
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 2;
    self.nameTextField.textColor = UIColorFromRGB(0x0F0F0F);
    self.nameTextField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.nameTextField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameTextField.frame)+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:line2];
    
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-51, SCREEN_WIDTH, 51)];
    nextBtn.backgroundColor = UIColorFromRGB(0xD71629);
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

    
    
}
//点击 完成
- (void)clickNextBtn {
    
    if (![self verifyIDCardNumber:self.authIDTextField.text]) {
        [self showError:self.view message:@"身份证号有误" afterHidden:3];
        return;
    }
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self showError:self.view message:@"姓名不能为空" afterHidden:3];
        return;
    }
    
    [self sendUpLoad];
    
    
    
}

- (void)sendUpLoad {
    
//    NSString *url = @"http://192.168.1.10:8083/v1/user/talent";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"id"] =
    params[@"realName"] = self.nameTextField.text;
    params[@"idCard"] = self.authIDTextField.text;
    params[@"accountId"] = [UserBaseInfoModel sharedModel].id;

    NSLog(@"%@",params);
    
    [[AINetworkEngine sharedClient] postWithApi:API_POST_AUTH parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"上传成功");
                [self showSuccess:self.view message:@"认证成功" afterHidden:4];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AuthSuccess" object:nil];
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
            }else {
                NSLog(@"....%@",error);
            }
        } else {
            NSLog(@"请求失败 %@",error);
        }
        
    }];
    
    
}

- (BOOL)verifyIDCardNumber:(NSString *)IDCardNumber {
    IDCardNumber = [IDCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([IDCardNumber length] != 18)
    {
        
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![regexTest evaluateWithObject:IDCardNumber]){
        return NO;
    }
    int summary = ([IDCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7+ ([IDCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9+ ([IDCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10+ ([IDCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5+ ([IDCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8+ ([IDCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4+ ([IDCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [IDCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2+ [IDCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [IDCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6+ [IDCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];
    // 判断校验位return [checkBit isEqualToString:[[IDCardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    return YES;
}

- (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int length =0;
    if (!value) {
        [self showError:self.view message:@"身份证号不能为空" afterHidden:3];
        return NO;
    }else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    //判断身份证前两位
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    if (!areaFlag) {
        [self showError:self.view message:@"身份证号有误" afterHidden:3];
        return false;
    }
        NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
                
            }else { regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"  options:NSRegularExpressionCaseInsensitive  error:nil];//测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                [self showError:self.view message:@"身份证号有误" afterHidden:3];
                return NO;
            }
            
        case18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"  options:NSRegularExpressionCaseInsensitive  error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"  options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    [self showError:self.view message:@"身份证号有误" afterHidden:3];
                    return NO;
                }
            }else {
                [self showError:self.view message:@"身份证号有误" afterHidden:3];
                return NO;
            }
            
        default:
            [self showError:self.view message:@"身份证号有误" afterHidden:3];
            return false;
    }
    
}


@end
