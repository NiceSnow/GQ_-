//
//  UIControl+LogSupport.m
//  GQ_****
//
//  Created by Madodg on 2017/12/14.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UIControl+LogSupport.h"

@implementation UIControl (LogSupport)

+ (void)load{
    swizzleMethod([self class], @selector(sendAction:to:forEvent:), @selector(GQ_sendAction:to:forEvent:));
    swizzleMethod([self class], @selector(init), @selector(GQ_init));
    swizzleMethod([self class], @selector(awakeFromNib), @selector(GQ_awakeFromNib));
}

- (void)GQ_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton* btn = (UIButton*)self;
        NSString *btnName = btn.currentTitle?[NSString stringWithFormat:@"%@_%@",NSStringFromClass([btn.viewController class]),btn.currentTitle]:[NSString stringWithFormat:@"%@_%@_%@",[btn.viewController class],btn.className, NSStringFromSelector(action)];
        [[GQLogManager instance] ButtonPressWithName:btnName];
    }
    if ([self isKindOfClass:[UITextField class]]) {
        
    }
    [self GQ_sendAction:action to:target forEvent:event];
}

- (instancetype)GQ_init{
    id privateSelf = [self GQ_init];
    [privateSelf addTarget:self action:@selector(GQ_startEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [privateSelf addTarget:self action:@selector(GQ_endEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [privateSelf addTarget:self action:@selector(GQ_textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    return privateSelf;
}

- (void)GQ_awakeFromNib {
    [self GQ_awakeFromNib];
    [self addTarget:self action:@selector(GQ_startEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(GQ_endEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(GQ_textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
}

-(void)GQ_startEditing:(UITextField*)textField{
    NSString *tfName = textField.placeholder?[NSString stringWithFormat:@"%@_%@",NSStringFromClass([textField.viewController class]),textField.placeholder]:[NSString stringWithFormat:@"%@_%@",[textField.viewController class],textField.className];
    [[GQLogManager instance] TextFieldBeginEditing:tfName];
}

-(void)GQ_endEditing:(UITextField*)textField{
    [[GQLogManager instance] TextFieldEndEditing];
}

-(void)GQ_textFieldEditing:(UITextField*)textField{
    [[GQLogManager instance] TextFieldChangedWithText:textField.text];
}

-(void)GQ_ButtonTouch:(UIButton*)btn{
    
}



@end
