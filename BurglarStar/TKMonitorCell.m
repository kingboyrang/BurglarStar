//
//  TKMonitorCell.m
//  LocationService
//
//  Created by aJia on 2013/12/24.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKMonitorCell.h"

@implementation TKMonitorCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"MonitorView" owner:self options:nil];
    if (arr&&[arr count]>0) {
        _monitorView=[arr objectAtIndex:0];
        [self.contentView addSubview:_monitorView];
    }
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}

@end
