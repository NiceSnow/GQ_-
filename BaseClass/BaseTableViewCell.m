//
//  BaseTableViewCell.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "BaseTableViewCell.h"
static NSString* iden;

@implementation BaseTableViewCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    NSString * classString = NSStringFromClass([self class]);
    iden = classString;
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[[NSBundle  mainBundle]  loadNibNamed:iden owner:self options:nil]  lastObject];
    }
    return cell;
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
