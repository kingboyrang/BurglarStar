//
//  MessageView.h
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrajectoryMessage.h"
@interface MessageView : UIView
@property (retain, nonatomic) IBOutlet UILabel *labName;
@property (retain, nonatomic) IBOutlet UILabel *labLimit;
@property (retain, nonatomic) IBOutlet UILabel *labTime;
@property (retain, nonatomic) IBOutlet UILabel *labAddress;
@property (retain, nonatomic) IBOutlet UIButton *buttonArrow;
@property (retain, nonatomic) IBOutlet UIButton *chkButton;
@property (retain, nonatomic) IBOutlet UIButton *btnLocation;

@property (nonatomic,strong) TrajectoryMessage *Entity;

- (void)setDataSource:(TrajectoryMessage*)entity indexPathRow:(NSInteger)row;
//标记已读
- (void)setReading:(BOOL)read;
@end
