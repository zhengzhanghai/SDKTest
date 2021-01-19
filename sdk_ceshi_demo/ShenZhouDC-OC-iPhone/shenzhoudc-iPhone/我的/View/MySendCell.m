//
//  MySendCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MySendCell.h"
#import "MySendModel.h"
#import "MyRecievedModel.h"

@interface MySendCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *operationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *technologyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOverTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelRightMargin;

@property(nonatomic, strong)UILabel *priceLabel;

@end

@implementation MySendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.textColor = MainColor;
    
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 50, 120, 15)];
    _priceLabel.font = [UIFont systemFontOfSize:12.0f];
    _priceLabel.textColor = [UIColor darkGrayColor];
    _priceLabel.hidden = YES;
    [self.contentView addSubview:self.priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_addressLabel.mas_centerY);
    }];
    
    self.buttonClick = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonClick.backgroundColor = MainColor;
    self.buttonClick.layer.masksToBounds = YES;
    self.buttonClick.layer.cornerRadius = 2;
    self.buttonClick.frame = CGRectMake(SCREEN_WIDTH - 90, 10, 80, 30);
    [self.buttonClick setTitle:@"取消订单" forState:UIControlStateNormal];
    self.buttonClick.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.buttonClick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonClick addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonClick.hidden = YES;
    [self.contentView addSubview:self.buttonClick];
}

-(void)buttonClick:(UIButton *)sender{
    NSLog(@"点击 = %@",sender.currentTitle);
    if ([self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)makeITSendCellWithModel:(MySendModel *)model {
    self.titleLabel.text = model.serviceContent;
    self.addressLabel.text = model.serviceAddress;
    self.priceLabel.text = [NSString stringWithFormat:@"我的报价：%@元",model.orderPrice];;
    switch ([model.businessType intValue]) {
        case 1:
            self.operationTypeLabel.text = @"安装";
            break;
        case 2:
            self.operationTypeLabel.text = @"调试";
            break;
        case 3:
            self.operationTypeLabel.text = @"巡检";
            break;
        case 4:
            self.operationTypeLabel.text = @"故障处理";
            break;
        case 5:
            self.operationTypeLabel.text = @"培训";
            break;
        case 6:
            self.operationTypeLabel.text = @"售前交流";
            break;
        case 7:
            self.operationTypeLabel.text = @"测试";
            break;
            
        case 8:
            self.operationTypeLabel.text = @"其他";
            break;
            
        default:
            break;
    }
    
    
    switch ([model.technicalDirection intValue]) {
        case 1:
            self.technologyLabel.text = @"网络类";
            break;
        case 2:
            self.technologyLabel.text = @"安全类";
            break;
        case 3:
            self.technologyLabel.text = @"服务类";
            break;
        case 4:
            self.technologyLabel.text = @"开发类";
            break;
        case 5:
            self.technologyLabel.text = @"软件类";
            break;
        case 6:
            self.technologyLabel.text = @"储存类";
            break;
        case 7:
            self.technologyLabel.text = @"其他";
            break;
            
            
        default:
            break;
    }
    
    if([model.isovertime  isEqual: @2]){
        self.isOverTimeLabel.text = @"加班";
    }else if ([model.isovertime  isEqual: @1]) {
        self.isOverTimeLabel.text = @"不加班";
    }else {
        self.isOverTimeLabel.text = @"";
    }
    
    //0未报名 1已报名 2进行中 3已完工   发单人
    
    self.buttonClick.hidden = YES;
    self.priceLabel.hidden = NO;
    switch ([model.workType intValue]) {
        case -1:
            self.statusLabel.text = @"已取消";
            break;
        case 0:
            self.statusLabel.text = @"未报名";
            break;
        case 1:
            self.statusLabel.text = @"已报名";
            self.buttonClick.hidden = NO;
            [self.buttonClick setTitle:@"取消订单" forState:UIControlStateNormal];
            _titleLabelRightMargin.constant = 105;
            break;
        case 2:
            self.statusLabel.text = @"未付款";//接单人未付款
            self.buttonClick.hidden = NO;
            [self.buttonClick setTitle:@"去支付" forState:UIControlStateNormal];
            _titleLabelRightMargin.constant = 105;
            break;
        case 3:
            self.statusLabel.text = @"待接单";
            
            break;
        case 4:
            self.statusLabel.text = @"待开工";
           
            break;
        case 5:
            self.statusLabel.text = @"进行中";
            break;
        case 6:
            self.statusLabel.text = @"待验收";
            
            break;
        case 7:
            self.statusLabel.text = @"已完工";
            
            break;
        case 8:
            self.statusLabel.text = @"投诉中";
            break;
        case 9:
            self.statusLabel.text = @"已取消";//接单人取消
            break;
            
        default:
            break;
    }
    
}

- (void)makeITSendCellWithRecieveModel:(MyRecievedModel *)model {
    
    
    self.titleLabel.text = model.serviceContent;
    self.addressLabel.text = model.serviceAddress;
    
    switch ([model.businessType intValue]) {
        case 1:
            self.operationTypeLabel.text = @"安装";
            break;
        case 2:
            self.operationTypeLabel.text = @"调试";
            break;
        case 3:
            self.operationTypeLabel.text = @"巡检";
            break;
        case 4:
            self.operationTypeLabel.text = @"故障处理";
            break;
        case 5:
            self.operationTypeLabel.text = @"培训";
            break;
        case 6:
            self.operationTypeLabel.text = @"售前交流";
            break;
        case 7:
            self.operationTypeLabel.text = @"测试";
            break;
            
        case 8:
            self.operationTypeLabel.text = @"其他";
            break;
            
        default:
            break;
    }
    
    
    switch ([model.technicalDirection intValue]) {
        case 1:
            self.technologyLabel.text = @"网络类";
            break;
        case 2:
            self.technologyLabel.text = @"安全类";
            break;
        case 3:
            self.technologyLabel.text = @"服务类";
            break;
        case 4:
            self.technologyLabel.text = @"开发类";
            break;
        case 5:
            self.technologyLabel.text = @"软件类";
            break;
        case 6:
            self.technologyLabel.text = @"储存类";
            break;
        case 7:
            self.technologyLabel.text = @"其他";
            break;
            
            
        default:
            break;
    }
    
    if([model.isovertime  isEqual: @2]){
        self.isOverTimeLabel.text = @"加班";
    }else if ([model.isovertime  isEqual: @1]) {
        self.isOverTimeLabel.text = @"不加班";
    }else {
        self.isOverTimeLabel.text = @"";
    }
    
    
  
    self.buttonClick.hidden = YES;
    self.priceLabel.hidden = NO;
    self.priceLabel.text = [NSString stringWithFormat:@"我的报价：%@元",model.orderPrice];
    //
    
    switch ([model.serviceType intValue]) {
        case -1:
            self.statusLabel.text = @"已取消";
            break;
        case 0:
            self.statusLabel.text = @"已报名";
            break;
        case 1:
            self.statusLabel.text = @"待接单";
            
            break;
        case 2:
            self.statusLabel.text = @"未付款";
            self.buttonClick.hidden = NO;
            [self.buttonClick setTitle:@"去支付" forState:UIControlStateNormal];
            break;
        case 3:
            self.statusLabel.text = @"未开工";
            
            break;
        case 4:
            self.statusLabel.text = @"进行中";
            
            break;
        case 5:
            self.statusLabel.text = @"已完工";
            break;
        case 6:
            self.statusLabel.text = @"投诉中";
            break;
        case 7:
            self.statusLabel.text = @"发单人取消";
            break;
        default:
            break;
    }
    
}


@end
