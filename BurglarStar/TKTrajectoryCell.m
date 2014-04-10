//
//  TKTrajectoryCell.m
//  LocationService
//
//  Created by aJia on 2013/12/26.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "TKTrajectoryCell.h"
#import "UIImage+TPCategory.h"
@interface TKTrajectoryCell ()
@property (nonatomic,strong) UIImageView *lineImageView;
@end

@implementation TKTrajectoryCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _address = [[UILabel alloc] initWithFrame:CGRectZero];
	_address.backgroundColor = [UIColor clearColor];
    //_address.textAlignment = NSTextAlignmentRight;
    _address.textColor = [UIColor blackColor];
	_address.highlightedTextColor = [UIColor whiteColor];
    _address.font = [UIFont fontWithName:DeviceFontName size:14];
    _address.numberOfLines=0;
    _address.lineBreakMode=NSLineBreakByWordWrapping;
	
	[self.contentView addSubview:_address];
    
    //UIImage *img=[UIImage imageNamed:@"line_bg.png"];
    _lineImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [_lineImageView setImage:[UIImage createImageWithColor:[UIColor colorFromHexRGB:@"cfcebf"]]];
    [self.contentView addSubview:_lineImageView];
    
    
   // NSString *imgName=@"arrow_right_n.png";
   // UIImage *img=[UIImage imageNamed:imgName];
    _arrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _arrowButton.frame=CGRectMake(0, 0, 26, 26);
   // [_arrowButton setImage:img forState:UIControlStateNormal];
    [self.contentView addSubview:_arrowButton];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *str=[self.label.text Trim];
    CGSize size1=[str textSize:[UIFont fontWithName:DeviceFontName size:14] withWidth:102];
    
    CGRect rect=self.label.frame;
    rect.origin.x=(102-size1.width)/2;
    rect.size=size1;
    self.label.frame=rect;
    
    rect=CGRectMake(102, 0, 2, self.frame.size.height);
    self.lineImageView.frame=rect;
    
    CGRect btnFrame=_arrowButton.frame;
    btnFrame.origin.x=self.frame.size.width-5-btnFrame.size.width;
    btnFrame.origin.y=(self.frame.size.height-btnFrame.size.height)/2;
    _arrowButton.frame=btnFrame;

    NSString *txt=_address.text;
    CGRect r = CGRectInset(self.contentView.bounds, 10,10);
    r.origin.x=102+3;
    CGFloat w=btnFrame.origin.x-r.origin.x-5;
    
    if ([txt length]>0) {
        CGSize size=[txt textSize:[UIFont fontWithName:DeviceFontName size:14] withWidth:w];
        r.size=size;
        _address.frame=r;
    }else{
        r.size.width=w;
        r.size.height=self.label.frame.size.height;
        _address.frame=r;
    }
}
@end
