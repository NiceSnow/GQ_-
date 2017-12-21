//
//  GQ_LogBaseTableView.m
//  GQ_****
//
//  Created by Madodg on 2017/12/21.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "GQ_LogBaseTableView.h"

@interface GQ_LogBaseTableView ()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation GQ_LogBaseTableView

- (instancetype)initWithFrame:(CGRect)frame callbackIdentifier:(NSString *(^)(void))callbackIdentifier {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",contentOffsetY);
}
-( void )scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",contentOffsetY);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
