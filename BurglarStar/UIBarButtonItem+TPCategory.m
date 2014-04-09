//
//  UIBarButtonItem+TPCategory.m
//  BurglarStar
//
//  Created by aJia on 2014/4/9.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "UIBarButtonItem+TPCategory.h"
#import "UIButton+TPCategory.h"
@implementation UIBarButtonItem (TPCategory)
+ (id)barButtonArrowItemTarget:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIImage *image=[UIImage imageNamed:@"arrow_down.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag=100;
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateSelected];
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    
    UIBarButtonItem *barButton=[[self alloc] initWithCustomView:btn];
    return [barButton autorelease];
}
+ (id)barButtonWithTitle:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn=[UIButton barButtonWithTitle:title target:sender action:action forControlEvents:controlEvents];
    UIBarButtonItem *barButton=[[self alloc] initWithCustomView:btn];
    return [barButton autorelease];
}
+ (id)barButtonWithImage:(NSString*)imageName target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIImage *image=[UIImage imageNamed:imageName];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    
    UIBarButtonItem *barButton=[[self alloc] initWithCustomView:btn];
    return [barButton autorelease];
}
@end
