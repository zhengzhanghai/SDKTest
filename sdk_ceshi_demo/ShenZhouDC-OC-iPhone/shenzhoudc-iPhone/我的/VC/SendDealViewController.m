//
//  SendDealViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "SendDealViewController.h"
#import "PickerChoiceView.h"
#import "CCDatePickerView.h"
#import "ChooseButton.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "RegionModel.h"
#import "SelectedImagesViewController.h"
#import "ProtocolModel.h"
#import "ProtocolPDFViewController.h"
@interface SendDealViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,TFPickerDelegate,SelectedImagesViewControllerDelegate>
{
    ChooseButton *businessBtn;
    NSUInteger businessType;
    ChooseButton *techBtn;
    NSUInteger techType;
    ChooseButton *isOverTimeBtn;
    NSUInteger isOverType;
//    UITextField *dayBtn;//服务时间，最短4个小时，最长一个月
//    UITextField *hourBtn;
    NSArray *pickArray;//外层
    ChooseButton *province;
    ChooseButton *city;
    ChooseButton *region;
    
    ChooseButton *startTime;//开工时间
    
    NSInteger selectIndex;//picker被选择的那个
    PickerChoiceView *picker;
    
    NSString *endtimeStr;
    NSString *startimeStr;
    
    UIButton *maleBtn;
    UIButton *femaleBtn;
    
    int nightAdd; //是否晚上加班 2否 1是
    int weekendAdd;//是否周末加班
    
    NSDate *startDate;//记录选择的开工时间
    
    UIButton *_unfoldBtn;
    NSArray *_protocolArray;
    UIButton *_sendBtn;
    UIButton *_selectedBtn;
    
}
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,assign) int type;//区分几个选择按钮
@property(nonatomic,strong)ChooseButton *needDays;
@property(nonatomic,strong)UITextField *price;
@property(nonatomic,strong)UITextView *memo;
@property(nonatomic,strong)UITextView *serviceDetail;
@property(nonatomic,strong)UITextView *status;
@property(nonatomic,strong)UITextField *mechineNum;

@property(nonatomic,strong)NSMutableArray *cityArr;
@property(nonatomic,strong)NSMutableArray *provinceArr;
@property(nonatomic,strong)NSMutableArray *regionArr;

@property(nonatomic,strong)NSMutableArray *provinceName;
@property(nonatomic,strong)NSMutableArray *cityName;
@property(nonatomic,strong)NSMutableArray *regionName;

@property(nonatomic,strong)ProvinceModel *provinceModel;
@property(nonatomic,strong)CityModel *cityModel;
@property(nonatomic,strong)RegionModel *regionModel;

@property (nonatomic,assign) NSInteger selectedProvinceId;//被选择的id（省份、城市、区）
@property (nonatomic,assign) NSInteger selectedCityId;
@property (nonatomic,assign) NSInteger selectedRegionId;
@property(nonatomic, strong) SelectedImagesViewController *identifierVC;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *protocolView;

@end

@implementation SendDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    businessType = 0;
    nightAdd = 2;
    weekendAdd = 2;
    techType = 0;
    isOverType = 99;
    
    
    _provinceArr = [NSMutableArray array];
    _cityArr = [NSMutableArray array];
    _regionArr = [NSMutableArray array];
    
    self.navigationItem.title = @"派工";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self makeUI];
    [self loadProtocol];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadProtocol {
    NSString *url = API_GET_PAIGONG_PROTOCOL;
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSArray *list = result.getDataObj;
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSUInteger i = 0; i < list.count; i++) {
                [arr addObject:[ProtocolModel modelWithDictionary:list[i]]];
            }
            _protocolArray = arr;
            [self makeUI];
            _sendBtn.enabled = true;
        } else {
            [self showError:self.view message:@"获取协议失败，请重试" afterHidden:1.5];
        }
    }];
}

- (void)makeUI {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"业务类型";
    label1.textColor = UIColorFromRGB(0x333333);
    label1.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_scrollView.mas_top).with.offset(15);
    }];
    
    businessBtn = [[ChooseButton alloc]init];
    [businessBtn addTarget:self action:@selector(chooseBusinessType:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:businessBtn];
    [businessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(10);
         make.top.mas_equalTo(label1.mas_bottom).with.offset(5);
         make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-40)/2, 40));
    }];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"技术方向";
    label2.textColor = UIColorFromRGB(0x333333);
    label2.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_top);
        make.left.mas_equalTo(businessBtn.mas_right).with.offset(20);
    }];
    
    techBtn = [[ChooseButton alloc]init];
    [techBtn addTarget:self action:@selector(chooseTechType:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:techBtn];
    [techBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_left);
        make.top.mas_equalTo(businessBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-40)/2, 40));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"期望价格";
    label3.textColor = UIColorFromRGB(0x333333);
    label3.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(businessBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    _price = [[UITextField alloc]init];
    _price.placeholder = @"请输入...";
    _price.borderStyle = UITextBorderStyleRoundedRect;
    _price.keyboardType = UIKeyboardTypeDecimalPad;
    _price.textColor = [UIColor darkGrayColor];
    _price.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_left);
        make.top.mas_equalTo(label3.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"开工时间";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_price.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    UILabel *littleLabel = [[UILabel alloc]init];
    littleLabel.text = @"（在规定服务时间内没有人接单，派单自动失效）";
    littleLabel.textColor = UIColorFromRGB(0x999999);
    littleLabel.font = [UIFont boldSystemFontOfSize:10];
    [_scrollView addSubview:littleLabel];
    [littleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.left.mas_equalTo(label.mas_right).with.offset(3);
    }];
    
    
    startTime = [[ChooseButton alloc]init];
    [startTime addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:startTime];
    [startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(label.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
    
    
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"截止日期";//限定所需时间（单位：天）
    label4.textColor = UIColorFromRGB(0x333333);
    label4.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(startTime.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    _needDays = [[ChooseButton alloc]init];
//    _needDays.placeholder = @"请输入...";
//    _needDays.borderStyle = UITextBorderStyleRoundedRect;
//    _needDays.keyboardType = UIKeyboardTypeDecimalPad;
//    _needDays.textColor = [UIColor darkGrayColor];
//    _needDays.font = [UIFont systemFontOfSize:15];
    [_needDays addTarget:self action:@selector(endTimeChoose:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_needDays];
    [_needDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_left);
        make.top.mas_equalTo(label4.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-10, 40));
    }];
    
    maleBtn = [[UIButton alloc]init];
    maleBtn.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    maleBtn.layer.borderWidth = 1;
    maleBtn.layer.masksToBounds = YES;
    maleBtn.layer.cornerRadius = 4;
    [maleBtn addTarget:self action:@selector(chooseMale:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:maleBtn];
    [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(businessBtn.mas_left);
        make.top.mas_equalTo(_needDays.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    UILabel *makeLabel = [[UILabel alloc]init];
    makeLabel.text = @"是否18：00以后加班";
    makeLabel.textColor = UIColorFromRGB(0x3D4245);
    makeLabel.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:makeLabel];
    [makeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.mas_equalTo(maleBtn.mas_left);
        make.top.mas_equalTo(maleBtn.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    UILabel *femaleLabel = [[UILabel alloc]init];
    femaleLabel.text = @"是否周六日加班";
    femaleLabel.textColor = UIColorFromRGB(0x3D4245);
    femaleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:femaleLabel];
    [femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(femaleBtn.mas_centerY);
        make.left.mas_equalTo(femaleBtn.mas_right).with.offset(10);
    }];
    
    UILabel *label10 = [[UILabel alloc]init];
    label10.text = @"服务地点";
    label10.textColor = UIColorFromRGB(0x333333);
    label10.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label10];
    [label10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(femaleBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    province = [[ChooseButton alloc]init];
    [province addTarget:self action:@selector(chooseProvince:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:province];
    [province mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(label10.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-50)/2, 40));
    }];
    
    UILabel *provinceLabel = [[UILabel alloc]init];
    provinceLabel.text = @"省";
    provinceLabel.textAlignment = NSTextAlignmentCenter;
    provinceLabel.textColor = UIColorFromRGB(0x666666);
    provinceLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:provinceLabel];
    [provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(province.mas_centerY);
        make.left.mas_equalTo(province.mas_right);
        make.width.mas_equalTo(20);
    }];
    
    city = [[ChooseButton alloc]init];
    [city addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:city];
    [city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(provinceLabel.mas_right);
        make.centerY.mas_equalTo(province.mas_centerY);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-50)/2, 40));
    }];
    
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"市";
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.textColor = UIColorFromRGB(0x666666);
    cityLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(city.mas_centerY);
        make.left.mas_equalTo(city.mas_right);
        make.width.mas_equalTo(20);
    }];
    
    region = [[ChooseButton alloc]init];
    [region addTarget:self action:@selector(chooseRegion:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:region];
    [region mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(province.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-50)/2, 40));
    }];
    
    UILabel *regionLabel = [[UILabel alloc]init];
    regionLabel.text = @"区/县";
    regionLabel.textAlignment = NSTextAlignmentCenter;
    regionLabel.textColor = UIColorFromRGB(0x666666);
    regionLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:regionLabel];
    [regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(region.mas_centerY);
        make.left.mas_equalTo(region.mas_right);
        make.width.mas_equalTo(40);
    }];
    
    
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"设备型号";
    label6.textColor = UIColorFromRGB(0x333333);
    label6.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(region.mas_bottom).with.offset(10);
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(20);
    }];
    
    _mechineNum = [[UITextField alloc]init];
    _mechineNum.borderStyle = UITextBorderStyleRoundedRect;
    _mechineNum.placeholder = @"请输入...";
    _mechineNum.textColor = [UIColor darkGrayColor];
    _mechineNum.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_mechineNum];
    [_mechineNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).with.offset(10);
        make.top.mas_equalTo(label6.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 40));
    }];
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"服务内容";
    label8.textColor = UIColorFromRGB(0x333333);
    label8.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mechineNum.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    _serviceDetail = [[UITextView alloc]init];
    _serviceDetail.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    _serviceDetail.layer.borderWidth = 1;
    _serviceDetail.textColor = [UIColor darkGrayColor];
    _serviceDetail.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_serviceDetail];
    [_serviceDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label8.mas_left);
        make.top.mas_equalTo(label8.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 80));
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"交付标准";
    label7.textColor = UIColorFromRGB(0x333333);
    label7.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_serviceDetail.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    _status = [[UITextView alloc]init];
    _status.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    _status.layer.borderWidth = 1;
    _status.textColor = [UIColor darkGrayColor];
    _status.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_status];
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label7.mas_left);
        make.top.mas_equalTo(label7.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 60));
    }];
    
    
    
    UILabel *label9 = [[UILabel alloc]init];
    label9.text = @"备注";
    label9.textColor = UIColorFromRGB(0x333333);
    label9.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_status.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    _memo = [[UITextView alloc]init];
    _memo.layer.borderColor = UIColorFromRGB(0xECECEC).CGColor;
    _memo.layer.borderWidth = 1;
    _memo.textColor = [UIColor darkGrayColor];
    _memo.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_memo];
    [_memo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label9.mas_left);
        make.top.mas_equalTo(label9.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 80));
    }];
    
 
    UILabel *btn = [[UILabel alloc]init];
    btn.text = @"上传图片";
    btn.textColor = UIColorFromRGB(0x333333);
    btn.font = [UIFont boldSystemFontOfSize:16];
//    [btn addTarget:self action:@selector(clickUpload) forControlEvents:UIControlEventTouchUpInside];
//    btn.layer.borderWidth = 1;
//    btn.layer.borderColor = MainColor.CGColor;
    [_scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_memo.mas_bottom).with.offset(10);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
#pragma -mark 图片上传
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
        make.left.mas_equalTo(btn.mas_left);
        make.top.mas_equalTo(btn.mas_bottom).with.offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH - LandscapeNumber(20));
        make.height.mas_greaterThanOrEqualTo(((self.identifierVC.photos.count+1)/3+1)*270 - 5);
    }];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.selected = true;
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_normal"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"auth_selected"] forState:UIControlStateSelected];
    [_selectedBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selectedBtn];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.equalTo(pictureView.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-120);
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
    
    _sendBtn = [[UIButton alloc]init];
    _sendBtn.backgroundColor = MainColor;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 4;
    [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sendBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(_selectedBtn.mas_bottom).with.offset(70.f);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_equalTo(40.f);
    }];
}


- (void)clickSelectedBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
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
        nightAdd = 2;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        nightAdd = 1;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
        
    }
    
    
}
- (void)chooseFemale:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        weekendAdd = 2;
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        weekendAdd = 1;
        [sender setImage:[UIImage imageNamed:@"register_yes"] forState:UIControlStateSelected];
        
    }
    
}

//点击开工时间
- (void)clickStart {
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分=====================",DateTime);
    

    
    CCDatePickerView *dateView=[[CCDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:dateView];
    __weak __typeof(self) weakSelf = self;

    dateView.blcok = ^(NSDate *dateString){
        
        startDate = dateString;
        NSLog(@"年 = %ld  月 = %ld  日 = %ld  时 = %ld  分 = %ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute);
        NSString *datestr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute];
        
        NSTimeInterval aTimer = [dateString timeIntervalSinceDate:date];
        
        int hour = (int)(aTimer/3600);
        int minute = (int)(aTimer - hour*3600)/60;
        //        int second = aTimer - hour*3600 - minute*60;
        NSString *dural = [NSString stringWithFormat:@"差距的时间 ：%d时%d分", hour, minute];
        NSLog(@"^^^^^ %@",dural);
        if (hour < 4) {
            [weakSelf showError:weakSelf.view message:@"开始时间不能低于4个小时" afterHidden:2];
            return ;
        }else if (hour/24 > 30 ) {
            [weakSelf showError:weakSelf.view message:@"开始时间不能长于30天" afterHidden:2];
            return ;
        }else if (hour/24 == 30){
            if (minute>0) {
                [weakSelf showError:weakSelf.view message:@"开始时间不能长于30天" afterHidden:2];
                return ;
            }
        }
        startimeStr = datestr;
        [startTime setTitle:datestr forState:UIControlStateNormal];
    };
    dateView.chooseTimeLabel.text = @"选择时间";
    [dateView fadeIn];
   
}

- (void)clickCommitBtn {
    
    if (businessType == 0) {
        [self showError:self.view message:@"商业类型不能为空" afterHidden:2];
        return;
    }else if (techBtn == 0) {
        [self showError:self.view message:@"技术方向不能为空" afterHidden:2];
        return;
    }else if (endtimeStr.length == 0) {
        [self showError:self.view message:@"截止日期不能为空" afterHidden:2];
        return;
    }
    else if (self.serviceDetail.text.length == 0) {
        [self showError:self.view message:@"服务内容不能为空" afterHidden:2];
        return;
    }else if (self.mechineNum.text.length == 0) {
        [self showError:self.view message:@"设备型号不能为空" afterHidden:2];
        return;
    }else if (self.status.text.length == 0) {
        [self showError:self.view message:@"交付标准不能为空" afterHidden:2];
        return;
    }else if (self.price.text.length == 0 || self.price.text.floatValue < 100) {
        [self showError:self.view message:@"价格不能小于100元" afterHidden:2];
        return;
    } if (!_selectedBtn.isSelected) {
        [self showError:self.view message:@"必须同意相关服务条款和隐私政策" afterHidden:2];
        return;
    }
//    [self uploadQulificationImage];
    
//    NSString *api = [NSString stringWithFormat:@"%@v1/details/datails",DOMAIN_NAME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
 
    params[@"businessType"] = [NSString stringWithFormat:@"%lu",(unsigned long)businessType];
    params[@"technicalDirection"] = [NSString stringWithFormat:@"%lu",(unsigned long)techType];
    params[@"jobDays"] = endtimeStr;
    params[@"isovertime"] = [NSString stringWithFormat:@"%d",weekendAdd];
    params[@"sixtime"] = [NSString stringWithFormat:@"%d",nightAdd];
    params[@"serviceContent"] = self.serviceDetail.text;
    params[@"unitType"] = self.mechineNum.text;
    params[@"deliveryStandards"] = self.status.text;
    params[@"userid"] = [UserModel sharedModel].userId;
    params[@"orderPrice"] = self.price.text;
    params[@"checkbox"] = _selectedBtn.isEnabled ? @"1": @"0";

//    int totalTime = 0;
//    if ([dayBtn.text intValue] != 0) {
//        if (hourBtn.text.length != 0) {
//             totalTime = [dayBtn.text intValue]*24 + [hourBtn.text intValue];
//        }else{
//            totalTime = [dayBtn.text intValue]*24;
//        }
//      
//    }else {
//        
//        totalTime =  [hourBtn.text intValue];
//    }
    //[NSString stringWithFormat:@"%d",totalTime];//单位小时
    params[@"serviceTime"] = startimeStr;
    params[@"provinceId"] = [NSString stringWithFormat:@"%ld",(long)_selectedProvinceId];
    params[@"cityId"] = [NSString stringWithFormat:@"%ld",(long)_selectedCityId];
    params[@"regionId"] = [NSString stringWithFormat:@"%ld",(long)_selectedRegionId];
    params[@"memo"] = self.memo.text;

    
    NSLog(@"参数------ &&&&&  %@",params);
    [self uploadQulificationImageWithParams:params];
//    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        NSLog(@"%@",result);
//        if (result != nil) {
//            if ([result isSucceed]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
//                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"发单成功" afterHidden:4];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else {
//                [self showError:[UIApplication sharedApplication].keyWindow message:@"发单失败" afterHidden:3];
//            }
//        } else {
//            [self showError:[UIApplication sharedApplication].keyWindow message:@"请求失败" afterHidden:3];
//            NSLog(@"请求失败");
//        }
//        
//    }];
}

#pragma -mark 上传图片
- (void)clickUploadWithParams:(NSDictionary *)params {
    
//    [self showError:self.view message:@"请到PC端上传附件" afterHidden:3];
    
    
    
}


- (void)uploadQulificationImageWithParams:(NSDictionary *)params {
//    if(self.identifierVC.photos.count == 0){
//    [self showError:[UIApplication sharedApplication].keyWindow message:@"请上传图片" afterHidden:3];
//        return;
//    }
    
    __weak typeof (self)selfVC = self;
    
    NSString *api =  [NSString stringWithFormat:@"%@v1/details/datails",DOMAIN_NAME];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0;i < self.identifierVC.photos.count;++i) {
            UIImage *img  =  [selfVC.identifierVC.photos objectAtIndex:i];
            
            UIImage *image = [selfVC fixrotation:img];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:@"files" fileName: [NSString stringWithFormat:@"file%d.png",i+1]mimeType:@"image/jpeg"];
        }
//        if(self.identifierVC.photos.count == 0){
//              [formData appendPartWithFileData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"files" fileName: [NSString stringWithFormat:@"nophoto.png"]mimeType:@"image/jpeg"];
//        }
        
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSLog(@"key = %@ and obj = %@", key, obj);
            [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }];

        
//        
//        // 将所有的key取出放入数组arr中
//        NSArray *arr = [params allKeys];
//        for (NSInteger i = 0; i < arr.count; ++i) {
//            NSString *key = arr[i];
//            NSString *value = [params objectForKey:arr[i]];// dic[arr[i]]
//            NSData *data =[value dataUsingEncoding:NSUTF8StringEncoding];
//            [formData appendPartWithFileData:data name:@"file" fileName: @"file1.png"mimeType:@""];
//            
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
//            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
            [self showSuccess:[UIApplication sharedApplication].keyWindow message:[responseObject objectForKey:@"message"] afterHidden:4];
            [self.navigationController popViewControllerAnimated:YES];
//            [self shareToWeChat:[data objectForKey:@"orderSn"]];
            
        }else {
            [self hiddenLoading];
            [self showError:self.view message:[responseObject objectForKey:@"message"] afterHidden:3];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self hiddenLoading];
        [self showError:self.view message:@"网络错误" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];
    
}

#pragma -mark 发布成功后分享
-(void)shareToWeChat:(NSString *)orderSn{
    
   
    
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


- (void)chooseBusinessType:(UIButton *)sender {
    picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self;
    [self.view addSubview:picker];
    picker.arrayType = GenderArray;
    self.type = 1;
    
}
- (void)chooseTechType :(UIButton *)sender{
    picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self;
    [self.view addSubview:picker];
    picker.arrayType = HeightArray;
    self.type = 2;
}
- (void)endTimeChoose :(UIButton *)sender {
//    picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
//    picker.delegate = self;
//    [self.view addSubview:picker];
//    picker.arrayType = DeteArray;
//    self.type = 7;
    

    CCDatePickerView *dateView=[[CCDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:dateView];
 
    dateView.blcok = ^(NSDate *dateString){
        NSLog(@"年 = %ld  月 = %ld  日 = %ld  时 = %ld  分 = %ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute);
        NSString *datestr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)dateString.year,(long)dateString.month,(long)dateString.day,dateString.hour,dateString.minute];
        NSLog(@"选择好的时间：%@",datestr);
        
        NSTimeInterval aTimer = [dateString timeIntervalSinceDate:startDate];
        //获取截止日期和开工日期之间的时间差
        int hour = (int)(aTimer/3600);
        int minute = (int)(aTimer - hour*3600)/60;
        int second = aTimer - hour*3600 - minute*60;
        NSString *dural = [NSString stringWithFormat:@"差距的时间 ：%d时%d分", hour, minute];
        NSLog(@"^^^^^ %@",dural);
        
        if (hour<0) {
            [self showError:[UIApplication sharedApplication].keyWindow message:@"截止日期不能早于开工日期" afterHidden:2];
            return ;
        }else if (hour == 0 && minute < 0) {
            [self showError:[UIApplication sharedApplication].keyWindow message:@"截止日期不能早于开工日期" afterHidden:2];
            return ;
        }
        
        endtimeStr = datestr;
        [_needDays setTitle:datestr forState:UIControlStateNormal];
    };
    dateView.chooseTimeLabel.text = @"选择时间";
    [dateView fadeIn];
   
}

/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
-(NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localDate = [now  dateByAddingTimeInterval: interval];
    endTime = [NSString stringWithFormat:@"%@ 23:59", endTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
    NSDate *end = [endDate dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = ([end timeIntervalSinceDate:localDate]) / 3600 / 24;
    
    NSString *timeStr = [NSString stringWithFormat:@"%lu", (unsigned long)voteCountTime];
    
    return timeStr;
}

- (void)chooseIsOverTimeType:(UIButton *)sender {
    [self.needDays resignFirstResponder];
    picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self;
    [self.view addSubview:picker];
    picker.arrayType = weightArray;
    self.type = 3;
}

//选择省份
- (void)chooseProvince :(UIButton *)sender{
    [city setTitle:@"" forState:UIControlStateNormal];
    [region setTitle:@"" forState:UIControlStateNormal];
    
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
                _provinceName = nameArr;
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
    [region setTitle:@"" forState:UIControlStateNormal];
    
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
                _cityName = nameArr;
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
                _regionName = nameArr;
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
        if (self.type == 1) {
            [businessBtn setTitle:str forState:UIControlStateNormal];
            businessType = index+1;
        }else if (self.type == 2){
            
            [techBtn setTitle:str forState:UIControlStateNormal];
            techType = index+1;
        }else if ( self.type == 3){
            
        [isOverTimeBtn setTitle:str forState:UIControlStateNormal];
            isOverType = index;
        }else if(self.type == 4) {
            self.selectedProvinceId = [[_provinceArr objectAtIndex:index] integerValue];
            NSLog(@"被选择的省份id == %ld",(long)self.selectedProvinceId);
            [province setTitle:str forState:UIControlStateNormal];
        }else if(self.type == 5) {
            self.selectedCityId = [[_cityArr objectAtIndex:index] integerValue];
            NSLog(@"被选择的城市id == %ld",(long)self.selectedCityId);
            [city setTitle:str forState:UIControlStateNormal];
        }else if(self.type == 6) {
            self.selectedRegionId = [[_regionArr objectAtIndex:index] integerValue];
            NSLog(@"被选择的区/县id == %ld",(long)self.selectedRegionId);            [region setTitle:str forState:UIControlStateNormal];
        }else if(self.type == 7) {

            [_needDays setTitle:str forState:UIControlStateNormal];
        }else if(self.type == 8) {
            //判断用户选择时间跟现在的时间间隔有没有低于4个小时，有没有超过一个月
//            [startTime setTitle:str forState:UIControlStateNormal];
        }
}
- (void)makePickerView {
    
    //    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-240, SCREEN_WIDTH, 240)];
    //    // 显示选中框
    //    _pickerView.backgroundColor = [UIColor whiteColor] ;
    //    _pickerView.showsSelectionIndicator = YES;
    //    _pickerView.layer.borderColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5].CGColor;
    //    _pickerView.layer.borderWidth = 1;
    //    _pickerView.dataSource = self;
    //    _pickerView.delegate = self;
    //    [self.view addSubview:_pickerView];
    
}

//// pickerView 列数
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//
//    return 1;
//}
//
//// pickerView 每列个数
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    
//    return [pickArray count];
//    
//}
//#pragma Mark -- UIPickerViewDelegate
//// 每列宽度
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//
//    return 180;
//}
//// 返回选中的行
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//
//    if (self.type == 1) {
//        NSString  *_proNameStr = [pickArray objectAtIndex:row];
//        NSLog(@"nameStr=%@",_proNameStr);
//        [businessBtn setTitle:_proNameStr forState:UIControlStateNormal];
//        businessType = row+1;
//    }else if (self.type == 2){
//        NSString  *_proNameStr = [pickArray objectAtIndex:row];
//        NSLog(@"nameStr=%@",_proNameStr);
//        [techBtn setTitle:_proNameStr forState:UIControlStateNormal];
//        techType = row +1;
//    }else if ( self.type == 3){
//        NSString  *_proNameStr = [pickArray objectAtIndex:row];
//        NSLog(@"nameStr=%@",_proNameStr);
//    [isOverTimeBtn setTitle:_proNameStr forState:UIControlStateNormal];
//        isOverType = row;
//    }else if(self.type == 4) {
//        self.provinceModel = [pickArray objectAtIndex:row];
//        [province setTitle:self.provinceModel.name forState:UIControlStateNormal];
//    }else if(self.type == 5) {
//        self.cityModel = [pickArray objectAtIndex:row];
//        [city setTitle:self.cityModel.name forState:UIControlStateNormal];
//    }else if(self.type == 6) {
//        self.regionModel = [pickArray objectAtIndex:row];
//        [region setTitle:self.regionModel.name forState:UIControlStateNormal];
//    }
//    
//    [_pickerView removeFromSuperview];
//    
//}
//
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (self.type == 4) {
//        ProvinceModel *model = [pickArray objectAtIndex:row];
//        return model.name;
//    }else if (self.type == 5){
//        CityModel *model = [pickArray objectAtIndex:row];
//        return model.name;
//    }else if (self.type == 6){
//        RegionModel *model = [pickArray objectAtIndex:row];
//        return model.name;
//    }
//    
//     return [pickArray objectAtIndex:row];
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [_pickerView removeFromSuperview];
//
//    
//}

@end
