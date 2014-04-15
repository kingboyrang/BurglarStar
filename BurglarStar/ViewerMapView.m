//
//  ViewerMapView.m
//  LocationService
//
//  Created by aJia on 2014/2/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ViewerMapView.h"
@implementation ViewerMapView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /***
        _navBarView=[[NavBarView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [_navBarView setNavBarTitle:@"查看离线地图"];
        [_navBarView setBackButtonWithTarget:self action:@selector(buttonHideView)];
        [self addSubview:_navBarView];
        ***/
    }
    return self;
}
//返回操作
- (void)buttonHideView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(viewBackToControl:)]) {
        [self.delegate viewBackToControl:self];
    }
}
@end
