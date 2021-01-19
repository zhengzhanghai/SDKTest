//
//  SwiftCountdownButton.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SwiftCountdownButton.h"


@interface SwiftCountdownButton ()

@property(nonatomic ,assign) int second;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSString *normalText;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) NSString *disabledText;
@property (nonatomic, strong) UIColor *disabledTextColor;
@property (nonatomic, strong) UIColor *backGroundColor;

@end

@implementation SwiftCountdownButton

-(void)awakeFromNib {
    [super awakeFromNib];
//  self.maxSecond = 30;
    self.second = 0;
    self.countdown = NO;
    [self addObserver:self forKeyPath:@"countdown" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self setupLabel];
}


-(instancetype)init {
    if ([super init]) {

        [self addObserver:self forKeyPath:@"countdown" options: NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
        
        self.countdown = NO;
//      self.maxSecond = 30;
        self.second = 0;
        [self setupLabel];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //keyPath:被监听的属性名
    //ofObject:被监听的对象
    //change：被监听属性的值包括新值和旧值
//    BOOL oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//    
//    if (self.countdown != oldValue) {
    
        self.countdown ?[self startCountdown] : [self stopCountdown];
        
//    }
    
}
- (void)dealloc {
    self.countdown = NO;
    [self removeObserver:self forKeyPath:@"countdown"];
}

-(void)setupLabel {
    
    self.normalText = [self titleForState:UIControlStateNormal];
    self.disabledText = [self titleForState:UIControlStateDisabled];
    self.normalTextColor = [self titleColorForState:UIControlStateNormal];
    self.disabledTextColor = [self titleColorForState:UIControlStateDisabled];
    self.timeLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = self.titleLabel.font;
    self.timeLabel.textColor = self.normalTextColor;
    self.timeLabel.text = self.normalText;
    self.backGroundColor = self.backgroundColor;
    [self addSubview:self.timeLabel];
}

-(void)startCountdown {
    
    self.second = self.maxSecond;
    [self updateDisabled];
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
    
}

-(void)updateDisabled {
    self.enabled = NO;
    self.timeLabel.textColor = self.disabledTextColor;
    self.timeLabel.text = [NSString stringWithFormat:@"%d s",self.second];
    NSLog(@"%@",self.timeLabel.text);
    [self setTitle:self.timeLabel.text forState:UIControlStateDisabled];
}

-(void)updateCountdown {
    if (--self.second <= 0) {
        self.countdown = NO;
    }else {
        [self updateDisabled];
    }
   
}

-(void)stopCountdown {
    [self.timer invalidate];
    self.timer = nil;
    [self updateNormal];
    self.timeLabel.text = @"点击重新获取";
    [self setTitle:self.timeLabel.text forState:UIControlStateNormal];
}

-(void)updateNormal {
    self.enabled = YES;
    self.timeLabel.textColor = self.normalTextColor;
    self.timeLabel.text = self.normalText;
    
}




@end
