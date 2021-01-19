//
//  EvaluateView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "EvaluateView.h"
#import "SZStarView.h"

@interface EvaluateView ()
@property (copy, nonatomic)   NSArray *startViewArray;
@property (strong, nonatomic) UITextView *textView;
@end
@implementation EvaluateView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    if ([super initWithFrame:frame]) {
        [self createUI:titles type:false];
    }
    return self;
}

- (instancetype)initSolutionWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles {
    if ([super initWithFrame:frame]) {
        [self createUI:titles type:true];
    }
    return self;
}

- (void)createUI:(NSArray <NSString *>*)titles type:(BOOL)type {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-300, SCREEN_WIDTH, 300)];
    
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    if (type) {
        contentView.y = 0;
        contentView.height = self.height;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableArray *startViews = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSUInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+i*(30+10), 90, 30)];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:15];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:label];
        
        SZStarView *startView = [[SZStarView alloc] initWithFrame:CGRectMake(115, 10+i*(30+10), 150, 30)];
        [contentView addSubview:startView];
        [startViews addObject:startView];
    }
    _startViewArray = startViews;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titles.count*40 + 20, SCREEN_WIDTH-30, 80)];
    if (type) {
        _textView.height = 150;
    }
    _textView.backgroundColor = UIColorFromRGB(0xeeeeee);
    _textView.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:_textView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, contentView.height-40, SCREEN_WIDTH, 40);
    sureBtn.backgroundColor = [UIColor redColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    
    
}

- (void)clickSure {
    if (_finishEvalueBlock) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:_startViewArray.count];
        for (NSUInteger i = 0; i < _startViewArray.count; i++) {
            SZStarView *startView = _startViewArray[i];
            [array addObject:startView.starStr];
        }
        _finishEvalueBlock(array, _textView.text);
    }
}

@end













