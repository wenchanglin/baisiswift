//
//  TGTabBar.m
//  baisibudejie
//
//  Created by targetcloud on 2017/3/6.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  Blog http://blog.csdn.net/callzjy
//  Mail targetcloud@163.com
//  Github https://github.com/targetcloud

#import "TGTabBar.h"
#import "UIView+TGSegment.h"
#import "HyPopMenuView.h"
#import "UIColor+WCL.h"
#import "TGPostWordVC.h"
#import "TGNavigationVC.h"
@interface TGTabBar()<HyPopMenuViewDelegate>
@property (nonatomic, weak) UIButton *publishButton;
@property (nonatomic, weak) UIControl *previousClickedTabBarBtn;
@property (nonatomic, strong) HyPopMenuView* menu;

@end
NSString  * const TabBarButtonDidRepeatClickNotification = @"TabBarButtonDidRepeatClickNotification";

@implementation TGTabBar

- (UIButton *)publishButton{
    if (_publishButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _publishButton = btn;
    }
    return _publishButton;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    CGFloat btnW = self.width / (self.items.count + 1);
    CGFloat btnH = self.height;
    CGFloat x = 0;
    int i = 0;
    for (UIControl *tabBarBtn in self.subviews) {
        if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 0 && _previousClickedTabBarBtn == nil) {
                _previousClickedTabBarBtn = tabBarBtn;
            }
            if (i == 2) {
                i += 1;
            }
            x = i * btnW;
            tabBarBtn.frame = CGRectMake(x, 0, btnW, btnH);
            i++;
            
            [tabBarBtn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.publishButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);//self.center (x = 207, y = 711.5)
}

- (void)tabBarButtonClick:(UIControl *)tabBarBtn{
    if (_previousClickedTabBarBtn == tabBarBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TabBarButtonDidRepeatClickNotification object:nil];
    }
    _previousClickedTabBarBtn = tabBarBtn;
}

- (void)publishButtonClick{
    //    TGPublishV *publishV = [TGPublishV viewFromXIB];
    //    [[UIApplication sharedApplication].keyWindow addSubview:publishV];
    //    publishV.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [self insertPopView];
    _menu.backgroundType = HyPopMenuViewBackgroundTypeLightTranslucent;
    [_menu openMenu];
}

-(void)insertPopView
{
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [self createPopMenuModelWithImageNameStr:@"publish-video" withTitle:@"发视频" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model1 = [self createPopMenuModelWithImageNameStr:@"publish-picture" withTitle:@"发图片" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model2 = [self createPopMenuModelWithImageNameStr:@"publish-text" withTitle:@"发段子" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model3 = [self createPopMenuModelWithImageNameStr:@"publish-audio" withTitle:@"发声音" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model4 = [self createPopMenuModelWithImageNameStr:@"publish-link" withTitle:@"发链接" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    PopMenuModel* model5 = [self createPopMenuModelWithImageNameStr:@"publish-review" withTitle:@"音乐相册" withTextColor:[UIColor hcy_colorWithString:@"#666666"] withTransitionType:PopMenuTransitionTypeSystemApi withTransitionRenderingColor:nil];
    _menu.dataSource = @[ model, model1, model2,model3,model4,model5];//model3
    _menu.delegate = self;
    _menu.popMenuSpeed = 10.0f;
    _menu.automaticIdentificationColor = false;
    _menu.animationType = HyPopMenuViewAnimationTypeCenter;
    
}

-(PopMenuModel *)createPopMenuModelWithImageNameStr:(NSString *)imagename withTitle:(NSString *)title withTextColor:(UIColor *)color withTransitionType:(PopMenuTransitionType)type withTransitionRenderingColor:(UIColor *)renderingcolor
{
    PopMenuModel * model = [PopMenuModel allocPopMenuModelWithImageNameString:imagename  AtTitleString:title  AtTextColor:color  AtTransitionType:type  AtTransitionRenderingColor:renderingcolor];
    return model;
}
-(void)popMenuView:(HyPopMenuView *)popMenuView didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 2:
        {
            
            TGPostWordVC *postWordVc = [[TGPostWordVC alloc] init];
            TGNavigationVC *nav = [[TGNavigationVC alloc]initWithRootViewController:postWordVc];
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
@end
