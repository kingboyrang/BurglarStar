//
//  TKMapCell.h
//  LocationService
//
//  Created by aJia on 2013/12/30.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKOfflineMap.h"
@interface TKMapCell : UITableViewCell

@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) UILabel *labprocess;
@property(nonatomic,strong) UIProgressView *progressView;
@property(nonatomic,retain) BMKOLSearchRecord *Entity;
@property(nonatomic,assign) BOOL isPause;//是否是暂停
@property(nonatomic,assign) id controlers;
//设置数据源
- (void)setDataSource:(BMKOLSearchRecord*)entity;
//显示进度条
- (void)updateProgressInfo:(BMKOLUpdateElement*)entity;
@end
