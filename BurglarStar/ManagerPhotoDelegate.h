//
//  UploadPhotoDelegate.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ManagerPhotoDelegate <NSObject>
@optional
- (void)selectedPhotoWithImage:(UIImage*)image;
- (NSString*)viewerImageURLString;
- (UIImage*)viewerShowImage;
@end
