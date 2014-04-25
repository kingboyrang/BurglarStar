//
//  ToolEditView.h
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBarView.h"
#import "LoginButtons.h"
@interface ToolEditView : UIView
@property (nonatomic,strong) ToolBarView *barView;
@property (nonatomic,strong) LoginButtons *toolBar;
- (void)sendBarViewBack;
- (void)sendToolBarBack;
@end
