//
//  UIButton+TPCategory.m
//  LocationService
//
//  Created by aJia on 2013/12/18.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "UIButton+TPCategory.h"
#import "UIImage+TPCategory.h"
@implementation UIButton (TPCategory)
+ (id)backButtonTarget:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image=[UIImage imageNamed:@"leftico.png"];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    return btn;
}
+ (id)barButtonWithTitle:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    CGSize size=[title textSize:[UIFont systemFontOfSize:16] withWidth:320];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, size.width, size.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"2f3029"] forState:UIControlStateHighlighted];
    btn.titleLabel.font=[UIFont systemFontOfSize:16];
    btn.showsTouchWhenHighlighted=YES;
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    return btn;
}
+ (id)buttonWithImageName:(NSString*)imageName target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    UIImage *image=[UIImage imageNamed:imageName];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
     btn.showsTouchWhenHighlighted=YES;
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    return btn;
}
@end
