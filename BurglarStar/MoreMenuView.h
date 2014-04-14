//
//  MoreMenuView.h
//  BurglarStar
//
//  Created by aJia on 2014/4/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreMenuViewDelegate <NSObject>
- (void)selectedMenuItemIndex:(NSInteger)index sender:(id)sender;
@end

@interface MoreMenuView : UIView
@property (nonatomic,assign) id<MoreMenuViewDelegate> delegate;
@end
