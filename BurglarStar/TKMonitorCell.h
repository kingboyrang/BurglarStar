//
//  TKMonitorCell.h
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorView.h"
@interface TKMonitorCell : UITableViewCell
@property(nonatomic,strong) MonitorView *monitorView;
//@property (nonatomic,strong) UIButton *chkButton;
@property (nonatomic,assign) BOOL showCheck;
- (void)changeMSelectedState;
- (void)mSelectedState:(BOOL)state;
@end
