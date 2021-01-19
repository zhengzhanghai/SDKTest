//
//  ITServiceCell.m
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ITServiceCell.h"
#import "ITServiceModel.h"

@interface ITServiceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *technologyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOverTimeLabel;



@end

@implementation ITServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)makeITServiceCellWithModel:(ITServiceModel *)model {
    
    self.titleLabel.text = model.serviceContent;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",model.orderPrice];
    
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
    
    if(model.isovertime == 2){
    self.isOverTimeLabel.text = @"加班";
    }else if (model.isovertime == 1) {
        self.isOverTimeLabel.text = @"不加班";
    }else {
        self.isOverTimeLabel.text = @"";
    }
    
    
}
@end
