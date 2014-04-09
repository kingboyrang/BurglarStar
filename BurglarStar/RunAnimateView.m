//
//  RunAnimateView.m
//  LocationService
//
//  Created by aJia on 2014/1/14.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "RunAnimateView.h"
#import "Account.h"
@implementation RunAnimateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.contentSize=CGSizeMake(frame.size.width*2, self.frame.size.height);
        _scrollView.delegate=self;
        NSString *name=@"";
        for (int i=1; i<3; i++) {
            name=[NSString stringWithFormat:@"load0%d.jpg",i];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((i-1)*frame.size.width, 0, frame.size.width, frame.size.height)];
            [imageView setImage:[UIImage imageNamed:name]];
            [_scrollView addSubview:imageView];
            [imageView release];
        }
        
        NSString *title=@"开始...";
        CGSize size=[title textSize:[UIFont boldSystemFontOfSize:16] withWidth:frame.size.width];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorFromHexRGB:@"ffff0b"] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        [btn addTarget:self action:@selector(buttonRemove:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(frame.size.width*2-size.width-8,frame.size.height-size.height-30, size.width, size.height);
        [_scrollView addSubview:btn];
        [self addSubview:_scrollView];
        _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake((frame.size.width-38)/2, frame.size.height-36-10, 38, 36)];
        _pageControl.numberOfPages=2;
        _pageControl.currentPage=0;
        _pageControl.currentPageIndicatorTintColor=[UIColor colorFromHexRGB:@"92d050"];
        [self addSubview:_pageControl];
    }
    return self;
}
//移除
- (void)buttonRemove:(id)sender{
    Account *acc=[Account unarchiverAccount];
    acc.isFirstRun=NO;
    [acc save];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDidStopSelector:@selector(finishAnimal)];
    self.alpha=0.0;
    [UIView commitAnimations];
    
    
}
//完成动画效果
- (void)finishAnimal{
    [self removeFromSuperview];
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
}
@end
