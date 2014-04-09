//
//  RegisterCheck.h
//  Wisdom
//
//  Created by aJia on 2013/10/31.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCheck : UIView{
@private
    UILabel *_lightLabel;
}
@property(nonatomic,readonly) BOOL hasRemember;
@property(nonatomic,strong) UIButton *registerButton;
-(void)setSelectItemSwitch:(int)index;
@end
