//
//  MyRevicedOrderCell.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/7/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "MyRevicedOrderCell.h"

@interface MyRevicedOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *baojiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *technologyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation MyRevicedOrderCell

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
 
    self.baojiaLabel.text = [NSString stringWithFormat:@"我的报价：%@元",model.orderPrice];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
