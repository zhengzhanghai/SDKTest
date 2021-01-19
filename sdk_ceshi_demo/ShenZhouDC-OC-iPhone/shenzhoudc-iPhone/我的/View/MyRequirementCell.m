//
//  MyRequirementCell.m
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "MyRequirementCell.h"


@interface MyRequirementCell ()

@property (nonatomic, strong) NSIndexPath* indexPath;

@end
@implementation MyRequirementCell

+ (MyRequirementCell*) makeMyRequirementCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier =  NSStringFromClass([MyRequirementCell class]);
    [tableView registerClass:[MyRequirementCell class] forCellReuseIdentifier:reuseIdentifier];
    MyRequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return  cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeCell];
    }
    
    return self;
    
}

-(void)makeCell {
    
    self.icon = [[UIImageView alloc]init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(LandscapeNumber(85), LandscapeNumber(85)));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x484848);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).with.offset(10);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
        make.top.mas_equalTo(self.mas_top).with.offset(13);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0x484848);
    label.text = @"行业分类：";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    
    self.categoryLabel = [[UILabel alloc]init];
    self.categoryLabel.font = [UIFont systemFontOfSize:14];
    self.categoryLabel.textColor = UIColorFromRGB(0x484848);
    [self addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).with.offset(2);
        make.centerY.mas_equalTo(label.mas_centerY);
    }];
   
    self.accessLabel = [[UILabel alloc]init];
    self.accessLabel.numberOfLines = 0;
    self.accessLabel.font = [UIFont systemFontOfSize:10];
    self.accessLabel.textColor = UIColorFromRGB(0x9B9B9B);
    [self addSubview:self.accessLabel];
    [self.accessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.categoryLabel.mas_bottom).with.offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-13);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
}

-(void)makeMyRequirementCellWithModel:(PaiModel *)model {
    
    self.titleLabel.text = @"软件定义网络（SDN）SDN技术应用于数据中心网络";
    self.categoryLabel.text = @"政务";
    self.accessLabel.text = @"智能路由平台支持语音呼叫、Email呼叫、传真呼叫、Web呼叫、社交媒体呼叫等，使得联络中心由传统语....";
    self.icon.image = [UIImage imageNamed:@"all_placeholder"];
    if (model != nil) {
        self.titleLabel.text = model.name;
        //    self.categoryLabel.text = model.names;
        self.accessLabel.text = model.desp;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"列表默认图"]];
        
    }
    
    
}

@end
