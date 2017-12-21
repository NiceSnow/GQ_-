//
//  UILabel+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)
- (void)alignmentTwoSides
{
    [self layoutIfNeeded];
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size;
    if (self.text.length > 1) {
        CGFloat margin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
        NSNumber *number = [NSNumber numberWithFloat:margin];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
        self.attributedText = attributeString;
    }
}

- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

-(void)setSpacing:(CGFloat)spacing withText:(NSString*)text numberOfLine:(NSInteger)line;{
    if (text.length<=0||!self||!spacing) {
        return;
    }
    self.numberOfLines = line;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spacing];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];
}

- (void)bottomAlignment{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;
    
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

- (void)topAlignment{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;
    
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}
@end
