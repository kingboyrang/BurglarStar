//
//  ManagerPhotoSelectViewController.h
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "ManagerPhotoDelegate.h"
#import "NLImageCropperView.h"
@interface ManagerPhotoSelectViewController : BasicViewController{
    NLImageCropperView* _imageCropper;
}
@property (nonatomic, strong) UIImageView *preview;
@property (nonatomic,assign) id<ManagerPhotoDelegate> photoDelegate;
- (void)finishedImage:(UIImage*)image;
@end
