//
//  PopMenuView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PopMenuView.h"
#import "AppDelegate.h"
#import "PopMenuViewCell.h"
#define KEY_WINDOW_ENABLE(value) UIApplication.sharedApplication.delegate.window.userInteractionEnabled = value

@interface PopMenuView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat arrowCenterX;
@property (copy, nonatomic)   NSArray *titles;
@end

@implementation PopMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (instancetype)initWithShapeLayerFrame:(CGRect)frame withArrowCenterX:(CGFloat)arrowCenterX titles:(NSArray *)titles {
    if ([super init]) {
        _arrowCenterX = arrowCenterX;
        _titles = titles;
        [self addShapeLayerWithFrzme:frame withArrowCenterX:arrowCenterX];
//        [self addTapGesture];
        [self makeTableView];
    }
    return self;
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    if (_clickSelfBlock) {
        _clickSelfBlock();
    }
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 10.f, _backgroundView.width, _backgroundView.height-10.f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_backgroundView addSubview:_tableView];
}

- (void)addShapeLayerWithFrzme:(CGRect)frame withArrowCenterX:(CGFloat)arrowCenterX {
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.frame = frame;
//    _backgroundView.layer.anchorPoint = CGPointMake((arrowCenterX-frame.size.width)/frame.size.width, 0.5f);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(arrowCenterX-frame.origin.x, 0.f)];
    [path addLineToPoint:CGPointMake(arrowCenterX-frame.origin.x-7.f, 10.f)];
    [path addLineToPoint:CGPointMake(0, 10.f)];
    [path addLineToPoint:CGPointMake(0, frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.size.width, 10.f)];
    [path addLineToPoint:CGPointMake(arrowCenterX-frame.origin.x+7.f, 10.f)];
    [path addLineToPoint:CGPointMake(arrowCenterX-frame.origin.x, 0)];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    _shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 1.f;
    
    [_backgroundView.layer addSublayer:_shapeLayer];
}

- (void)showWithAnimation:(NSTimeInterval)time completed:(void (^)())completed {
    [self addSubview:_backgroundView];
    _backgroundView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    KEY_WINDOW_ENABLE(false);
    [UIView animateWithDuration:time animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        _backgroundView.transform = CGAffineTransformMakeScale(1.f,1.f);
    } completion:^(BOOL finished) {
        KEY_WINDOW_ENABLE(true);
        if (completed) {
            completed();
        }
    }];
}

- (void)hiddenWithAnimation:(NSTimeInterval)time completed:(void (^)())completed {
    KEY_WINDOW_ENABLE(false);
    [UIView animateWithDuration:time animations:^{
        _backgroundView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    } completion:^(BOOL finished) {
        KEY_WINDOW_ENABLE(true);
        if (completed) {
            completed();
        }
    }];
}

#pragma mark  --------- UITableViewDelegate, UITableViewDataSource -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopMenuViewCell *cell = [PopMenuViewCell createCell:tableView indexPath:indexPath];
    [cell configWIthTitle:_titles[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_clickCellBlock) {
        _clickCellBlock(indexPath.row, _titles[indexPath.row]);
    }
}
@end
