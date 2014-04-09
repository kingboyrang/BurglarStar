//
//  TrajectoryViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
#import "TrajectorySearch.h"
@interface TrajectoryViewController : BasicViewController
@property(nonatomic,strong) SupervisionPerson *Entity;
@property(nonatomic,strong) TrajectorySearch *trajectorySearch;
@property(nonatomic,strong) NSArray *cells;
@end
