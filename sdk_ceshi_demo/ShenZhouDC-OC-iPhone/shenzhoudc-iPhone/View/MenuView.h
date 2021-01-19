//
//  MenuView.h
//  shenzhoudc-iPhone
//
//  Created by 郑章海 on 17/2/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectMenuBlock)(NSInteger);

@interface MenuView : UITableView
@property (copy,   nonatomic) DidSelectMenuBlock selectBlock;
@end
