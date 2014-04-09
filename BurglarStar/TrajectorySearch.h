//
//  TrajectorySearch.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVUICalendar.h"
@interface TrajectorySearch : UIView
@property (nonatomic,strong) CVUICalendar *startCalendar;
@property (nonatomic,strong) CVUICalendar *endCalendar;
@property (nonatomic,strong) UIButton *button;
- (BOOL)compareToDate;
@end
