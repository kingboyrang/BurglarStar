//
//  AnimalView.m
//  AnimalDemo
//
//  Created by aJia on 13/9/5.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AnimateLoadView.h"
#import <QuartzCore/QuartzCore.h>
@interface AnimateLoadView ()
-(void)loadControls;
-(void)animalTitle:(NSString*)title;
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w;
@end

@implementation AnimateLoadView
@synthesize activityIndicatorView=_activityIndicatorView;
@synthesize labelTitle=_labelTitle;
-(void)dealloc{
    [super dealloc];
    [_activityIndicatorView release],_activityIndicatorView=nil;
    [_labelTitle removeObserver:self forKeyPath:@"text"];
    [_labelTitle release],_labelTitle=nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadControls];
    }
    return self;
}
-(void)loadControls{
    if (!_activityIndicatorView) {
        _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.frame=CGRectMake(8, 5, 30, 30);
        [self addSubview:_activityIndicatorView];
    }
    if (!_labelTitle) {
        NSString *title=@"loading...";
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:self.bounds.size.width-40];
        
        _labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(40,(40-size.height)/2.0, size.width, size.height)];
        _labelTitle.backgroundColor=[UIColor clearColor];
        _labelTitle.textColor=[UIColor whiteColor];
        _labelTitle.font=[UIFont boldSystemFontOfSize:14];
        _labelTitle.text=title;
        
        [self addSubview:_labelTitle];
        
        //kvo模式判断内容是否发生改变
        [_labelTitle addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        self.backgroundColor=[UIColor blackColor];
        //self.alpha=0.5;
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=10.0;
    }

}

-(void)layoutSubviews{
    [super layoutSubviews];
    /***
    CGRect screnRect=self.window.bounds;
    CGFloat w=_labelTitle.frame.size.width+_labelTitle.frame.origin.x+8;
    CGRect frame=self.frame;
    frame.size.width=w;
    
    CGFloat screenW=screnRect.size.width,screenH=screnRect.size.height;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)){
        screenW=screnRect.size.height;
        screenH=screnRect.size.width;
    }
    frame.origin.x=0;
    frame.origin.y=-frame.size.height;
    self.frame=frame;
     ***/
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"text"])
    {
        if (![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]]) {
            [self animalTitle:[change objectForKey:@"new"]];
        }
        
    }
}
#pragma mark private
-(CGSize)CalculateStringSize:(NSString*)text font:(UIFont*)font with:(CGFloat)w{
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(w, CGFLOAT_MAX)
                           lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}
-(void)animalTitle:(NSString*)title{
    if (_labelTitle) {
        CGSize size=[self CalculateStringSize:title font:[UIFont boldSystemFontOfSize:14] with:320.0];
        CGRect frame=_labelTitle.frame;
        frame.size=size;
        _labelTitle.frame=frame;
        _labelTitle.text=title;
    }
}

@end
