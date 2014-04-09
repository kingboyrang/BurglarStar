//
//  ExceptionPaoView.h
//  LocationService
//
//  Created by aJia on 2014/1/15.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrajectoryMessage.h"
@interface ExceptionPaoView : UIView
@property (nonatomic,retain) NSMutableArray *cells;
//@property (nonatomic,retain) TrajectoryMessage *Entity;
//@property (nonatomic,assign) id controls;
- (void)setDataSource:(TrajectoryMessage*)entity;
@end
