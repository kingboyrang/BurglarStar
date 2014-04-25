//
//  ToolEditView.m
//  BurglarStar
//
//  Created by aJia on 2014/4/25.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ToolEditView.h"

@implementation ToolEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _toolBar=[[LoginButtons alloc] initWithFrame:self.bounds];
        [_toolBar.cancel addTarget:self action:@selector(sendToolBarBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolBar];
        
        _barView=[[ToolBarView alloc] initWithFrame:self.bounds];
        [self addSubview:_barView];
    }
    return self;
}
- (void)sendBarViewBack{
    [self bringSubviewToFront:_toolBar];
}
- (void)sendToolBarBack{
    [self bringSubviewToFront:_barView];
}
@end
