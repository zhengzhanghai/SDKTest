//
//  PublicDispatchCell.h
//  shenzhoudc-iPhone
//
//  Created by 张丹丹 on 16/12/29.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^nameBlock)(NSString*);

@interface PublicDispatchCell : UITableViewCell

@property(nonatomic , copy) nameBlock nameBlock;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *detailView;
@property (nonatomic, strong) UILabel *placeHolderLabel;


+ (PublicDispatchCell*) makePublickDispatchCell:(UITableView *)tableView WithIndexPath:(NSIndexPath *)indexPath;
@end
