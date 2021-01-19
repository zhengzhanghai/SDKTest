//
//  CommentViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentStarView.h"



@interface CommentViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *placeHoldLabel;
@property (nonatomic, strong) CommentStarView *commentView;

@property (nonatomic, assign) int starCount; //评论的星数
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEAEAEA);
    self.title = @"评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self makeUI ];
    self.starCount = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, LandscapeNumber(180))];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LandscapeNumber(84))];
//    self.commentTextView.layer.borderColor = [UIColor redColor].CGColor;
//    self.commentTextView.layer.borderWidth = 1;
    self.commentTextView.textColor = UIColorFromRGB(0x0F0F0F);
    self.commentTextView.font = [UIFont systemFontOfSize:16];
    self.commentTextView.delegate = self;
    [topView addSubview:self.commentTextView];
    
    self.placeHoldLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-40, 16)];
    self.placeHoldLabel.text = @"请输入对商品的评价…";
    self.placeHoldLabel.font = [UIFont systemFontOfSize:16];
    self.placeHoldLabel.textColor = UIColorFromRGB(0x666666);
    [topView addSubview:self.placeHoldLabel];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commentTextView.frame), SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorFromRGB(0xEAEAEA);
    [topView addSubview:line];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(line.frame)+16, 40, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = UIColorFromRGB(0x3D4245);
    label.text = @"评分";
    [topView addSubview:label];
    
    self.commentView = [[CommentStarView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(label.frame)+16, 180, 30) EmptyImage:@"评价-灰" StarImage:@"评价-红"];
//    self.commentView.backgroundColor = [UIColor yellowColor];
     __weak CommentViewController *weakSelf = self;
    self.commentView.starBlock = ^(int index){
        
        weakSelf.starCount = index;
        NSLog(@"🌸🌸 == %d",weakSelf.starCount);
        
    };
    [topView addSubview:self.commentView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-51, SCREEN_WIDTH, 51)];
    btn.backgroundColor = UIColorFromRGB(0xD71629);
    [btn addTarget:self action:@selector(clickPublick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:btn];
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![textView.text isEqualToString:@""]) {
        self.placeHoldLabel.hidden = YES;
    }else{
        self.placeHoldLabel.hidden = NO;
    }
}

//点击 发布
- (void)clickPublick {
    if ([self.commentTextView.text isEqualToString:@""]) {
        [self showError:self.view message:@"评论内容不能为空" afterHidden:3];
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"content"] = self.commentTextView.text;
    params[@"score"] = [NSString stringWithFormat:@"%d",self.starCount];
    params[@"sendId"] = [UserModel sharedModel].userId;
    params[@"resourceType"] = [NSString stringWithFormat:@"%d",self.commentId];
    params[@"resourceId"] = self.resourceId;
    params[@"orderId"] = self.orderId;
    
    [[AINetworkEngine sharedClient] postWithApi:API_POST_SENDCOMMENT parameters:params CompletionBlock:^(AINetworkResult *result, NSError *error) {
        NSLog(@"%@",result);
        if (result != nil) {
            if ([result isSucceed]) {
                NSLog(@"上传成功");
                [self showSuccess:self.view message:@"评价成功" afterHidden:4];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"commentSuccess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            NSLog(@"请求失败");
        }
        
    }];
    
    
}



@end
