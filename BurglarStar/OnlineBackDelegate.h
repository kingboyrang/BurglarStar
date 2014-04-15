//
//  OnlineBackDelegate.h
//  LocationService
//
//  Created by aJia on 2014/2/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OnlineBackDelegate <NSObject>
@optional
- (void)viewBackToControl:(id)sender;
- (void)viewToDownloadControl;
@end
