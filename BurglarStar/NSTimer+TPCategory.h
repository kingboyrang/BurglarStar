//
//  NSTimer+TPCategory.h
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (TPCategory)
-(void)pauseTimer;//暂停
-(void)resumeTimer;//取消

- (NSMutableDictionary *)pauseDictionary;
- (void)pause;
- (void)resume;
@end
