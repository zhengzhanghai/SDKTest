//
//  PublickDispatchViewController.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PublickDispatchViewController.h"
#import "SelectedImagesViewController.h"
#import "PublicDispatchCell.h"
#import "NSString+CustomString.h"
#import "AFNetWorking.h"


@interface PublickDispatchViewController ()<UITextViewDelegate,SelectedImagesViewControllerDelegate>
{
    UIView *alpheView;
    UILabel *laber;
    CGFloat vertical;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic , strong) UITextField *dispatchName;//派工名称
@property(nonatomic , strong) UITextField *dispatchPrice;//派工价格
@property(nonatomic , strong) UITextView *dispatchCharacteristics;//产品特征/描述
@property (nonatomic, strong) UILabel *placeHolderLabel;//占位符label

@property(nonatomic, strong) SelectedImagesViewController *photoVC;

@end

@implementation PublickDispatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.title = @"发布派工";
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeUI {
    
    UIButton *publicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-LandscapeNumber(50), SCREEN_WIDTH, LandscapeNumber(50))];
    publicBtn.backgroundColor = UIColorFromRGB(0xD71629);
    [publicBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publicBtn addTarget:self action:@selector(clickPublickBtn) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:publicBtn];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBARHEIGHT+STATUSBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-LandscapeNumber(50)-NAVBARHEIGHT-STATUSBARHEIGHT)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"派工名称";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColorFromRGB(0x3D4245);
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LandscapeNumber(16));
        make.top.mas_equalTo(LandscapeNumber(16));
        make.height.mas_equalTo(LandscapeNumber(17));
    }];
   
    self.dispatchName = [[UITextField alloc]init];
    self.dispatchName.font = [UIFont systemFontOfSize:16];
    self.dispatchName.textColor = UIColorFromRGB(0x666666);
    self.dispatchName.placeholder = @"请输入";
    self.dispatchName.tag = 0;
    [self.dispatchName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.dispatchName];
    [self.dispatchName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-LandscapeNumber(32), 48));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.dispatchName.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.text = @"派工价格";
    titleLabel1.font = [UIFont systemFontOfSize:16];
    titleLabel1.textColor = UIColorFromRGB(0x3D4245);
    [self.scrollView addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(line1.mas_bottom).with.offset(LandscapeNumber(16));
        make.height.mas_equalTo(LandscapeNumber(17));
    }];
    
    self.dispatchPrice = [[UITextField alloc]init];
    self.dispatchPrice.font = [UIFont systemFontOfSize:16];
    self.dispatchPrice.textColor = UIColorFromRGB(0x666666);
    self.dispatchPrice.placeholder = @"¥ 请输入";
    self.dispatchPrice.keyboardType = UIKeyboardTypeNumberPad;
    self.dispatchPrice.tag = 1;
    [self.dispatchPrice addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:self.dispatchPrice];
    [self.dispatchPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dispatchName.mas_left);
        make.top.mas_equalTo(titleLabel1.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-LandscapeNumber(32), 48));
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.scrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.dispatchPrice.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"产品特性与价值";
    titleLabel2.font = [UIFont systemFontOfSize:16];
    titleLabel2.textColor = UIColorFromRGB(0x3D4245);
    [self.scrollView addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(line2.mas_bottom).with.offset(LandscapeNumber(16));
        make.height.mas_equalTo(LandscapeNumber(17));
    }];
    
    self.dispatchCharacteristics = [[UITextView alloc]init];
    self.dispatchCharacteristics.font = [UIFont systemFontOfSize:16];
    self.dispatchCharacteristics.textColor = UIColorFromRGB(0x666666);
    self.dispatchCharacteristics.delegate = self;
    self.dispatchCharacteristics.scrollEnabled = NO;
    [self.scrollView addSubview:self.dispatchCharacteristics];
    [self.dispatchCharacteristics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel2.mas_bottom).with.offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH-LandscapeNumber(32));
        make.height.mas_greaterThanOrEqualTo(LandscapeNumber(120));
    }];
    
    
    
    self.placeHolderLabel = [[UILabel alloc]init];
    self.placeHolderLabel.text = @"请输入";
    self.placeHolderLabel.font = [UIFont systemFontOfSize:16];
    self.placeHolderLabel.textColor = UIColorFromRGB(0xC7C7CD);
    [self.dispatchCharacteristics addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dispatchCharacteristics.mas_left).with.offset(5);
        make.top.mas_equalTo(self.dispatchCharacteristics.mas_top).with.offset(5);
    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.dispatchCharacteristics.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    
    
    UILabel *titleLabel3 = [[UILabel alloc]init];
    titleLabel3.text = @"上传照片";
    titleLabel3.font = [UIFont systemFontOfSize:16];
    titleLabel3.textColor = UIColorFromRGB(0x3D4245);
    [self.scrollView addSubview:titleLabel3];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(line3.mas_bottom).with.offset(LandscapeNumber(16));
        make.height.mas_equalTo(LandscapeNumber(17));
    }];
    
    //照片选择
    UIView *photoView = [[UIView alloc] init];
    [self.scrollView addSubview:photoView];
    photoView.layer.masksToBounds = YES;
    photoView.layer.cornerRadius = 4;
    photoView.backgroundColor = [UIColor clearColor];
//    photoView.backgroundColor = [UIColor yellowColor];
    self.photoVC = [[SelectedImagesViewController alloc] init];
    self.photoVC.delegate = self;
    self.photoVC.photoCount = 9;
    [self addChildViewController:self.photoVC];
    [photoView addSubview:self.photoVC.view];
    [self.photoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_top);
        make.left.mas_equalTo(photoView.mas_left);
        make.right.mas_equalTo(photoView.mas_right);
        make.bottom.mas_equalTo(photoView.mas_bottom);
    }];
    
  
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel3.mas_left);
        make.top.mas_equalTo(titleLabel3.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - LandscapeNumber(32), ((self.photoVC.photos.count+1)/3+1)*270 - 5));
         make.bottom.mas_equalTo(self.scrollView.mas_bottom).with.offset(-16);

    }];
    
    
//    vertical = CGRectGetMinY(photoView.frame);
//    photoView.frame = CGRectMake(0, vertical, SCREEN_WIDTH, 20+((self.photoVC.photos.count+1)/3+1)*80);
    /*
    if (self.publickType == 1 || self.publickType == 2) {
    
        laber = [[UILabel alloc]init];
        laber.text = @"上传附件";
        laber.textColor = UIColorFromRGB(0xD71629);
        laber.font = [UIFont systemFontOfSize:16];
        [self.scrollView addSubview:laber];
        [laber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel3.mas_left);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(photoView.mas_bottom).with.offset(15);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = UIColorFromRGB(0xD71629);
        [self.scrollView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(laber.mas_bottom);
            make.left.mas_equalTo(laber.mas_left);
            make.right.mas_equalTo(laber.mas_right);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.scrollView.mas_bottom).with.offset(-16);
        }];
        
        
        UIButton *pubBtn = [[UIButton alloc]init];
        [pubBtn addTarget:self action:@selector(clickPub) forControlEvents:UIControlEventTouchUpInside];
        pubBtn.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:pubBtn];
        [pubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(laber.mas_left);
             make.top.mas_equalTo(laber.mas_top);
             make.right.mas_equalTo(laber.mas_right);
             make.bottom.mas_equalTo(lineV.mas_bottom);
        }];
        
    }
    */
 
}

-(void)reloadUI{
    
       [self.scrollView reloadInputViews];
}

- (void)clickPub {
    alpheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    alpheView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:alpheView];
    
    UIView *whiteV = [[UIView alloc]init];
    whiteV.backgroundColor = [UIColor whiteColor];
    [alpheView addSubview:whiteV];
    [whiteV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alpheView.mas_centerX);
        make.centerY.mas_equalTo(alpheView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(280), LandscapeNumber(161)));
    }];
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = @"提示";
    titleL.textColor = UIColorFromRGB(0x0F0F0F);
    titleL.font = [UIFont systemFontOfSize:16];
    [whiteV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteV.mas_centerX);
        make.top.mas_equalTo(whiteV.mas_top).with.offset(LandscapeNumber(16));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xECECEC);
    [whiteV addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(titleL.mas_bottom).with.offset(LandscapeNumber(16));
        make.height.mas_equalTo(1);
    }];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.text = @"上传附件请到PC端操作";
    msgLabel.textColor = UIColorFromRGB(0x3D3D3D);
    msgLabel.font = [UIFont systemFontOfSize:16];
    [whiteV addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteV.mas_centerX);
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(LandscapeNumber(20));
    }];
    
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(clickReadBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0xD71629);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [whiteV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteV.mas_centerX);
        make.top.mas_equalTo(msgLabel.mas_bottom).with.offset(LandscapeNumber(20));
        make.bottom.mas_equalTo(-LandscapeNumber(16));
        make.width.mas_equalTo(LandscapeNumber(120));
    }];

}

- (void)clickReadBtn {
    [alpheView removeFromSuperview];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@",textView.text);
    
    if (textView.text.length != 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
    
    bool isChinese;//判断当前输入法是否是中文
    ////iOS7.0之后使用
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }else{
        isChinese = true;
    }
    
    //要求输入最多400位字符
    NSString *str = [[textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"输入的是汉字");
            if ( str.length>=151) {
                NSString *strNew = [NSString stringWithString:str];
                [textView setText:[strNew substringToIndex:150]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }else{
            NSLog(@"输入的英文还没有转化为汉字的状态");
        }
    }else{
        NSLog(@"str=%@; 本次长度=%lu",str,(unsigned long)[str length]);
        if ([str length]>=151) {
            NSString *strNew = [NSString stringWithString:str];
            [textView setText:[strNew substringToIndex:150]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }

}
- (void) textFieldDidChange:(UITextField *) TextField{
    
    if (TextField.tag == 0) {
        //监听派工名称的输入
        NSLog(@"🌲🌲🌲 -->> %@",TextField.text);
    }
    if (TextField.tag == 1) {
        //监听派工价格的输入
         NSLog(@"㊗️㊗️㊗️ -->> %@",TextField.text);
    }
}

//点击 发布按钮
-(void)clickPublickBtn {

    if (self.dispatchName.text.length == 0) {
        //派工名称不能为空
        return;
    }else if (self.dispatchPrice.text.length == 0) {
        //派工价格不能为空
        return;
    }else if (self.dispatchCharacteristics.text.length == 0) {
        //派工描述不能为空
        return;
    }else if (self.photoVC.photos.count == 0) {
        //至少要上传一张图片
        return;
    }
    
    //发送上传派工的网络请求
    [self sendDispatchInfoToServer];
    [self loadingAddCountToView:self.view];
  
}

-(void)sendDispatchInfoToServer {
    
    __weak PublickDispatchViewController *selfVC = self;
    
    NSString *url = [NSString stringWithFormat:@"%@v1/assign/save",DOMAIN_NAME];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [UserBaseInfoModel sharedModel].id;
    params[@"name"] = self.dispatchName.text;
    params[@"price"] = self.dispatchPrice.text;
    params[@"desp"] = self.dispatchCharacteristics.text;
    
    NSLog(@"%@ <<<<<<-------->>>>>> %@",params,url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < selfVC.photoVC.photos.count; i++) {
            UIImage *image1 = selfVC.photoVC.photos[i];
            UIImage *image = [selfVC fixrotation:image1];
            
            NSString *name = [NSString stringWithFormat:@"file%d",i+1];
            NSString *fileName = [NSString stringWithFormat:@"file%d.png",i+1];
            NSData* data = UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];//application/octet-stream
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
      CGFloat  progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"赋值image:%@",[NSThread currentThread]);
//            loop.progress = progress;
//            [selfVC.view addSubview:loop];
        });
        
        
        NSLog(@"ceshi   %f", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Success = %@", responseObject);
        
        int code = [[responseObject objectForKey:@"code"] intValue];
        //上传成功
        if (code == 1000) {
            [self loadingSubtractCount];
            [self showSuccess:self.view message:@"上传成功" afterHidden:3];
            NSLog(@"全部上传成功了");
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self loadingSubtractCount];
        [self showError:self.view message:@"上传失败" afterHidden:3];
        NSLog(@"Failure %@", error.description);
    }];

    
    
    
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

@end
