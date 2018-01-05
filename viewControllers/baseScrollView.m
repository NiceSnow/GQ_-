//
//  baseScrollView.m
//  GQ_****
//
//  Created by Madodg on 2017/12/25.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "baseScrollView.h"

@interface baseScrollView ()<UIScrollViewDelegate>
@end

@implementation baseScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self defaultSet];
    }
    return self;
}

- (void)defaultSet {
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{


}
-( void )scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
