//
//  CVUIPopverView.m
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CVUIPopoverView.h"
#define screenRect [[UIScreen mainScreen] bounds]

@interface CVUIPopoverView()
-(void)loadControl:(CGRect)frame;
-(BOOL)isIPad;
-(void)addBackgroundView;
-(void)setControlTitle:(NSString*)title withIndex:(int)tag;
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
    [self setControlTitle:[self popoverTitle] withIndex:2];
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
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[NVUIGradientButton class]]) {
            NVUIGradientButton *btn=(NVUIGradientButton*)v;
            btn.text=[self clearButtonTitle];
            break;
        }
    }

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
#ifdef __IPHONE_7_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            topY-=20;
        }
#endif
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
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        topY+=20;
    }
#endif
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
        self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.toolBar.barStyle=UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClick)];
        
        UIBarButtonItem *midleButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UILabel *labTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
        labTitle.text=@"请选择";
        labTitle.font=[UIFont boldSystemFontOfSize:14];
        labTitle.textColor=[UIColor whiteColor];
        labTitle.backgroundColor=[UIColor clearColor];
        labTitle.textAlignment=NSTextAlignmentCenter;
        UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithCustomView:labTitle];
        [labTitle release];
        
        UIBarButtonItem *fixButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonDoneClick)];
        
        [self.toolBar setItems:[NSArray arrayWithObjects:leftButton,midleButton,customBtn,fixButton,rightButton, nil]];
        [self addSubview:self.toolBar];
        [leftButton release];
        [rightButton release];
        [midleButton release];
        [fixButton release];
        [customBtn release];
        //[navItem release];
        
        //[contentView addSubview:self.datePicker];
        
        CGFloat topY=49,w=227,h=35,leftX=(320-w)/2;
        
        //清空
        NVUIGradientButton *clearBtn=[[NVUIGradientButton alloc] initWithFrame:CGRectMake(leftX, topY, w, h)];
        clearBtn.text=@"清空";
        //clearBtn.textColor=[UIColor whiteColor];
        clearBtn.textShadowColor=[UIColor darkGrayColor];
        [clearBtn addTarget:self action:@selector(buttonClearClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        [clearBtn release];
        
        topY+=h+5;
        
        CGFloat viewY=screenRect.size.height+topY;
        if ([self isIPad]) {
            viewY=0;
        }
        self.frame=CGRectMake(0, viewY, 320, topY);
    
    
}
-(void)setControlTitle:(NSString*)title withIndex:(int)tag{
    if (self.toolBar&&[self.toolBar.items objectAtIndex:tag]) {
        UIBarButtonItem *barBtn=(UIBarButtonItem*)[self.toolBar.items objectAtIndex:tag];
        if (tag==2) {
            UILabel *lab=(UILabel*)barBtn.customView;
            lab.text=title;
            return;
        }
        [barBtn setTitle:title];
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
-(void)dealloc{
    [popController release];
    [popoverTitle release];
    [cancelButtonTitle release];
    [doneButtonTitle release];
    [clearButtonTitle release];
    [toolBar release];
    [super dealloc];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
