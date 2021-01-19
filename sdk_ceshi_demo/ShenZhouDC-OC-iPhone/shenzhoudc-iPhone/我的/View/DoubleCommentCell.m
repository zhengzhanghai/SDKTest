//
//  DoubleCommentCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "DoubleCommentCell.h"
#import "StarView.h"

@interface DoubleCommentCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *sepLine;

@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) StarView *starView1;
@property (nonatomic, strong) StarView *starView2;

@property(nonatomic,strong) UILabel *laber1;
@property(nonatomic,strong) UILabel *laber2;
@property(nonatomic,strong) UILabel *laber3;

@end

@implementation DoubleCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)DoubleCommentCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    DoubleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubView];
    }
    return self;
}


- (void)addSubView {
    
    _userName = [[UILabel alloc] init];
    _userName.font = [UIFont systemFontOfSize:16];
    _userName.textColor = UIColorFromRGB(0x051B28);
    [self.contentView addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.height.mas_equalTo(22);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    _laber1 = [[UILabel alloc]init];
    _laber1.textColor = UIColorFromRGB(0x333333);
    _laber1.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_laber1];
    [_laber1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_userName.mas_bottom).with.offset(15);
    }];
    
    _starView = [StarView createToSuperView:self.contentView];
    [self.contentView addSubview:_starView];
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_laber1.mas_right).with.offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(_laber1.mas_centerY);
    }];
    
    _laber2 = [[UILabel alloc]init];
    _laber2.textColor = UIColorFromRGB(0x333333);
    _laber2.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_laber2];
    [_laber2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_starView.mas_bottom).with.offset(15);
    }];
    
    _starView1 = [StarView createToSuperView:self.contentView];
    [self.contentView addSubview:_starView1];
    [_starView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_laber2.mas_right).with.offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(_laber2.mas_centerY);
    }];
    
    
    _laber3 = [[UILabel alloc]init];
    _laber3.textColor = UIColorFromRGB(0x333333);
    _laber3.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_laber3];
    [_laber3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_starView1.mas_bottom).with.offset(15);
    }];
    
    _starView2 = [StarView createToSuperView:self.contentView];
    [self.contentView addSubview:_starView2];
    [_starView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_laber3.mas_right).with.offset(5);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(_laber3.mas_centerY);
    }];
    
    

    _time = [[UILabel alloc] init];
    _time.font = [UIFont systemFontOfSize:12];
    _time.textColor = UIColorFromRGB(0x9F9F9F);
    [self.contentView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.top.equalTo(_starView2.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    _content = [[UILabel alloc] init];
    _content.font = [UIFont systemFontOfSize:16];
    _content.textColor = UIColorFromRGB(0x051B28);
    _content.numberOfLines = 0;
    [self.contentView addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userName.mas_left);
        make.top.equalTo(_time.mas_bottom).offset(8);
        make.width.mas_equalTo(SCREEN_WIDTH-20);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    _sepLine = [[UIView alloc] init];
    _sepLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:_sepLine];
    [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_content.mas_bottom).offset(30);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
}



//- (UILabel *)userName {
//    if (!_userName) {
//        _userName = [[UILabel alloc] init];
//        _userName.font = [UIFont systemFontOfSize:16];
//        _userName.textColor = UIColorFromRGB(0x051B28);
//    }
//    return _userName;
//}
//
//- (StarView *)starView {
//    if (!_starView) {
//        _starView = [StarView createToSuperView:self.contentView];
//    }
//    return _starView;
//}
//
//- (UILabel *)time {
//    if (!_time) {
//        _time = [[UILabel alloc] init];
//        _time.font = [UIFont systemFontOfSize:12];
//        _time.textColor = UIColorFromRGB(0x9F9F9F);
//    }
//    return _time;
//}
//
//- (UILabel *)content {
//    if (!_content) {
//        _content = [[UILabel alloc] init];
//        _content.font = [UIFont systemFontOfSize:16];
//        _content.textColor = UIColorFromRGB(0x051B28);
//        _content.numberOfLines = 0;
//    }
//    return _content;
//}
//
//- (UIView *)sepLine {
//    if (!_sepLine) {
//        _sepLine = [[UIView alloc] init];
//        _sepLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
//    }
//    return _sepLine;
//}

- (void)createDoubleCommentCellWith:(DoubleCommentModel*)model {
    
    //    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    
    if ([model.observer intValue] == 1) {
        self.userName.text = @"接单人评价";
        _laber1.text = @"需求符合度：";
        _laber2.text = @"配合程度：";
        _laber3.text = @"整体评价：";
         [self.starView star:model.demandCompliance.integerValue];
        [self.starView1 star:model.cooperate.integerValue];
        
    }else if([model.observer intValue] == 2){
       self.userName.text = @"发单人评价";
        _laber1.text = @"技术水平：";
        _laber2.text = @"服务态度：";
        _laber3.text = @"整体评价：";
         [self.starView star:model.standard.integerValue];
        [self.starView1 star:model.customers.integerValue];
    }
    
    [self.starView2 star:model.global.integerValue];
    self.time.text = model.createTime;
    self.content.text = model.cause;
}
@end
