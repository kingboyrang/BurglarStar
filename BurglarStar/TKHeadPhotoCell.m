//
//  TKHeadPhotoCell.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "TKHeadPhotoCell.h"
#import "UIImageView+WebCache.h"
@implementation TKHeadPhotoCell
@synthesize hasImage=_hasImg;
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UIImage *image=[UIImage imageNamed:@"head_photo.png"];
    _imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_imageHead setImage:image];
	[self.contentView addSubview:_imageHead];
    
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_button];
    
    _hasImg=NO;
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)setPhotoWithImage:(UIImage*)img{
    CGRect r=_imageHead.frame;
    [_imageHead setImage:img];
    _imageHead.frame=r;
    _hasImg=YES;
}
- (void)setPhotoWithImageUrlString:(NSString*)url{
    _hasImg=YES;
    CGRect r=_imageHead.frame;
    [_imageHead setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head_photo.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            [_imageHead setImage:image];
            _imageHead.frame=r;
        }
    }];
}

- (void) layoutSubviews {
    [super layoutSubviews];
	
    CGRect r=_imageHead.frame;
    r.origin.x=(self.frame.size.width-r.size.width)/2;
    r.origin.y=(self.frame.size.height-r.size.height)/2;
    _imageHead.frame=r;
    
    _button.frame=r;
    
}
@end
