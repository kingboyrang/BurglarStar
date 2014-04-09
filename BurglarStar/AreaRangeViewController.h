//
//  AreaRangeViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaRangeViewController : BasicViewController
@property(nonatomic,copy) NSString *AreaName;
@property(nonatomic,copy) NSString *AreaId;
@property(nonatomic,copy) NSString *RuleId;
@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,retain) NSMutableDictionary *cellChilds;
@end
