//
//  CallPhoneView.h
//  LocationService
//
//  Created by aJia on 2014/1/5.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBSwitch.h"
@interface CallPhoneView : UIView
@property (nonatomic,strong) UILabel *labPhone;
@property (nonatomic,strong) TKBSwitch *switchPhone;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) id controlers;
- (void)setCallPhone:(NSString*)phone type:(NSString*)type;
@end
