//
//  TKHeadPhotoCell.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKHeadPhotoCell : UITableViewCell{
    BOOL _hasImg;
}
@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) BOOL hasImage;
@property (nonatomic,readonly) UIImage *photo;
- (void)setPhotoWithImage:(UIImage*)img;
- (void)setPhotoWithImageUrlString:(NSString*)url;
@end
