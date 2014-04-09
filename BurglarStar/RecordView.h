//
//  RecordView.h
//  LocationService
//
//  Created by aJia on 2014/1/10.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordView : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) BOOL hasValue;
- (void)setRecordCount:(int)total;
@end
