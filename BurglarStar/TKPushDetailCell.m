//
//  TKPushDetailCell.m
//  Wisdom
//
//  Created by aJia on 2013/11/7.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKPushDetailCell.h"

@implementation TKPushDetailCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _detailView = [[PushDetail alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 77)];
	[self.contentView addSubview:_detailView];
    
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}

@end
