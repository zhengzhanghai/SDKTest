//
//  EditInformationViewController.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/28.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import "BaseViewController.h"


typedef void(^detailBlock)(NSString*);

@interface EditInformationViewController : BaseViewController

@property (nonatomic, copy) detailBlock detailBlock;
@property (nonatomic, strong) UITextField *detailTextField;

@end
