//
//  TKAreaCell.h
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAreaCell : UITableViewCell
@property (nonatomic,strong) UILabel *labName;
@property (nonatomic,strong) UIButton *arrowButton;
@property (nonatomic,strong) UIButton *chkButton;
@property (nonatomic,assign) BOOL showCheck;
- (void)setShowCheckButton:(BOOL)show;
@end
