//
//  TKAreaTargetCell.h
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAreaTargetCell : UITableViewCell
@property (nonatomic,strong) UIButton *chkButton;
@property (nonatomic,strong) UIImageView *busImageView;
@property (nonatomic,strong) UILabel *labName;
- (void)setCheckedButton:(BOOL)ischecked;
@end
