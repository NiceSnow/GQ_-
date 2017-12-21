//
//  UIFont+extension.m
//  GQ_****
//
//  Created by Madodg on 2017/12/1.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UIFont+extension.h"

@implementation UIFont (extension)
+(UIFont*)systemFont:(CGFloat)font{
    int height=(int) [UIScreen mainScreen].bounds.size.height;
    
    if(height==480){
        
        return [UIFont systemFontOfSize:font  weight:UIFontWeightThin];
        
    }else if (height==568){
        
        
        return [UIFont systemFontOfSize:font weight:UIFontWeightThin];
        
    }else if (height==667){
        
        return [UIFont systemFontOfSize:font+1 weight:UIFontWeightThin];
        
        
    }else if (height==736){
        
        return [UIFont systemFontOfSize:font+2 weight:UIFontWeightThin];
        
    }
    
    
    return [UIFont systemFontOfSize:font weight:UIFontWeightThin];
}
+ (UIFont *)boldFont:(CGFloat)font
{
    int height=(int) [UIScreen mainScreen].bounds.size.height;
    
    if(height==480){
        
        return [UIFont boldSystemFontOfSize:font];
        
    }else if (height==568){
        
        
        return [UIFont boldSystemFontOfSize:font];
        
    }else if (height==667){
        
        return [UIFont boldSystemFontOfSize:font+1];
        
        
    }else if (height==736){
        
        return [UIFont boldSystemFontOfSize:font+2];
        
    }
    
    
    return [UIFont boldSystemFontOfSize:font];
}
@end
