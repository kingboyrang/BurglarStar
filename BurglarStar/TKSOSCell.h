//
//  TKSOSCell.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSOSCell : UITableViewCell
@property (nonatomic,strong) UILabel *labName;
@property (nonatomic,strong) UILabel *labDate;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *arrowButton;
@property (nonatomic,strong) UIButton *chkButton;
@property (nonatomic,assign) BOOL showCheck;
- (void)changeMSelectedState;
- (void)mSelectedState:(BOOL)state;
@end
