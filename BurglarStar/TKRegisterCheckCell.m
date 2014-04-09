//
//  TKRegisterCheckCell.m
//  Wisdom
//
//  Created by aJia on 2013/10/31.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKRegisterCheckCell.h"

@implementation TKRegisterCheckCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _check = [[RegisterCheck alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, 80)];
	[self.contentView addSubview:_check];
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
	CGRect r = CGRectInset(self.contentView.bounds, 10, 0);
    r.origin.y=10;
	_check.frame=r;
}

@end
