//
//  AppHelper.h
//  LocationService
//
//  Created by aJia on 2013/12/16.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject
+ (void)runAnimation:(void(^)())completed;
+ (NSArray*)arrayWithSource:(NSArray*)source className:(NSString*)name;
@end
