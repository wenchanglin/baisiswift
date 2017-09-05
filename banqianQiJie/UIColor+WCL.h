//
//  UIColor+WCL.h
//  
//
//  Created by banbo on 2017/8/9.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (WCL)
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;
@end
