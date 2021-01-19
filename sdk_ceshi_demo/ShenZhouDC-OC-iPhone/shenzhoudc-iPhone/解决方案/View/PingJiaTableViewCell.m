//
//  PingJiaTableViewCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "PingJiaTableViewCell.h"
#import "StarView.h"

@interface PingJiaTableViewCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) StarView *starView;
@end

@implementation PingJiaTableViewCell

+ (instancetype)pingJiaCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    PingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
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
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.userName];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.sepLine];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(17);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).offset(6);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(_icon.mas_centerY);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-13-28-6-75-16-10);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userName.mas_right).offset(7);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(_icon.mas_centerY);
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(_icon.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(_time.mas_bottom).offset(8);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH-24);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(_content.mas_bottom).offset(30);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
}

- (void)refreshCell:(CommentModel*)model {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    self.userName.text = model.nickName;
    [self.starView star:model.score.integerValue];
    self.time.text = model.createTime;
    self.content.text = model.content;
}

- (void)refreshCell:(NSString *)icon nickName:(NSString *)nickName score:(int)score time:(NSString *)time content:(NSString *)content {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    self.userName.text = nickName;
    [self.starView star:score];
    self.time.text = time;
    self.content.text = content;
}

- (void)createCellWith:(DoubleCommentModel*)model {
    
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    self.userName.text = [NSString stringWithFormat:@"%@",model.sendId];
    [self.starView star:model.standard.integerValue];
    self.time.text = model.createTime;
    self.content.text = model.cause;
}
- (void)refreshCell {
    [self.icon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"user_icon"] options:SDWebImageProgressiveDownload];
    self.userName.text = @"我是用户";
    [self.starView star:3];
    self.time.text = @"2016-12-28";
    self.content.text = @"好用的很，大家都来购买试试吧。好用的很，大家都来购买试试吧。好用的很，大家都来购买试试吧。好用的很，大家都来购买试试吧。";
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 14;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:16];
        _userName.textColor = UIColorFromRGB(0x051B28);
    }
    return _userName;
}

- (StarView *)starView {
    if (!_starView) {
        _starView = [StarView createToSuperView:self.contentView];
    }
    return _starView;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = UIColorFromRGB(0x9F9F9F);
    }
    return _time;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize:16];
        _content.textColor = UIColorFromRGB(0x051B28);
        _content.numberOfLines = 0;
    }
    return _content;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }
    return _sepLine;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
