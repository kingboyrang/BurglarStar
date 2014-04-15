//
//  LoginButtons.h
//  LocationService
//
//  Created by aJia on 2013/12/19.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginButtons : UIView
@property(nonatomic,strong) UIButton *submit;
@property(nonatomic,strong) UIButton *cancel;
- (void)setLeftButtonsWithCancelTitle:(NSString*)cancleTitle confirmTitle:(NSString*)submitTitle;
- (void)setRightButtonsWithCancelTitle:(NSString*)cancleTitle confirmTitle:(NSString*)submitTitle;
@end
