//
//  ManagerPhotoSelectViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ManagerPhotoSelectViewController.h"
#import "CaseCameraImage.h"
#import "ToolBarView.h"
#import "UIImage+TPCategory.h"
#import "AlertHelper.h"
#import "UIImageView+WebCache.h"

#define SosHeadImageHeight 270.0f

@interface ManagerPhotoSelectViewController (){
   CaseCameraImage *_cameraImage;
}
- (void)buttonViewerClick;
- (void)buttonCameraClick;
- (void)buttonPrevClick;
- (void)buttonSubmitClick;
- (CGSize)autoImageSize:(CGSize)imgSize;
- (void)reLoadPrevImage:(UIImage*)img;
@end

@implementation ManagerPhotoSelectViewController
- (void)dealloc{
    [super dealloc];
    if (_imageCropper) {
        [_imageCropper release];
    }
    [_cameraImage release],_cameraImage=nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cameraImage=[[CaseCameraImage alloc] init];
    _cameraImage.delegate=self;
    
    _imageCropper=nil;
	
    CGFloat topY=10;
    UIImage *placeImg=[UIImage imageNamed:@"head_big_photo.png"];
    _preview=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-placeImg.size.width)/2, topY, placeImg.size.width, placeImg.size.height)];
    _preview.contentMode=UIViewContentModeScaleAspectFill;
    BOOL hasImg=NO;
    if (self.photoDelegate&&[self.photoDelegate respondsToSelector:@selector(viewerShowImage)]) {
        UIImage *img=[self.photoDelegate viewerShowImage];
        if (img) {
            hasImg=YES;
            [self reLoadPrevImage:img];
        }
    }
    if (!hasImg) {
         if (self.photoDelegate&&[self.photoDelegate respondsToSelector:@selector(viewerImageURLString)]) {
             hasImg=YES;
             NSString *urlString=[self.photoDelegate viewerImageURLString];
             [_preview setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                 if (image) {
                     [self reLoadPrevImage:image];
                 }else{
                    [_preview setImage:placeImg];
                 }
             }];
         }
    }
    if (!hasImg) {
        [_preview setImage:placeImg];
    }
    
    [self.view addSubview:_preview];
    [self.view sendSubviewToBack:_preview];
    
    topY+=placeImg.size.height+10+5;
    UIImage *imgPhotos=[UIImage imageNamed:@"head_photos.png"];
    UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame=CGRectMake((self.view.bounds.size.width-imgPhotos.size.width)/2, topY, imgPhotos.size.width, imgPhotos.size.height);
    [_button setImage:imgPhotos forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonViewerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    
    topY+=imgPhotos.size.height+10;
    UIImage *imgCamera=[UIImage imageNamed:@"head_camera.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((self.view.bounds.size.width-imgCamera.size.width)/2, topY, imgCamera.size.width, imgPhotos.size.height);
    [btn setImage:imgCamera forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonCameraClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    ToolBarView *buttons=[[ToolBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-[self topHeight]-44, self.view.bounds.size.width, 44)];
    //buttons.cancel.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, 44);
    //buttons.submit.frame=CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, buttons.frame.size.height);
    //[buttons.cancel setTitle:@"上一步" forState:UIControlStateNormal];
    //[buttons.cancel addTarget:self action:@selector(buttonPrevClick) forControlEvents:UIControlEventTouchUpInside];
    [buttons.button setTitle:@"完成" forState:UIControlStateNormal];
    [buttons.button addTarget:self action:@selector(buttonSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttons];
    [buttons release];
}
//浏览
- (void)buttonViewerClick{
    [_cameraImage showAlbumInController:self];
}
//照相
- (void)buttonCameraClick{
    [_cameraImage showCameraInController:self];
}
//上一步
- (void)buttonPrevClick{
    if (_imageCropper) {
        if (self.photoDelegate&&[self.photoDelegate respondsToSelector:@selector(selectedPhotoWithImage:)]) {
            [self.photoDelegate selectedPhotoWithImage:[_imageCropper getCroppedImage]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//完成
- (void)buttonSubmitClick{
    if (_imageCropper) {
        if (self.photoDelegate&&[self.photoDelegate respondsToSelector:@selector(selectedPhotoWithImage:)]) {
            [self.photoDelegate selectedPhotoWithImage:[_imageCropper getCroppedImage]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//完成图片选择
- (void)finishedImage:(UIImage*)image{
    if (image.size.width<90||image.size.height<104) {
        [AlertHelper initWithTitle:@"提示" message:@"头像大小必须大于或等于90*104像素!"];
        return;
    }
    if (_imageCropper) {
        [_imageCropper removeFromSuperview];
        [_imageCropper release],_imageCropper=nil;
    }
    
    UIImage *realImage=[image scaleToSize:[self autoImageSize:image.size]];
    
    CGRect r=CGRectMake((self.view.bounds.size.width-realImage.size.width)/2,(SosHeadImageHeight-realImage.size.height)/2, realImage.size.width, realImage.size.height);
    _imageCropper = [[NLImageCropperView alloc] initWithFrame:r];
    [self.view addSubview:_imageCropper];
    [_imageCropper setImage:realImage];
    [_imageCropper setCropRegionRect:CGRectMake((realImage.size.width-170)*_imageCropper.scaleReal/2, (realImage.size.width-178)*_imageCropper.scaleReal/2, 170*_imageCropper.scaleReal, 178*_imageCropper.scaleReal)];
}
- (CGSize)autoImageSize:(CGSize)imgSize
{
    CGFloat oldWidth = imgSize.width;
    CGFloat oldHeight = imgSize.height;
    CGSize saveSize =imgSize;
    
    CGSize defaultSize =CGSizeMake(self.view.bounds.size.width, SosHeadImageHeight); //默認大小
    CGFloat wPre = oldWidth / defaultSize.width;
    CGFloat hPre = oldHeight / defaultSize.height;
    if (oldWidth > defaultSize.width || oldHeight > defaultSize.height) {
        if (wPre > hPre) {
            saveSize.width = defaultSize.width;
            saveSize.height = oldHeight / wPre;
        }
        else {
            saveSize.width = oldWidth / hPre;
            saveSize.height = defaultSize.height;
        }
    }
    if (saveSize.width>defaultSize.width) {
        saveSize.width=defaultSize.width;
    }
    if (saveSize.height>defaultSize.height) {
        saveSize.height=defaultSize.height;
    }
    return saveSize;
}
- (void)reLoadPrevImage:(UIImage*)img{
    CGSize size=[self autoImageSize:img.size];
    CGRect r=CGRectMake((self.view.bounds.size.width-size.width)/2,(SosHeadImageHeight-size.height)/2, size.width, size.height);
    _preview.frame=r;
    [_preview setImage:img];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
