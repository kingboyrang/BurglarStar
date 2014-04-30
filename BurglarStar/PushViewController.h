//
//  PushViewController.h
//  Wisdom
//
//  Created by aJia on 2013/11/4.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : BasicViewController<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
-(void)pageScrollLeft;
-(void)pageScrollRight;
@end
