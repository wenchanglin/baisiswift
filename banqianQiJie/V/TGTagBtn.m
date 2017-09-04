//
//  TGTagBtn.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/20.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGTagBtn.h"
#import "UIView+TGSegment.h"
#define TagBgColor [UIColor whiteColor]//TGColor(74,139,209)
#define TagTitleColor TGColor(74,139,209)
#define TagFont [UIFont systemFontOfSize:14]

#define TGColor(r,g,b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

@implementation TGTagBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TagBgColor;
        [self setTitleColor:TagTitleColor forState:UIControlStateNormal];
        self.titleLabel.font = TagFont;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 3  * 5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = 5;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
}
@end
