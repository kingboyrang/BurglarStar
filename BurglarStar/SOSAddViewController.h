//
//  SOSAddViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "ManagerPhotoDelegate.h"
@interface SOSAddViewController : BasicViewController<ManagerPhotoDelegate>
@property (nonatomic,retain) NSMutableArray *cells;
@end
