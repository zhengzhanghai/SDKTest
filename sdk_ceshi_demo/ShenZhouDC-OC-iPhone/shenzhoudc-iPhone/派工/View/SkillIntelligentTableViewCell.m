//
//  SkillIntelligentTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by 潘奇 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "SkillIntelligentTableViewCell.h"
static CGFloat number = 1.0;
@interface SkillIntelligentTableViewCell ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *registerLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end


@implementation SkillIntelligentTableViewCell

+ (SkillIntelligentTableViewCell*)customCellWithTableView:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath{
    
    NSString *reString = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reString];
    return [tableView dequeueReusableCellWithIdentifier:reString forIndexPath:indexPath];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUi];
    }
    return  self;
}

- (void)setModel:(PaiModel *)model{
    
}

- (void)setUpUi{
    
    __weak typeof(self)weakSelf = self;
    _registerLabel = [[UILabel alloc]init];
    _registerLabel.text = @"注册时间";
    _registerLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_registerLabel];
    [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(16);
        make.top.equalTo(weakSelf.contentView).offset(12);
    }];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"2016-02-09";
    _timeLabel.textColor = [UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-16);
        make.top.equalTo(weakSelf.contentView).offset(14);
    }];
    
//    UITextView *textView = [[UITextView alloc]init];
//    textView.textContainer.lineBreakMode = NSLineBreakByTruncatingHead;
//    textView.scrollEnabled = NO;
//    textView.delegate = self;
//    textView.font = [UIFont systemFontOfSize:14];
//    textView.backgroundColor = [UIColor orangeColor];
//    [self.contentView addSubview:textView];
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf).offset(16);
//        make.width.mas_equalTo(70);
//        make.top.equalTo(_timeLabel.mas_bottom).offset(8);
//    }];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakSelf);
//        make.bottom.equalTo(textView.mas_bottom);
//    }];
    
}


//- (void)textViewDidChange:(UITextView *)textView
//{
//    NSLog(@"输入的内容=====%@",textView.text);
////    CGRect bounds = textView.bounds;
////    // 计算 text view 的高度
////    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
////    CGSize newSize = [textView sizeThatFits:maxSize];
////    bounds.size = newSize;
////    textView.bounds = bounds;
//    // 让 table view 重新计算高度
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}
//- (UITableView *)tableView
//{
//    UIView *tableView = self.superview;
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    return (UITableView *)tableView;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
