//
//  TKDynamicPasswordCell.h
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKDynamicPasswordCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *button;
@property(nonatomic,readonly) BOOL hasValue;
@property(nonatomic,readonly) BOOL hasVeryFailed;
@property(nonatomic,readonly) NSDate *minDate;
@property(nonatomic,readonly) NSDate *maxDate;
@property(nonatomic,copy) NSString *dynamicCode;//动态密码
@property(nonatomic,assign) id controlers;

- (void)startTimerWithTime:(NSString*)time process:(void(^)(NSTimeInterval afterInterval))process;
- (void)resetOrgin;
@end
