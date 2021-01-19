//
//  PersonInfoViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 17/1/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AuthenticationViewController.h"
#import "NSString+CustomString.h"
#import "ChangeUserInfoViewController.h"
#import <WebKit/WebKit.h>

@interface PersonInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UILabel *despLabel3; //姓名
    UILabel *despLabel4;//性别
    
    NSInteger accountType;
    
}
@property(nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *accountLabel;
//@property(nonatomic , assign) int userType; //用户类型，0 普通用户（未认证）  1厂商 2 代理商 3集成商 4企业用户 5技术达人
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:@"AuthSuccess" object:nil];
  
}
/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除WebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self loadUserBaseInfoRequest];
    
    [self cleanCacheAndCookie];
    
}
- (void)reloadUI {
    //请求用户信息
    //刷新姓名和性别新修改的属性 ==============================
    [self loadUserBaseInfoRequest];
    
}
- (void)makeUI {
    
    int type = [UserBaseInfoModel sharedModel].type.intValue;
    UIButton *authBtn = [[UIButton alloc]init];
    authBtn.clipsToBounds = true;
    authBtn.layer.cornerRadius = 3;
    if (type == -1 ) {
        authBtn.backgroundColor = MainColor;
        [authBtn setTitle:@"去认证" forState:UIControlStateNormal];
    }else{
        authBtn.backgroundColor = MainColor;
        [authBtn setTitle:@"认证" forState:UIControlStateNormal];
    }
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    authBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [authBtn addTarget:self action:@selector(clickAuthBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authBtn];
    [authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(IS_IPAD ? 55 : 40);
    }];
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[ WKWebViewConfiguration new]];
    _webView.backgroundColor = [UIColor clearColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",DOMAIN_NAME_H5,H5_USER_INFO,[UserModel sharedModel].userId]]]];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).with.offset(NAV_TAB_BAR_HEIGHT+STATUSBARHEIGHT);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(authBtn.mas_top).offset(-10);
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
                
                
                accountType = [[dic objectForKey:@"type"] intValue];
                
                despLabel3.text = [UserBaseInfoModel sharedModel].nickName;
                if ([[UserBaseInfoModel sharedModel].sex intValue] == 1) {
                    despLabel4.text = @"男";
                }else if ([[UserBaseInfoModel sharedModel].sex intValue] == 2) {
                  despLabel4.text = @"女";
                }
            }
        }else{
            [self showError:self.view message:@"加载用户信息失败" afterHidden:3];
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)taped1Action {//:(UIGestureRecognizer *)reco
    //修改性别
    ChangeUserInfoViewController *vc = [[ChangeUserInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapedAction {//:(UIGestureRecognizer *)reco
    //修改姓名
    ChangeUserInfoViewController *vc = [[ChangeUserInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)clickChoseHeadImg {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择文件来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
    
}
//点击 认证按钮
- (void)clickAuthBtn {
    AuthenticationViewController *vc = [[AuthenticationViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    [self sendChangeUserIconRequestWithFile:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [self sendChangeUserIconRequestWithFile:info[UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//修改用户头像
-(void)sendChangeUserIconRequestWithFile:(UIImage *)image {
    
    NSString *url = [NSString stringWithFormat:@"%@v1/user/uploadPortrait/%@",DOMAIN_NAME,[UserModel sharedModel].userId];//[UserBaseInfoModel sharedModel].id
    
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"headImage.jpg" mimeType:@"image/png"];//application/octet-stream
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSLog(@"%@",dic);
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 1000) {
            
            self.headImg.image = image;
            //头像修改成功
            [self showSuccess:self.view message:@"头像修改成功" afterHidden:3];
            //同时保存到本地
            UserBaseInfoModel *model = [UserBaseInfoModel readFromLocal];
            model.portrait = [dic objectForKey:@"image"];
            [model writeToLocal];
            NSLog(@"%@",model.portrait);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoRefresh" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self showError:self.view message:@"头像保存失败" afterHidden:3];
    }];
    
}

- (void)loadUserInfoRequest {
    
    
    [[AINetworkEngine sharedClient] getWithApi:[NSString stringWithFormat:@"%@%@",API_GET_USERINFO_AUTH,[UserBaseInfoModel sharedModel].id] parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        [self loadingSubtractCount];
        if (result != nil) {
            if ([result isSucceed]) {
                
                NSDictionary *dic = [result getDataObj];
                NSLog(@"%@",dic);
                
                
            }
        } else {
            NSLog(@"请求失败");
        }
    }];

    
}

@end
