//
//  CVUIPopverView.m
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CVUIPopoverView.h"
#import "UIImage+TPCategory.h"
#define screenRect [[UIScreen mainScreen] bounds]

@interface CVUIPopoverView()
-(void)loadControl:(CGRect)frame;
-(BOOL)isIPad;
-(void)addBackgroundView;
-(void)setControlTitle:(NSString*)title withIndex:(int)tag;
- (UIButton*)barButtonItemWithFrame:(CGRect)frame title:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

@implementation CVUIPopoverView
@synthesize popController,popoverTitle,cancelButtonTitle,doneButtonTitle,clearButtonTitle;
@synthesize toolBar,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadControl:frame];
        self.backgroundColor=[UIColor colorFromHexRGB:@"efeedc"];
    }
    return self;
}
#pragma mark -
#pragma mark 属性方法重写
-(void)setPopoverTitle:(NSString *)title{
    if (popoverTitle!=title) {
        [popoverTitle release];
        [title copy];
        popoverTitle=title;
    }
    CGSize size=[title textSize:_labTitle.font withWidth:self.bounds.size.width];
    CGRect r=_labTitle.frame;
    r.size=size;
    r.origin.x=(self.frame.size.width-size.width)/2;
    _labTitle.frame=r;
    _labTitle.text=title;
}
-(void)setCancelButtonTitle:(NSString *)title{
    if (cancelButtonTitle!=title) {
        [cancelButtonTitle release];
        [title copy];
        cancelButtonTitle=title;
    }
    [self setControlTitle:[self cancelButtonTitle] withIndex:0];
    
}
-(void)setDoneButtonTitle:(NSString *)title{
    if (doneButtonTitle!=title) {
        [doneButtonTitle release];
        [title copy];
        doneButtonTitle=title;
    }
    [self setControlTitle:[self doneButtonTitle] withIndex:4];
}
-(void)setClearButtonTitle:(NSString *)title{
    if (clearButtonTitle!=title) {
        [clearButtonTitle release];
        [title copy];
        clearButtonTitle=title;
    }
     [self setControlTitle:[self clearButtonTitle] withIndex:3];

}
#pragma mark -
#pragma mark 公有方法
-(void)addChildView:(UIView*)view{
    if (view) {
        CGRect viewRect=view.frame;
        viewRect.origin.x=0;
        viewRect.origin.y=self.toolBar.frame.size.height;
        view.frame=viewRect;
        [self addSubview:view];
        
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[NVUIGradientButton class]]) {
                NVUIGradientButton *btn=(NVUIGradientButton*)v;
                CGRect btnRect=btn.frame;
                btnRect.origin.y+=viewRect.size.height;
                btn.frame=btnRect;
                break;
            }
        }
       //重设大小
       CGRect orginRect=self.frame;
       orginRect.size.height+=viewRect.size.height;
        CGFloat viewY=screenRect.size.height+orginRect.size.height;
        if ([self isIPad]) {
            viewY=0;
        }
       orginRect.origin.y=viewY;
       self.frame=orginRect;
        
        if ([self isIPad]) {
            if (!self.popController) {
                UIViewController *popView=[[UIViewController alloc] init];
                popView.contentSizeForViewInPopover=self.frame.size;
                [popView.view addSubview:self];
                self.popController=[[UIPopoverController alloc] initWithContentViewController:popView];
                self.popController.popoverContentSize=self.frame.size;
                [popView release];
            }
        }
    }
}
-(void)show:(UIView*)popView{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showPopoverView)]) {
        [self.delegate showPopoverView];
    }
    
    if ([self isIPad]) {
        [self.popController presentPopoverFromRect:popView.frame inView:[popView superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self addBackgroundView];
        UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
        [window addSubview:bgView];
        [window bringSubviewToFront:bgView];
        [window addSubview:self];
        
        CGFloat h=self.frame.size.height,topY=screenRect.size.height-h;
        [UIView animateWithDuration:0.5f animations:^(void){
            self.frame=CGRectMake(0, topY, 320, h);
        }];
        
    }
}
-(void)hide{
    if ([self isIPad]) {
        [self.popController dismissPopoverAnimated:YES];
        return;
    }
    CGFloat h=self.frame.size.height,topY=screenRect.size.height;

    [UIView animateWithDuration:0.5f animations:^(void){
        self.frame=CGRectMake(0,topY+h, 320, h);
        
    } completion:^(BOOL isFinished){
        if (isFinished) {
            [bgView removeFromSuperview];
            [self removeFromSuperview];
        }
        
    }];
}
#pragma mark -
#pragma mark 三个日期动作方法
//确定事件
-(void)buttonDoneClick{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(donePopoverView)]) {
        [self.delegate donePopoverView];
    }
    [self buttonCancelClick];
}
//清空事件
-(void)buttonClearClick{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clearPopoverView)]) {
        [self.delegate clearPopoverView];
    }
    [self buttonCancelClick];
}
//取消事件
-(void)buttonCancelClick{
    if ([self isIPad]) {
        [self.popController dismissPopoverAnimated:YES];
        return;
    }
    [self hide];
    
}
#pragma mark -
#pragma mark 私有方法
-(BOOL)isIPad{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
-(void)loadControl:(CGRect)frame{
        self.backgroundColor=[UIColor grayColor];
        //Tool Bar
    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
    if (IOSVersion>=7.0) {
        UIImage *root_image = [UIImage imageNamed:@"navbg.png"];
        if ([self.toolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [self.toolBar setBackgroundImage:root_image forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
        }else{
            self.toolBar.barStyle = UIToolbarPositionTop;
        }
    }else{
        self.toolBar.barStyle =UIBarStyleBlackTranslucent;
    }
    
    UIBarButtonItem *leftButton;
    if (IOSVersion>=7.0) {
        UIButton *btn1=[self barButtonItemWithFrame:CGRectMake(0, 0, 30, 30) title:@"取消" target:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];
        leftButton=[[UIBarButtonItem alloc] initWithCustomView:btn1];
    }else{
       leftButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(buttonCancelClick)];
    }
        
        UIBarButtonItem *midleButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
        NSString *memo=@"请选择";
        CGSize size=[memo textSize:[UIFont boldSystemFontOfSize:14] withWidth:320];
        _labTitle=[[UILabel alloc] initWithFrame:CGRectMake((320-size.width)/2,(44-size.height)/2, size.width, size.height)];
        _labTitle.text=memo;
        _labTitle.font=[UIFont boldSystemFontOfSize:14];
        _labTitle.textColor=[UIColor whiteColor];
        _labTitle.backgroundColor=[UIColor clearColor];
        _labTitle.textAlignment=NSTextAlignmentCenter;

        UIBarButtonItem *fixButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *clearButton;
    if (IOSVersion>=7.0) {
        UIButton *btn2=[self barButtonItemWithFrame:CGRectMake(0, 0, 30, 30) title:@"清除" target:self action:@selector(buttonClearClick) forControlEvents:UIControlEventTouchUpInside];
        clearButton=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    }else{
        clearButton=[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClearClick)];
    }
    
    UIBarButtonItem *rightButton;
     if (IOSVersion>=7.0) {
        UIButton *btn3=[self barButtonItemWithFrame:CGRectMake(0, 0, 30, 30) title:@"确定" target:self action:@selector(buttonDoneClick) forControlEvents:UIControlEventTouchUpInside];
         rightButton=[[UIBarButtonItem alloc] initWithCustomView:btn3];
     }else{
         rightButton=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonDoneClick)];
     }
        [self.toolBar setItems:[NSArray arrayWithObjects:leftButton,midleButton,fixButton,clearButton,rightButton, nil]];
        [self addSubview:self.toolBar];
        [leftButton release];
        [rightButton release];
        [midleButton release];
        [fixButton release];
        [clearButton release];
    
        [self addSubview:_labTitle];
    
        CGFloat topY=44;
        CGFloat viewY=screenRect.size.height+topY;
        if ([self isIPad]) {
            viewY=0;
        }
        self.frame=CGRectMake(0, viewY, 320, topY);
    
    
}
-(void)setControlTitle:(NSString*)title withIndex:(int)tag{
    if (self.toolBar&&[self.toolBar.items objectAtIndex:tag]) {
        UIBarButtonItem *barBtn=(UIBarButtonItem*)[self.toolBar.items objectAtIndex:tag];
        UIButton *btn=(UIButton*)barBtn.customView;
        [btn setTitle:title forState:UIControlStateNormal];
    }
}
-(void)addBackgroundView{
    if (![self isIPad]) {
        if (!bgView) {
            bgView=[[UIView alloc] initWithFrame:screenRect];
            bgView.backgroundColor=[UIColor grayColor];
            bgView.alpha=0.3;
            //[bgView addSubview:self];
        }
    }
    
}
- (UIButton*)barButtonItemWithFrame:(CGRect)frame title:(NSString*)title target:(id)sender action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    //CGSize size=[title textSize:[UIFont boldSystemFontOfSize:14] withWidth:320];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"1e313f"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"2f3029"] forState:UIControlStateHighlighted];
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    btn.showsTouchWhenHighlighted=YES;
    [btn addTarget:sender action:action forControlEvents:controlEvents];
    return btn;
}
-(void)dealloc{
    [popController release];
    [popoverTitle release];
    [cancelButtonTitle release];
    [doneButtonTitle release];
    [clearButtonTitle release];
    [toolBar release];
    [super dealloc];
    
}
@end
