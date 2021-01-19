//
//  TagView.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "TagView.h"
#import "NSString+CustomString.h"


@interface TagView ()
{
    UIButton *selectedBtn;
}

@end

@implementation TagView

- (id)initWithFrame:(CGRect)frame AndDataSource:(NSArray *)dataArray{
    self = [super initWithFrame:frame];
    if (self) {
        _tagsArray = dataArray;
        [self makeUIView];
    }
    return self;
}
- (id)initWithDataArray:(NSArray *)array {
    if (self = [super init]) {
        _tagsArray = array;
        [self makeUIView];
    }
    return self;
}

- (id)initWithArray:(NSArray *)arr {
    if (self = [super init]) {
        _tagsArray = arr;
        [self createUIView];
    }
    return self;
}

- (void)createUI {
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 20;//用来控制button距离父视图的高
    for (int i = 0; i < _tagsArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor greenColor];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [_tagsArray[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        [button setTitle:_tagsArray[i] forState:UIControlStateNormal];
        
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length + 15 > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self addSubview:button];
    }
}
- (void)makeUIView {
    float b_x = 10;
    float b_y = 10;
    
    float height = LandscapeNumber(14);
    
    for (int i = 0; i < _tagsArray.count; i++) {
        
//        NSString *str = _tagsArray[i];
//        float strWidth = [str getWidthWithContent:str height:height font:9];
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
        CGFloat length = [_tagsArray[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        CGFloat strWidth = length + 10;
        
        if(10 + b_x + strWidth + 10 > SCREEN_WIDTH){
            b_x = 10; //换行时将w置为0
            b_y = b_y + height + 10;//距离父视图也变化  b_y += height+10;
        }
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x4990E2).CGColor;
        [button setTitle:_tagsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x4990E2) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.tag = i+1;
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(b_x);
            make.top.mas_equalTo(self.mas_top).with.offset(b_y);
            make.size.mas_equalTo(CGSizeMake(strWidth, height));
            if (i == _tagsArray.count-1) {
                make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
            }
        }];
        
        
        b_x = b_x + strWidth + 10;
    }
}

- (void)createUIView {
    
    NSString *str = @"工作年限：";
    CGFloat width = [str getWidthWithContent:str height:18 font:14];
    
    float b_x = 10;
    float b_y = 10;
    
    float height = LandscapeNumber(14);
    
    for (int i = 0; i < _tagsArray.count; i++) {
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9]};
        CGFloat length = [_tagsArray[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        CGFloat strWidth = length + 10;
        
        if(10 + b_x + strWidth + 10 > SCREEN_WIDTH-20-width){
            b_x = 10; //换行时将w置为0
            b_y = b_y + height + 10;//距离父视图也变化  b_y += height+10;
        }
        UIButton *button = [[UIButton alloc]init];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        [button setTitle:_tagsArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        button.tag = i+1;
        [button addTarget:self action:@selector(handButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(b_x);
            make.top.mas_equalTo(self.mas_top).with.offset(b_y);
            make.size.mas_equalTo(CGSizeMake(strWidth, height));
            if (i == _tagsArray.count-1) {
                make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10);
            }
        }];
        
        
        if (i == 0) {
            
            button.layer.borderColor = MainColor.CGColor;
            [button setTitleColor:MainColor forState:UIControlStateNormal];
            button.selected = YES;
            
            selectedBtn = button;
            
        }
        
        b_x = b_x + strWidth + 10;
    }
}


- (void)handleButton:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        sender.layer.borderColor = UIColorFromRGB(0x4990E2).CGColor;
        [sender setTitleColor:UIColorFromRGB(0x4990E2) forState:UIControlStateNormal];
    }else {
        NSLog(@"%@",sender.titleLabel.text);
        sender.selected = YES;
        sender.layer.borderColor = MainColor.CGColor;
        [sender setTitleColor:MainColor forState:UIControlStateNormal];
    }
    
    [self.delegate getLabelTag:sender.tag AndIsSelected:sender.selected];

    
}

- (void)handButton:(UIButton *)sender {
    
    if (!sender.selected) {
        
        selectedBtn.selected = !selectedBtn.selected;
        
        selectedBtn.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        [selectedBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        sender.selected = !sender.selected;
        
        sender.layer.borderColor = MainColor.CGColor;
        [sender setTitleColor:MainColor forState:UIControlStateNormal];
        
        selectedBtn = sender;
        
        [self.delegate getLabelTag:selectedBtn.tag AndIsSelected:sender.selected];

        
    }
    

}
@end
