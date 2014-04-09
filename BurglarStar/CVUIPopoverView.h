//
//  CVUIPopverView.h
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@protocol CVUIPopoverViewDelegate <NSObject>
@optional
-(void)donePopoverView;
-(void)clearPopoverView;
-(void)showPopoverView;
@end

@interface CVUIPopoverView : UIView{
    UIView *bgView;
}
@property(nonatomic,retain) UIPopoverController *popController;
@property(nonatomic,retain) UIToolbar *toolBar;
@property(nonatomic,copy) NSString *popoverTitle;
@property(nonatomic,copy) NSString *cancelButtonTitle;
@property(nonatomic,copy) NSString *doneButtonTitle;
@property(nonatomic,copy) NSString *clearButtonTitle;
@property(nonatomic,assign) id<CVUIPopoverViewDelegate> delegate;
-(void)addChildView:(UIView*)view;
-(void)show:(UIView*)popView;
-(void)hide;
@end
