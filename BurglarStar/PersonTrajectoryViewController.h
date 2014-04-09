//
//  PersonTrajectoryViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrajectorySearch.h"
#import "SupervisionPerson.h"
@interface PersonTrajectoryViewController : BasicViewController

@property(nonatomic,retain) NSArray *cells;
@property(nonatomic,strong) TrajectorySearch *trajectorySearch;
@property(nonatomic,strong) SupervisionPerson *Entity;
@property(nonatomic,assign) BOOL canShowTrajectory;
@end
