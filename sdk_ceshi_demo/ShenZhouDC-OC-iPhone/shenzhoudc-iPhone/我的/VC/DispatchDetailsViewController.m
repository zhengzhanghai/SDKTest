//
//  DispatchDetailsViewController.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//我的派单--进行中状态点击详情页--评论接单人+验收

#import "DispatchDetailsViewController.h"
#import "TagView.h"
#import "NSString+CustomString.h"
#import "ComplainViewController.h"
#import "CDPStarEvaluation.h"
#import "StarRatingView.h"
#import "AverageScoreModel.h"
#import "ShensuViewController.h"

#import "LabelModel.h"
#import "WKWebView+HeaderFooter.h"

@interface DispatchDetailsViewController ()<UITextViewDelegate,StarRatingDelegate,TagViewDelegate,WKNavigationDelegate>
{
    UIView *paymentView;
    UILabel *first;//第一个平均分
    UILabel *second;//第2个平均分
    UILabel *third;//第3个平均分
    StarRatingView *tempAtar;
    StarRatingView *tempAtar1;
    StarRatingView *tempAtar2;

    int star1;//记录第一排星的个数
    int star2;//记录第二排星的个数
    int star3;//记录第三排星的个数
    
    NSString *ids;//评价标签id串，逗号隔开
    NSString *connectid;//当前用户是发单人，获取自己派单的接单人的id
    NSString *connectName;
    NSString *connectPhone;
    UIView *view;
    
    int time;//记录评论按钮点击次数，不为0就不可再点击
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UILabel *scoreLabel;//第一个星星
@property(nonatomic,strong)UILabel *scoreLabel1;//第2个星星
@property(nonatomic,strong)UILabel *scoreLabel2;//第3个星星
@property(nonatomic,strong)CDPStarEvaluation *valueView;
@property(nonatomic,strong)TagView *tagV;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHolderLabel;
@property(nonatomic,strong)NSMutableArray *labelsArray;//所有评论标签数组

@property(nonatomic,strong) NSMutableArray *selectedLabelsArray;//存放选中的标签数组



@end

@implementation DispatchDetailsViewController
- (NSMutableArray *)labelsArray {
    if (!_labelsArray) {
        _labelsArray = [NSMutableArray array];
    }
    return _labelsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    time = 0;
    star1 = 0;
    star2 = 0;
    star3 = 0;
    self.selectedLabelsArray = [[NSMutableArray alloc]init];
    [self.selectedLabelsArray removeAllObjects];
    
    [self getAllLabelsRequest]; //获取所有评价标签
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"派单详情（进行中）";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAverageScoreRequest];
    self.isOver = 1;
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(shensuButton)];
    rightButtonItem.title = @"投诉";
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

-(void)shensuButton{
    //确定申诉
    ShensuViewController *vc = [[ShensuViewController alloc]init];

    if (self.type == 0) {
          vc.orderSn = self.model.orderSn;
    }  if (self.type == 1) {
          vc.orderSn = self.recModel.orderSn;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [self.webView removeObserverForWebViewContentSize];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [view removeFromSuperview];
}


-(void)makeFooterView{
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 420)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.userInteractionEnabled = YES;
    
    self.webView.footerView = whiteView;
    
    
    

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    if (self.type == 0) {
        label.text = @"评价接单人";
    }else if (self.type == 1) {
        label.text = @"评价发单人";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(whiteView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    
    UILabel *myL = [[UILabel alloc]init];
    myL.text = @"我的评分";
    myL.textColor = UIColorFromRGB(0x666666);
    myL.font = [UIFont boldSystemFontOfSize:13];
    [whiteView addSubview:myL];
    [myL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(whiteView.mas_centerX).with.offset(-SCREEN_WIDTH/4);
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(label.mas_bottom).with.offset(15);
    }];
    
    
    UILabel *la1 = [[UILabel alloc]init];
    if (self.type == 0) {
        //评价接单人
        la1.text = @"专业水平";
    }else if(self.type == 1) {
        //评价发单人
        la1.text = @"需求符合度";
    }
    la1.textColor = UIColorFromRGB(0x666666);
    la1.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:la1];
    [la1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(myL.mas_bottom).with.offset(15);
    }];
    
    
    tempAtar = [[StarRatingView alloc]init];
    tempAtar.tag = 111;
    tempAtar.backgroundColor = [UIColor clearColor];
    tempAtar.imageWidth = 24.0;
    tempAtar.imageHeight = 22;
    tempAtar.imageCount = 5;
    tempAtar.isNeedHalf = NO;
    tempAtar.delegate = self;
    tempAtar.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:tempAtar];
    
    //    __weak __typeof(self)weakSelf = self;
    [tempAtar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(la1.mas_right).with.offset(5);
        make.centerY.mas_equalTo(la1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(tempAtar.imageWidth*5, tempAtar.imageHeight));
    }];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.textColor = UIColorFromRGB(0x333333);
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.text = [NSString stringWithFormat:@"%@ 星",@"0"];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:12];
    [whiteView addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar.mas_centerY);
        make.left.mas_equalTo(tempAtar.mas_right).with.offset(10);
    }];
    
    UILabel *lab1 = [[UILabel alloc]init];
    lab1.text = @"业内平均分";
    lab1.textColor = UIColorFromRGB(0x666666);
    lab1.font = [UIFont boldSystemFontOfSize:13];
    [whiteView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX).with.offset(SCREEN_WIDTH/3);
        make.top.mas_equalTo(label.mas_bottom).with.offset(15);
    }];
    
    
    first = [[UILabel alloc]init];
    first.textColor = MainColor;
    first.textAlignment = NSTextAlignmentCenter;
    first.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:first];
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar.mas_centerY);
        make.centerX.mas_equalTo(lab1.mas_centerX);
    }];
    
    UILabel *la2 = [[UILabel alloc]init];
    if (self.type == 0) {
        la2.text = @"服务态度";
    }else if(self.type == 1) {
        la2.text = @"配合程度";
    }
    la2.textColor = UIColorFromRGB(0x666666);
    la2.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:la2];
    [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(la1.mas_bottom).with.offset(10);
    }];
    
    
    tempAtar1 = [[StarRatingView alloc]init];
    tempAtar1.tag = 222;
    tempAtar1.backgroundColor = [UIColor clearColor];
    tempAtar1.imageWidth = 24.0;
    tempAtar1.imageHeight = 22;
    tempAtar1.imageCount = 5;
    tempAtar1.isNeedHalf = NO;
    tempAtar1.delegate = self;
    tempAtar1.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:tempAtar1];
    [tempAtar1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tempAtar.mas_left);
        make.centerY.mas_equalTo(la2.mas_centerY);
        make.width.mas_equalTo(tempAtar.mas_width);
        make.height.mas_equalTo(tempAtar.mas_height);
    }];
    
    
    _scoreLabel1 = [[UILabel alloc]init];
    _scoreLabel1.textColor = UIColorFromRGB(0x333333);
    _scoreLabel1.textAlignment = NSTextAlignmentCenter;
    _scoreLabel1.text = [NSString stringWithFormat:@"%@ 星",@"0"];
    _scoreLabel1.font = [UIFont boldSystemFontOfSize:12];
    [whiteView addSubview:_scoreLabel1];
    [_scoreLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar1.mas_centerY);
        make.left.mas_equalTo(_scoreLabel.mas_left);
    }];
    
    
    second = [[UILabel alloc]init];
    second.textColor = MainColor;
    second.textAlignment = NSTextAlignmentCenter;
    second.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:second];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar1.mas_centerY);
        make.centerX.mas_equalTo(lab1.mas_centerX);
        
    }];
    
    
    UILabel *la3 = [[UILabel alloc]init];
    la3.text = @"整体评价";
    la3.textColor = UIColorFromRGB(0x666666);
    la3.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:la3];
    [la3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(la2.mas_bottom).with.offset(10);
    }];
    
    
    tempAtar2 = [[StarRatingView alloc]init];
    tempAtar2.tag = 333;
    tempAtar2.backgroundColor = [UIColor clearColor];
    tempAtar2.imageWidth = 24.0;
    tempAtar2.imageHeight = 22;
    tempAtar2.imageCount = 5;
    tempAtar2.isNeedHalf = NO;
    tempAtar2.delegate = self;
    tempAtar2.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:tempAtar2];
    [tempAtar2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tempAtar.mas_left);
        make.centerY.mas_equalTo(la3.mas_centerY);
        make.width.mas_equalTo(tempAtar.mas_width);
        make.height.mas_equalTo(tempAtar.mas_height);
    }];
    
    
    _scoreLabel2 = [[UILabel alloc]init];
    _scoreLabel2.textColor = UIColorFromRGB(0x333333);
    _scoreLabel2.textAlignment = NSTextAlignmentCenter;
    _scoreLabel2.text = [NSString stringWithFormat:@"%@ 星",@"0"];
    _scoreLabel2.font = [UIFont boldSystemFontOfSize:12];
    [whiteView addSubview:_scoreLabel2];
    [_scoreLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar2.mas_centerY);
        make.left.mas_equalTo(_scoreLabel1.mas_left);
    }];
    
    
    third = [[UILabel alloc]init];
    third.textColor = MainColor;
    third.textAlignment = NSTextAlignmentCenter;
    third.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:third];
    [third mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempAtar2.mas_centerY);
        make.centerX.mas_equalTo(lab1.mas_centerX);
        
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.delegate = self;
    _textView.layer.borderColor = UIColorFromRGB(0xEAEAEA).CGColor;
    _textView.layer.borderWidth = 1;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.textColor = [UIColor darkGrayColor];
    [whiteView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(_scoreLabel2.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, LandscapeNumber(100)));
    }];
    
    _placeHolderLabel = [[UILabel alloc]init];
    _placeHolderLabel.text = @"请输入评价内容...";
    _placeHolderLabel.textColor = UIColorFromRGB(0xEAEAEA);
    _placeHolderLabel.font = [UIFont systemFontOfSize:13];
    [_textView addSubview:_placeHolderLabel];
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textView.mas_left).with.offset(8);
        make.top.mas_equalTo(_textView.mas_top).with.offset(8);
    }];
    
    //标签View
    CGFloat height ;
    if (self.labelsArray.count%3 == 0) {
        height = 20 + (self.labelsArray.count/3 -1)*10 + self.labelsArray.count/3*14;
    }else{
        height = 20 +self.labelsArray.count*10 + (self.labelsArray.count/3+1)*14;
    }
    _tagV = [[TagView alloc]initWithDataArray:self.labelsArray];
    _tagV.delegate = self;
    [whiteView addSubview:_tagV];
    [_tagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(0.f);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    if(self.isOver == 0) {
        btn.backgroundColor = UIColorFromRGB(0xECECEC);
        btn.userInteractionEnabled = NO;
        [self showError:self.view message:@"接单人尚未确认完工" afterHidden:2];
    }else if (self.isOver == 1){
        btn.userInteractionEnabled = YES;
    }
    btn.backgroundColor = MainColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    if (self.type == 0) {
        [btn setTitle:@"验收完工" forState:UIControlStateNormal];
    }else if (self.type == 1){
        [btn setTitle:@"确认完工" forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(clickMakeSureButton) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.equalTo(_tagV.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];


}


- (void)makeUI {
//    _scrollView = [[UIScrollView alloc]init];
////    _scrollView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0.f);
//        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT +20);
//        make.right.mas_equalTo(0.f);
//        make.bottom.mas_equalTo(0.f);
//    }];
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBARHEIGHT - STATUSBARHEIGHT) configuration:[WKWebViewConfiguration new]];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
    view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [_webView addSubview:view];
    
//    if (self.type == 0) {
//        //static/apidoc/content.html?id=%@&type=getImplementation  查看最终接单人详情
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@static/apidoc/content.html?connectid=%@&orderSn=%@&type=getPersonDetails",DOMAIN_NAME,self.recModel.id,self.model.orderSn]]]];
//    }else if (self.type == 1) {
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@static/apidoc/content.html?orderSn=%@&type=getOrderDetail",DOMAIN_NAME,self.recModel.orderSn]]]];
//    }
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?orderSn=%@&type=getOrderDetail",DOMAIN_NAME_H5,H5_CONTENT,self.recModel.orderSn]]]];
    
    [self.view addSubview:_webView];
//    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(.0f);
//        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+STATUSBARHEIGHT +20);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(SCREEN_WIDTH-50);
//    }];
//
    [self makeFooterView];
    
    
    
   
}

// === 验收完工/确认完工   按钮
- (void)clickMakeSureButton {
    
    //必须先评价
    //分数3星及以下必须写评论内容，否则不能验收/完工
    
    if (star1 < 3.0 || star2 < 3.0 || star3 < 3.0) {
        if (_textView.text.length == 0) {
            [self showError:self.view message:@"每项出现三星及以下必须写评价原因!" afterHidden:3];
            return;
        }
        
        if (_selectedLabelsArray.count == 0) {
            [self showError:self.view message:@"还未添加标签" afterHidden:2];
            return;
        }

        
    }else {
//        if (time != 0) {
//            [self showError:self.view message:@"请勿重复评价" afterHidden:2];
//            return;
//        }
        
        if (_selectedLabelsArray.count == 0) {
            [self showError:self.view message:@"还未添加标签" afterHidden:2];
            return;
        }
        
        
        
    }
    
    
    if (self.type == 0) {//发单人
        [self makeSureOver];//评论接单人
        
        
    }else if (self.type == 1) {//接单人
        [self ConfirmTaskOver];// 评论发单人人
    }

}
- (void)makeSureOver {
    
    if (self.selectedLabelsArray.count == 0) {
            [self showError:self.view message:@"还未添加标签" afterHidden:2];
            return;
        
    }
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@",self.selectedLabelsArray[0]];
    NSMutableString *AllStr = [[NSMutableString alloc] initWithString:str];
    for (int i = 1; i < self.selectedLabelsArray.count; i++) {
        NSString  *modelStr = [NSString stringWithFormat:@",%@",self.selectedLabelsArray[i]];
        [AllStr appendString:modelStr];
       
    }
    
    
    
     NSString *myApi = [NSString stringWithFormat:@"%@v1/details/getAcceptor",DOMAIN_NAME];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.model.orderSn;
    params[@"standard"] = [NSString stringWithFormat:@"%d",star1];
    params[@"customers"] = [NSString stringWithFormat:@"%d",star2];
    params[@"global"] = [NSString stringWithFormat:@"%d",star3];
    params[@"cause"] = self.textView.text;
    params[@"evaluationLable"] = AllStr;
    
    AINetworkEngine *manager = [AINetworkEngine sharedClient];
   
    [manager postWithApi:myApi parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
               
                [self showSuccess:[UIApplication sharedApplication].keyWindow message:@"验收成功" afterHidden:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [self showError:self.view message:[result getMessage] afterHidden:2];
            }
        } else {
            [self showError:self.view message:@"网络错误！" afterHidden:2];
            NSLog(@"请求失败");
        }
        
    }];
    
    
    
    
   
   
}

//确认完工
- (void)ConfirmTaskOver {
    if (self.selectedLabelsArray.count == 0) {
        [self showError:self.view message:@"还未添加标签" afterHidden:2];
        return;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@",self.selectedLabelsArray[0]];
    NSMutableString *AllStr = [[NSMutableString alloc] initWithString:str];
    for (int i = 1; i < self.selectedLabelsArray.count; i++) {
        NSString  *modelStr = [NSString stringWithFormat:@",%@",self.selectedLabelsArray[i]];
        [AllStr appendString:modelStr];
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderSn"] = self.recModel.orderSn;
    params[@"demandCompliance"] = [NSString stringWithFormat:@"%d",star1];
    params[@"cooperate"] = [NSString stringWithFormat:@"%d",star2];
    params[@"global"] = [NSString stringWithFormat:@"%d",star3];
    params[@"cause"] = self.textView.text;
    params[@"evaluationLable"] = AllStr;
    
    NSString *api = [NSString stringWithFormat:@"%@v1/details/getOverType",DOMAIN_NAME];
    AINetworkEngine *manager = [AINetworkEngine sharedClient];
//    [manager.requestSerializer setValue:[UserModel sharedModel].userId forHTTPHeaderField:@"connectid"];
    NSLog(@"参数------ &&&&&  %@",params);
    [manager postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"确认完工成功");
                [self showSuccess:self.view message:@"确认完工成功" afterHidden:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [self showError:self.view message:@"确认失败，请稍后重试！" afterHidden:2];
            }
        } else {
             [self showError:self.view message:@"网络错误！" afterHidden:2];
            NSLog(@"请求失败");
        }
        
    }];
    
}

/**
 *  @author Ezreal, 16-09-09 10:09:14
 *
 *  @brief 返回的协议方法
 *
 *  @param grade 返回的评星等级
 */
- (void)sendGrade:(NSString *)grade AndDelegate:(StarRatingView *)view{
    if (view.tag == 111) {
        int score = [grade intValue];
         _scoreLabel.text = [NSString stringWithFormat:@"%d 星",score];
        star1 = score;

//        if (score%2 == 0) {
//            _scoreLabel.text = [NSString stringWithFormat:@"%d 星",score/2];
//            star1 = score/2;
//        }else{
//            _scoreLabel.text = [NSString stringWithFormat:@"%d 星",score/2+1];
//            star1 = score/2+1;
//        }
    }else if (view.tag == 222) {
        
        int score = [grade intValue];
        _scoreLabel1.text = [NSString stringWithFormat:@"%d 星",score];
        star2 = score;
//        if (score%2 == 0) {
//            _scoreLabel1.text = [NSString stringWithFormat:@"%d 星",score/2];
//            star2 = score/2;
//        }else{
//            _scoreLabel1.text = [NSString stringWithFormat:@"%d 星",score/2+1];
//            star2 = score/2+1;
//        }
    }else if (view.tag == 333) {
        
        int score = [grade intValue];
        _scoreLabel2.text = [NSString stringWithFormat:@"%d 星",score];
        star3 = score;
//        if (score%2 == 0) {
//            _scoreLabel2.text = [NSString stringWithFormat:@"%d 星",score/2];
//            star3 = score/2;
//        }else{
//            _scoreLabel2.text = [NSString stringWithFormat:@"%d星",score/2+1];
//            star3 = score/2+1;
//        }
    }
   
}

#pragma TagViewDelegate  ---- 获取评价标签
- (void)getLabelTag:(NSInteger)tag AndIsSelected:(BOOL)isSelected{
    NSLog(@"标签的tag -- %ld,,是否选中 --- %d",(long)tag,isSelected);
    
    if (isSelected == 1) {
        [_selectedLabelsArray addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
       
    }
    
    if (isSelected == 0) {
        
        [_selectedLabelsArray removeObject:[NSString stringWithFormat:@"%ld",(long)tag]];
        
    }
    NSLog(@"最终的字符串是******  %@",_selectedLabelsArray);

}
#pragma mark CDPStarEvaluationDelegate获得实时评价级别
-(void)theCurrentCommentText:(NSString *)commentText{
    _scoreLabel.text = [NSString stringWithFormat:@"%.2f 分",_valueView.width*5];
}

#pragma mark  UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    _placeHolderLabel.hidden = YES;
    if ([textView.text isEqualToString:@""]) {
        _placeHolderLabel.hidden = NO;
    }
    
    
}

/* 获取所有评价标签 
 type 标签类型
 1：接单人标签 2：发单人标签
*/
- (void)getAllLabelsRequest {
    
    NSString *api;
    if (self.type == 0) {
        //接单的标签
        api = [NSString stringWithFormat:@"%@v1/lable/all/1",DOMAIN_NAME];
    }else if (self.type == 1) {
        api =  [NSString stringWithFormat:@"%@v1/lable/all/2",DOMAIN_NAME];
    }

    [[AINetworkEngine sharedClient] getWithApi:api parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
             if (result) {
            if ([result isSucceed]) {
                NSMutableArray *list = [NSMutableArray array];
                NSArray *ads = [result getDataObj];
                for (int i = 0; i < ads.count; i++) {
                    LabelModel *model = [LabelModel modelWithDictionary:ads[i]];
                    [list addObject:model.lableContent];
                }
                _labelsArray = list;

                [self makeUI];
   
            } else {
            }
        } else {
            [self showError:self.view message:@"请求失败" afterHidden:1.5];
        }
    }];

    
}
//获取业内平均分
- (void)getAverageScoreRequest {
    
    if (self.type == 0) {//当前用户是发单人

        //获取接单人的平均分 type为1 专业水平、服务态度、整体评价
        NSString *api = [NSString stringWithFormat:@"%@v1/comment/avg/%d",DOMAIN_NAME,1];
        [[AFHTTPSessionManager manager] GET:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            if ([[data objectForKey:@"standard"] isKindOfClass:[NSNull class]]) {
               first.text = @"暂无";
               
            }else{
            first.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"standard"]];
            
            }
            
            if ([[data objectForKey:@"customers"] isKindOfClass:[NSNull class]]) {
                 second.text = @"暂无";
            }else{
                second.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"customers"]];
            }
            
            if ([[data objectForKey:@"global"] isKindOfClass:[NSNull class]]) {
                
                third.text = @"暂无";
            }else{
                
                third.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"global"]];
            }
           
            
            NSLog(@"********** %@",data);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);

        }];

    }else if (self.type == 1) {//当前用户是接单人
           //获取发单人的平均分 type为2 需求符合度、配合程度、整体评价
        NSString *api = [NSString stringWithFormat:@"%@v1/comment/avg/%d",DOMAIN_NAME,2];
        [[AFHTTPSessionManager manager] GET:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *data = [responseObject objectForKey:@"data"];
            if ([[data objectForKey:@"demandCompliance"] isKindOfClass:[NSNull class]]) {
                first.text = @"暂无";
            }else{
                first.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"demandCompliance"]];

            }
            if ([[data objectForKey:@"cooperate"] isKindOfClass:[NSNull class]]) {
                second.text = @"暂无";
                
            }else{
                second.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"cooperate"]];
            }
            if ([[data objectForKey:@"global"] isKindOfClass:[NSNull class]]) {
                third.text = @"暂无";
            }else{
                third.text = [NSString stringWithFormat:@"%@分",[data objectForKey:@"global"]];
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
        }];

    }   
}
////评论接单人
//- (void)publicCommentRequestWithConnectId:(NSString *)conntid {
//    
// 
//        //对实施人发起评价
////        NSString *api = [NSString stringWithFormat:@"%@v1/comment/PublishOrderAs",DOMAIN_NAME];
//      NSString *api = [NSString stringWithFormat:@"%@v1/comment/publishOrder",DOMAIN_NAME];
//        AINetworkEngine *manager = [AINetworkEngine sharedClient];
////        [manager.requestSerializer setValue:[UserModel sharedModel].userId forHTTPHeaderField:@"connectid"];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
////        params[@"sendId"] = [UserModel sharedModel].userId;
////        params[@"resourceId"] = conntid;
////        params[@"orderId"] = self.model.id;
//        params[@"orderSn"] = self.model.orderSn;
//        params[@"standard"] = [NSString stringWithFormat:@"%d",star1];
//        params[@"customers"] = [NSString stringWithFormat:@"%d",star2];
//        params[@"global"] = [NSString stringWithFormat:@"%d",star3];
////        params[@"observer"] = @"2";//当前用户是发单人
//       params[@"cause"] = self.textView.text;
//        
//         NSLog(@"参数------ &&&&&  %@",params);
//
//        [manager postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//            NSLog(@"%@",result);
//            if (result != nil) {
//                if ([result isSucceed]) {
//                    NSLog(@"评价成功");
////                    [self showSuccess:self.view message:@"评价成功" afterHidden:3];
//
//                    if (self.selectedLabelsArray.count == 0) {
//                        [self showError:self.view message:@"还未选择评论标签" afterHidden:2];
//                        return;
//                    }
//                    //添加评价标签
//                    [self addLabelsToPersonReques];
//                    
//                }else{
//                    [self showError:self.view message:@"评价失败，请稍后重试" afterHidden:2];
//                }
//            } else {
//                NSLog(@"请求失败");
//            }
//            
//        }];
//
//     
//    }

////发单人获取最终实施人（接单人）的id
//- (void)getConnectId  {
//  
//        NSString *api = [NSString stringWithFormat:@"%@v1/details/getImplementation?orderSn=%@",DOMAIN_NAME,self.model.orderSn];
//        [[AFHTTPSessionManager manager]GET:api parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            int code = [[responseObject objectForKey:@"code"] intValue];
//            if (code == 1000) {
//                NSString *connectorid = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"connectid"]];
//                NSString *connectCellNum = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"contentPhone"]];
//                connectPhone = connectCellNum;
//                NSString *nameStr = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"connectName"]];
//                connectName = nameStr;
//                connectid = connectorid;
//                //评论接单人
//                [self publicCommentRequestWithConnectId:connectorid];
//                
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//        }];
//    
////     [self publicCommentRequestWithConnectId:@""];
//
//}
//评价发单人
//- (void)commentSender {
//    
//    NSLog(@"bbbbbbb--->%@",self.recModel.id);
//  
////    NSString *api = [NSString stringWithFormat:@"%@v1/comment/PublishOrderAs",DOMAIN_NAME];
//       NSString *api = [NSString stringWithFormat:@"%@v1/comment/publishOrder",DOMAIN_NAME];
//    AINetworkEngine *manager = [AINetworkEngine sharedClient];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
////    params[@"sendId"] = [UserModel sharedModel].userId;
////    params[@"resourceId"] = self.recModel.userid;
////    params[@"orderId"] = self.recModel.id;      self.model.orderSn
//    params[@"orderSn"] = self.recModel.orderSn;
//    params[@"demandCompliance"] = [NSString stringWithFormat:@"%d",star1];
//    params[@"cooperate"] = [NSString stringWithFormat:@"%d",star2];
//    params[@"global"] = [NSString stringWithFormat:@"%d",star3];
////    params[@"observer"] = @"1";//当前用户是接单人
//    params[@"cause"] = self.textView.text;
//    NSLog(@"参数------ &&&&&  %@",params);
//    
//    [manager postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        NSLog(@"%@",result);
//        if (result != nil) {
//            if ([result isSucceed]) {
//                NSLog(@"评价成功");
//                [self addLabelsToPersonReques];//添加评论标签
//                
//            }else{
//                [self showError:self.view message:@"评价失败，请稍后重试" afterHidden:2];
//            }
//        } else {
//            NSLog(@"请求失败");
//        }
//        
//    }];
//}
////给接单人、发单人添加标签接口  ==== 公用
//- (void)addLabelsToPersonReques {
//    if (self.selectedLabelsArray.count == 0) {
//        [self showError:self.view message:@"还未添加标签" afterHidden:2];
//        return;
//    }
//    
//    NSString *api = [NSString stringWithFormat:@"%@v1/lable/append",DOMAIN_NAME];
//
//    NSString *str = [NSString stringWithFormat:@"%@",self.selectedLabelsArray[0]];
//    NSMutableString *AllStr = [[NSMutableString alloc] initWithString:str];
//    for (int i = 1; i < self.selectedLabelsArray.count; i++) {
//        
//        NSString  *modelStr = [NSString stringWithFormat:@",%@",self.selectedLabelsArray[i]];
//        [AllStr appendString:modelStr];
//    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"lids"] = AllStr;//标签id串
//    if (self.type == 0) {
//        params[@"orderId"] = [NSString stringWithFormat:@"%@",self.model.id];//当前被评价订单id
//    }else if (self.type == 1) {
//        params[@"orderId"] = [NSString stringWithFormat:@"%@",self.recModel.id];//当前被评价订单id
//    }
//    
//    NSLog(@"%@ <--- 🌺🌺🌺 --->%@",api,params);
//    
//    [[AFHTTPSessionManager manager] POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSLog(@"key = %@ and obj = %@", key, obj);
//            [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
//        }];
//        
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        int code = [[responseObject objectForKey:@"code"] intValue];
//        if (code == 1000) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMySendList" object:nil];
//            NSLog(@"添加标签成功");
//            if (self.type == 0) {
//                [self connectorReback];//先检查金额是否足够，然后退接单人押金，最后验收完工
//            }else if (self.type == 1) {
//                [self ConfirmTaskOver];//确认完工
//            }
//
//        }else{
//        [self showError:self.view message:@"评论失败" afterHidden:2];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [self showError:self.view message:@"评价失败，请稍后重试" afterHidden:2];
//    }];
//    
//}


//确定付款页面
- (void)makeSureToPaymentView {
    paymentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    paymentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:paymentView];
    
    NSString *info = @"您确定接单人已将任务全部完成，确定付款吗？如不点击验收完工，平台预付款将在3个工作日内自动支付给接单人，如果您对任务完成情况有异议，请提起投诉，预付款将延迟支付。";
    CGFloat height = [info getHeightWithContent:info width:SCREEN_WIDTH-60 font:13];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 4;
    [paymentView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(paymentView.mas_centerX);
        make.centerY.mas_equalTo(paymentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80, LandscapeNumber(195)+height));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"确定付款";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.mas_equalTo(whiteView.mas_top).with.offset(20);
        make.height.mas_equalTo(24);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(whiteView.mas_left);
        make.right.mas_equalTo(whiteView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePayView) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right);
        make.top.mas_equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = info;
    detailLabel.textColor = UIColorFromRGB(0x666666);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(20);
        make.right.mas_equalTo(whiteView.mas_right).with.offset(-10);
    }];
    
    UILabel *complainLabel = [[UILabel alloc]init];
    complainLabel.text = @"我要投诉";
    complainLabel.textColor = MainColor;
    complainLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [complainLabel addGestureRecognizer:singleRecognizer];
    complainLabel.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:complainLabel];
    [complainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).with.offset(10);
        make.top.mas_equalTo(detailLabel.mas_bottom).with.offset(20);
        make.height.mas_equalTo(15);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = MainColor;
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(complainLabel.mas_bottom);
        make.left.mas_equalTo(complainLabel.mas_left);
        make.right.mas_equalTo(complainLabel.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.backgroundColor = MainColor;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.layer.cornerRadius = 4;
    [makeSureBtn setTitle:@"确定付款" forState:UIControlStateNormal];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [makeSureBtn addTarget:self action:@selector(clickPayBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:makeSureBtn];
    [makeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.equalTo(line.mas_bottom).with.offset(15.f);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(-20.f);
        make.height.mas_equalTo(40.f);
    }];
    
}
////点击 申诉
//-(void)SingleTap:(UITapGestureRecognizer*)recognizer
//{
////    //处理单击操作
////    ComplainViewController *vc = [[ComplainViewController  alloc]init];
////    [self.navigationController pushViewController:vc animated:YES];
//    
//    [self showError:self.view message:@"功能暂未开通" afterHidden:2];
//    [paymentView removeFromSuperview];
//    
//}
////确定付款
//- (void)clickPayBtn {
//    //请求确认付款接口，关闭支付页面
//    [paymentView removeFromSuperview];
//    //接单人服务报酬返回 -- 付款给接单人
//    [self connectorReback];
//    /////??????????????????????????
//
//
//}
//关闭支付页面
- (void)closePayView {
    [paymentView removeFromSuperview];
}
////接单人服务报酬返回
//- (void)connectorReback {
//   NSString *api = @"v1/payment/service/fees";
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"connectId"] = connectid;
//    params[@"orderSn"] = self.model.orderSn;
//    params[@"mobile"] = connectPhone;
//    params[@"connectName"] = connectName;//connectName;
//    params[@"userId"] = [UserModel sharedModel].userId;
//    
//    NSLog(@"小刘小刘--> %@",params);
//    
//    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        NSLog(@"%@",result);
//        if (result != nil) {
//            if ([result isSucceed]) {
//                NSLog(@"给接单人付款成功");
////                [self showSuccess:self.view message:@"付款成功" afterHidden:2];
//                //接单人押金退还
//                [self connectorPrePayBack];
//                
//            }else{
//                [self showError:self.view message:@"付款失败" afterHidden:2];
//            }
//        } else {
//            NSLog(@"请求失败");
//        }
//        
//    }];
//
//}
////接单人押金退还
//- (void)connectorPrePayBack {
//    NSString *api = @"v1/payment/margin/refund";
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"connectId"] = connectid;
//    params[@"orderSn"] = self.model.orderSn;
//    params[@"mobile"] = connectPhone;
//    params[@"connectName"] = connectName;
//    
//    
//    [[AINetworkEngine sharedClient] postWithApi:api parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
//        NSLog(@"%@",result);
//        if (result != nil) {
//            if ([result isSucceed]) {
//                NSLog(@"接单人押金退还成功");
//                [self makeSureOver];
//                
//            }else{
//            }
//        } else {
//            NSLog(@"请求失败");
//        }
//        
//    }];
//}

@end
