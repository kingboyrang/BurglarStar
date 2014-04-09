//
//  SupervisionViewController.h
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
@interface SupervisionViewController : BasicViewController
@property(nonatomic,strong) NSMutableArray *cells;
@property(nonatomic,strong) NSMutableDictionary *removeList;

-(void)supervisionEditHeadWithEntity:(SupervisionPerson*)entity;//修改头像
-(void)supervisionMessageWithEntity:(SupervisionPerson*)entity;//查看信息
-(void)supervisionTrajectoryWithEntity:(SupervisionPerson*)entity;//查看轨迹
-(void)supervisionCallWithEntity:(SupervisionPerson*)entity;//拨打电话
@end
