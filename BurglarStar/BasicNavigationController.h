//
//  BasicNavigationController.h
//  LocationService
//
//  Created by aJia on 2013/12/18.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasicNavigationDelegate <NSObject>
- (BOOL)prevLeftBackJude;
@end

@interface BasicNavigationController : UINavigationController
@property (nonatomic,assign) id<BasicNavigationDelegate> basicNavDelegate;
@end
