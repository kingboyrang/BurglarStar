//
//  ToolBarMenu.m
//  BurglarStar
//
//  Created by aJia on 2014/4/9.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ToolBarMenu.h"

@interface ToolBarMenu (){
    int _prevSelectIndex;
}
- (void)loadControls;
@end

@implementation ToolBarMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadControls];
        
    }
    return self;
}
- (void)loadControls{
    NSArray *heightBackground= @[@"index_s.png",@"history_s.png",@"message_s.png",@"more_s.png"];
    NSArray *backgroud= @[@"index_n.png",@"history_n.png",@"message_n.png",@"more_n.png"];
    
    
    //默认第一项选中
    self.selectedIndex=0;
    _prevSelectIndex=0;
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        UIImage *normal=[UIImage imageNamed:backImage];
        UIImage *hight=[UIImage imageNamed:heightImage];
        
        CGFloat leftX=i*normal.size.width;
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(leftX,0, normal.size.width, normal.size.height)];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        [button setBackgroundImage:hight forState:UIControlStateSelected];
        button.tag = 100+i;
        if (i==0) {
            button.selected=YES;
        }
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [button release];
    }
}
//tab 按钮的点击事件
- (void)selectedTab:(UIButton *)button {
    
    SEL sel=NSSelectorFromString(@"selectedTrajectoryIndex:");
    //如果未选中监管目标则return
    if (self.controls&&[self.controls respondsToSelector:sel]) {
        int position=button.tag-100;
        BOOL boo=(BOOL)[self.controls performSelector:sel withObject:[NSNumber numberWithInt:position]];
        if (!boo) {
            return;
        }
    }
    
    button.selected=YES;
    if (_prevSelectIndex!=button.tag-100) {
        UIButton *btn=(UIButton*)[self viewWithTag:100+_prevSelectIndex];
        btn.selected=NO;
        _prevSelectIndex=button.tag-100;
    }
    self.selectedIndex = button.tag-100;
    
     SEL sel1=NSSelectorFromString(@"setSelectedTabIndex:");
    if (self.controls&&[self.controls respondsToSelector:sel1]) {
        [self.controls performSelector:sel1 withObject:[NSNumber numberWithInt:self.selectedIndex]];
    }
    
    
}
- (void)setSelectedItemIndex:(int)index{
    int pos=100+index;
    UIButton *btn=(UIButton*)[self viewWithTag:pos];
    [self selectedTab:btn];
}
@end
