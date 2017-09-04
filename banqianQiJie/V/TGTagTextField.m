//
//  TGTagTextField.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/20.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGTagTextField.h"
#import "UITextField+placeholder.h"
#import "UIView+frame.h"
@implementation TGTagTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用换行或者逗号隔开!";
        self.placeholderColor = [UIColor lightGrayColor];
        [self setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = 25;
    }
    return self;
}

- (void)deleteBackward{
    !_deleteBlock ? : _deleteBlock();
    [super deleteBackward];
}

@end
