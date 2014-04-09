//
//  AlertHelper.m
//  Eland
//
//  Created by aJia on 13/9/30.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AlertHelper.h"
#import "RIButtonItem.h"
#import "AppDelegate.h"
@implementation AlertHelper
+(void)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(RIButtonItem *)inCancelButtonItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...{
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:inTitle message:inMessage cancelButtonItem:inCancelButtonItem otherButtonItems:inOtherButtonItems, nil];
    [alter show];
    [alter release];
}
+(void)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage{
    RIButtonItem *button=[RIButtonItem item];
    button.label=@"确认";
    button.action=nil;
    [self initWithTitle:inTitle message:inMessage cancelButtonItem:nil otherButtonItems:button];
}
+(void)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *cancel=[RIButtonItem item];
    cancel.label=cancelTitle;
    cancel.action=cancelAction;
    
    RIButtonItem *confirm=[RIButtonItem item];
    confirm.label=confirmTitle;
    confirm.action=confirmAction;
    
    [self initWithTitle:inTitle message:inMessage cancelButtonItem:cancel otherButtonItems:confirm];
}
+(void)confirmWithTitle:(NSString*)confirm confirm:(void (^)(void))confirmAction innnerView:(UIView*)view{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;

    RIButtonItem *delBtn=[RIButtonItem item];
    delBtn.label=confirm;
    delBtn.action=confirmAction;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:delBtn, nil];
    [sheet showInView:view];
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        CGRect r=sheet.frame;
        r.origin.y-=20;
        sheet.frame=r;
    }
#endif
    [sheet release];
    


}
@end
