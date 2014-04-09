//
//  AreaRuleViewController.h
//  LocationService
//
//  Created by aJia on 2014/1/2.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaRuleViewController : BasicViewController
@property(nonatomic,retain) NSArray *sourceData;
@property (nonatomic,retain) NSMutableDictionary *shipUsers;//关联对象
@property(nonatomic,copy) NSString *AreaId;
@property(nonatomic,copy) NSString *AreaName;
@property(nonatomic,copy) NSString *ruleId;//规则id
@property (nonatomic,assign) int operateType;//1 新增 2:修改
@end
