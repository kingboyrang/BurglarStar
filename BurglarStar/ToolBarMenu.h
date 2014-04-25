//
//  ToolBarMenu.h
//  BurglarStar
//
//  Created by aJia on 2014/4/9.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolBarMenu : UIView
@property (nonatomic,assign) int selectedIndex;
@property (nonatomic,assign) id controls;
- (void)setSelectedItemIndex:(int)index;
- (void)resetSelectedItem;
@end
