//
//  PaiGongPulldownView.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/5.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "PaiGongPulldownView.h"

@interface PaiGongPulldownView ()
@property (copy, nonatomic)   NSArray *titles;
@property (copy, nonatomic)   NSArray *itemArray;
@property (copy, nonatomic)   NSArray *itemPointArray;
@end
@implementation PaiGongPulldownView

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles {
    if ([super initWithFrame:frame]) {
        _titles = titles;
        [self createaUI];
    }
    return self;
}

- (void)setTitle:(NSString *)title index:(NSInteger)index {
    PulldownBtn *btn = _itemArray[index];
    [btn modifyTitle:title];
}

- (void)createaUI {
    CGFloat edgeMargin = 20.f;
    CGFloat middleMargin = 20.f;
    CGFloat maxWidth = (self.width-2*edgeMargin-(_titles.count-1)*middleMargin)/_titles.count;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_titles.count];
    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:_titles.count];
    for (NSUInteger i = 0; i < _titles.count; i++) {
        PulldownBtn *pullDownBtn = [[PulldownBtn alloc] initWithTitle:_titles[i] norIcon:@"icon_down" selectedIcon:@"icon_up" itemTextMaxWidth:maxWidth-20.f];
        pullDownBtn.tag = i;
        [pullDownBtn modifyTitle:_titles[i]];
        [pullDownBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pullDownBtn];
        [pullDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0.f);
            make.height.mas_equalTo(20.f);
            make.centerX.mas_equalTo(edgeMargin+i*(middleMargin+maxWidth)+maxWidth/2-self.width/2);
        }];
        [array addObject:pullDownBtn];
        
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(edgeMargin+i*(middleMargin+maxWidth)+maxWidth/2, 35.f)];
        [pointArray addObject:pointValue];
        
        if (i != _titles.count-1) {
            UIView *sepLine = [[UIView alloc] init];
            sepLine.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:sepLine];
            [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(edgeMargin + i*(maxWidth+middleMargin)+maxWidth+middleMargin/2-1);
                make.centerY.mas_equalTo(0.f);
                make.width.mas_equalTo(2.f);
                make.height.mas_equalTo(20.f);
            }];
        }
    }
    _itemArray = array;
    _itemPointArray = pointArray;
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.frame = CGRectMake(0.f, self.height-0.5, self.width, 0.5);
    sepLine.backgroundColor = UIColorFromRGB(0x999999);
    [self addSubview:sepLine];
}

- (void)clickItem:(PulldownBtn *)btn {
    btn.customSelected = !btn.customSelected;
    if (_clickItemBlick) {
        _clickItemBlick(btn.tag);
    }
}

- (CGPoint)itemCenterWithIndex:(NSInteger)index {
    if (index >= _itemPointArray.count) {
        return CGPointZero;
    }
    NSValue *pointValue = _itemPointArray[index];
    return [pointValue CGPointValue];;
}

- (void)setItemSelected:(BOOL)selected atIndex:(NSInteger)index {
    if (index >= _itemPointArray.count) {
        return;
    }
    PulldownBtn *btn = _itemArray[index];
    btn.customSelected = selected;
}
@end

#pragma mark ---------------   PulldownBtn   ----------------
@interface PulldownBtn()
@property (copy, nonatomic)   NSString *norIcon;
@property (copy, nonatomic)   NSString *selectedIocn;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *icon;
@property (assign, nonatomic) CGFloat itemTextMaxWidth;
@end

@implementation PulldownBtn

- (instancetype)initWithTitle:(NSString *)title norIcon:(NSString *)norIcon selectedIcon:(NSString *)selectedIocn itemTextMaxWidth:(CGFloat)itemTextMaxWidth {
    if ([super init]) {
        _norIcon = norIcon;
        _selectedIocn = selectedIocn;
        _itemTextMaxWidth = itemTextMaxWidth;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _icon = [[UIImageView alloc] init];
    _icon.image = [UIImage imageNamed:_norIcon];
    [self addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0.f);
        make.centerY.mas_equalTo(0.f);
        make.width.mas_equalTo(15.f);
        make.height.mas_equalTo(15.f);
    }];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14.f];
    _textLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.centerY.mas_equalTo(0.f);
        make.height.mas_equalTo(20.f);
        make.right.equalTo(_icon.mas_left);
        make.width.mas_lessThanOrEqualTo(_itemTextMaxWidth);
    }];
    
}

- (void)setCustomSelected:(BOOL)customSelected {
    _customSelected = customSelected;
    if (_customSelected) {
        _icon.image = [UIImage imageNamed:_selectedIocn];
    } else {
        _icon.image = [UIImage imageNamed:_norIcon];
    }
}

- (void)modifyTitle:(NSString *)title {
    _textLabel.text = title;
}

@end
