//
//  TKAreaWeekCell.h
//  LocationService
//
//  Created by aJia on 2014/1/6.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAreaWeekCell : UITableViewCell{
}
@property (nonatomic,readonly) BOOL hasSelected;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) UIButton *checkbox;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *rightView;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) int Sort;//排序

- (void)setSelectedWeek:(BOOL)selected;
- (void)setOpen:(BOOL)open;
@end
