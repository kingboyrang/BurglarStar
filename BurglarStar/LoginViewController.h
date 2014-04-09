//
//  LoginViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerViewController.h"
#import "LoginWay.h"
@interface LoginViewController : PagerViewController
@property(nonatomic,strong) LoginWay *loginWay;
- (void)selectedMenuItemIndex:(NSNumber*)number;
- (void)handChangePageIndex:(int)index;
@end
