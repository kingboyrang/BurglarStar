//
//  CVUIPopoverText.m
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CVUIPopoverText.h"

@implementation CVUIPopoverText
@synthesize popoverTextField,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //文本框显示日期
        self.popoverTextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.popoverTextField.borderStyle=UITextBorderStyleRoundedRect;
        self.popoverTextField.placeholder=@"请选择";
        self.popoverTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//設定本文垂直置中
        self.popoverTextField.enabled=NO;//设置不可以编辑
        self.popoverTextField.font=[UIFont systemFontOfSize:14];
        //设置按钮
        buttonTap=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        buttonTap.backgroundColor=[UIColor clearColor];
        [buttonTap addTarget:self action:@selector(buttonChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.popoverTextField];
        [self addSubview:buttonTap];
        
        frame.origin.x=0;
        frame.origin.y=0;
        self.frame=frame;

    }
    return self;
}
- (void) layoutSubviews{
    [super layoutSubviews];
    CGRect frame=self.frame;
    frame.origin.x=0;
    frame.origin.y=0;
    self.popoverTextField.frame=frame;
    buttonTap.frame=frame;
}
-(void)buttonChooseClick:(id)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(doneShowPopoverView:senderView:)]) {
        [self.delegate doneShowPopoverView:self senderView:sender];
    }
}

-(void)dealloc{
    [popoverTextField release],popoverTextField=nil;
    [buttonTap release],buttonTap=nil;
    [super dealloc];
}
@end
