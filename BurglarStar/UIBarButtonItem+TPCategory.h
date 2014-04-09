//
//  UIBarButtonItem+TPCategory.h
//  BurglarStar
//
//  Created by aJia on 2014/4/9.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TPCategory)
+ (id)barButtonArrowItemTarget:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (id)barButtonWithTitle:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (id)barButtonWithImage:(NSString*)imageName target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
