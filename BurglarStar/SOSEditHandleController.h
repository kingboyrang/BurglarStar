//
//  SOSEditHandleController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "SOSMessage.h"
#import "ManagerPhotoDelegate.h"
@interface SOSEditHandleController : BasicViewController<ManagerPhotoDelegate>
@property (nonatomic,retain) SOSMessage *Entity;
@property (nonatomic,retain) NSMutableArray *cells;
@end
