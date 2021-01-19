//
//  MySendCell.h
//  shenzhoudc-iPhone
//
//  Created by zhangdan on 17/4/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySendModel;
@class MyRecievedModel;

@protocol CancelDelegate <NSObject>

@optional

-(void)buttonClick:(UIButton *)sender;

@end



@interface MySendCell : UITableViewCell
- (void)makeITSendCellWithModel:(MySendModel *)model;
- (void)makeITSendCellWithRecieveModel:(MyRecievedModel *)model;
@property(nonatomic,weak) id<CancelDelegate> delegate;


@property(nonatomic, strong)UIButton *buttonClick;
@end
