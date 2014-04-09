//
//  PinView.h
//  LocationService
//
//  Created by aJia on 2014/1/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupervisionPerson.h"
@interface PinView : UIView
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIImageView *headView;
@property(nonatomic,strong) UIImageView *circuleView;
- (UIImage*)getPinImageWithSource:(SupervisionPerson*)entity;
- (void)setDataSource:(SupervisionPerson*)entity completed:(void(^)(UIImage *image))finished;
- (void)getMapPinImage:(float)level source:(SupervisionPerson*)entity completed:(void(^)(UIImage *image))finished;
@end
