//
//  AppDelegate.h
//  BurglarStar
//
//  Created by aJia on 2014/4/7.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;
- (void)registerBaiduMap;
- (void)appInitSet;
@end
