//
//  ProductWheelView.m
//  shenzhoudc-iPhone
//
//  Created by Harious on 2017/10/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductWheelView.h"

#define kTag 100
@interface ProductWheelView() {
    CGFloat _lastPointAngle;//上一个点相对于x轴角度
    CGPoint _centerPoint;
    CGFloat _deltaAngle;
    CGFloat _radius;
    CGFloat _lastImgViewAngle;
}
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIButton *closeBtn;
@end
@implementation ProductWheelView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 100;
        self.clipsToBounds = true;
    }
    return self;
}

- (void)clickClose {
    NSLog(@"点击关闭");
    if (_closeBlock) {
        _closeBlock();
    }
}

- (void)clickItem:(UIButton *)btn {
    NSLog(@"%zd", btn.tag - kTag);
    if (_didselectedBlock) {
        _didselectedBlock(btn.tag - kTag);
    }
}

- (void)customUI {
    CGFloat centerX = CGRectGetWidth(self.frame) * 0.5f;
    CGFloat centerY = centerX;
    _centerPoint = CGPointMake(centerX, centerY);//中心点
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(0, 0, 50, 50);
    [_closeBtn setImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    _closeBtn.center = _centerPoint;
    [_closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    _deltaAngle = M_PI / 1.5f;//6个imgView的间隔角度
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    CGFloat imgViewW = 50;
    CGFloat imgViewH = imgViewW;
    _radius = centerX - imgViewW * 0.5f;//imgView.center到self.center的距离
    for (int i = 0; i < 3; i++) {
        currentAngle = _deltaAngle * i;
        imgViewCenterX = centerX + _radius * sin(currentAngle);
        imgViewCenterY = centerY - _radius * cos(currentAngle);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, imgViewW, imgViewH);
        btn.tag = kTag + i;
        btn.center = _centerPoint;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"product_screen_%d", i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [UIView animateWithDuration:0.5 animations:^{
            btn.center = CGPointMake(imgViewCenterX, imgViewCenterY);
        }];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //计算上一个点相对于x轴的角度
    CGFloat lastPointRadius = sqrt(pow(point.y - _centerPoint.y, 2) + pow(point.x - _centerPoint.x, 2));
    if (lastPointRadius == 0) {
        return;
    }
    _lastPointAngle = acos((point.x - _centerPoint.x) / lastPointRadius);
    if (point.y > _centerPoint.y) {
        _lastPointAngle = 2 * M_PI - _lastPointAngle;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    //1.计算当前点相对于x轴的角度
    CGFloat currentPointRadius = sqrt(pow(currentPoint.y - _centerPoint.y, 2) + pow(currentPoint.x - _centerPoint.x, 2));
    if (currentPointRadius == 0) {//当点在中心点时，被除数不能为0
        return;
    }
    CGFloat curentPointAngle = acos((currentPoint.x - _centerPoint.x) / currentPointRadius);
    if (currentPoint.y > _centerPoint.y) {
        curentPointAngle = 2 * M_PI - curentPointAngle;
    }
    //2.变化的角度
    CGFloat angle = _lastPointAngle - curentPointAngle;
    
    _closeBtn.transform = CGAffineTransformRotate(_closeBtn.transform, angle);
    
    _lastImgViewAngle = fmod(_lastImgViewAngle + angle, 2 * M_PI);//对当前角度取模
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [self viewWithTag:kTag];
        currentAngle = _deltaAngle * i + _lastImgViewAngle;
        imgViewCenterX = _centerPoint.x + _radius * sin(currentAngle);
        imgViewCenterY = _centerPoint.x - _radius * cos(currentAngle);
        imgView = [self viewWithTag:kTag + i];
        imgView.center = CGPointMake(imgViewCenterX, imgViewCenterY);
    }
    
    _lastPointAngle = curentPointAngle;
}
@end


