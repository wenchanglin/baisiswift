//
//  UIColor+WCL.m
//  
//
//  Created by banbo on 2017/8/9.
//
//

#import "UIColor+WCL.h"

@implementation UIColor (WCL)
+(UIColor *)hcy_colorWithString:(NSString *)colorStr
{
    if (!colorStr || [colorStr isEqualToString:@""]) {
        return [UIColor blackColor];
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[colorStr substringWithRange:range]] scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;

}
+(UIColor *)hcy_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
     return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}
@end
