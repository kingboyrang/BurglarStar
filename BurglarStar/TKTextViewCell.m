//
//  TKTextViewCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKTextViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation TKTextViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
	_textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
    _textView.contentInset = UIEdgeInsetsZero;
    _textView.textColor=[UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.layer.borderWidth=2.0;
    _textView.layer.cornerRadius=5.0;
    _textView.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
	[self.contentView addSubview:_textView];
	return self;
}

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:reuseIdentifier];
}
-(BOOL)hasValue{
    NSString *title=[_textView.text Trim];
    if ([title length]>0) {
        return YES;
    }
    return NO;
}
- (void) layoutSubviews {
    [super layoutSubviews];
	_textView.frame = CGRectInset(self.contentView.bounds, 10, 4);
}

@end
