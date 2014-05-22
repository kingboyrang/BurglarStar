//
//  EditSupervisionHead.m
//  LocationService
//
//  Created by aJia on 2013/12/25.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "EditSupervisionHead.h"
#import "UIImageView+WebCache.h"
#import "LoginButtons.h"
#import "CaseCameraImage.h"
#import "UIImage+TPCategory.h"
#import "AlertHelper.h"
#import "SupervisionViewController.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"

@interface EditSupervisionHead (){
}
@property (nonatomic, strong) CaseCameraImage *cameraImage;
- (void)buttonViewerClick;
- (void)buttonCameraClick;
//- (void)buttonCancelClick;
- (void)buttonSubmitClick;
- (void)uploadImageWithId:(NSString*)personId completed:(void(^)(NSString *fileName))completed;
- (CGSize)autoImageSize:(CGSize)imgSize;
@end

@implementation EditSupervisionHead
- (void)dealloc{
    [super dealloc];
    if (_imageCropper) {
        [_imageCropper release];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//回列表
- (void)buttonListClick{
    NSInteger index=[self.navigationController.viewControllers count]-1-1;
    NSInteger total=[self.navigationController.viewControllers count]-1-1;
    for (NSInteger i=total; i>=0; i--) {
        if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[SupervisionViewController class]]) {
            index=i;
            break;
        }
    }
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:index] animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=self.Entity.Name;
    
    /***
    UIBarButtonItem *rightBtn=[UIBarButtonItem barButtonWithTitle:@"列表" target:self action:@selector(buttonListClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=rightBtn;
     ***/
    
    self.cameraImage=[[CaseCameraImage alloc] init];
    self.cameraImage.delegate=self;
	
    //CGFloat topY=25;
    CGFloat topY=10;
    UIImage *placeImg=[UIImage imageNamed:@"head_big_photo.png"];
    _preview=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-placeImg.size.width)/2, topY, placeImg.size.width, placeImg.size.height)];
    if (self.Entity&&self.Entity.Photo&&[self.Entity.Photo length]>0) {
        [_preview setImageWithURL:[NSURL URLWithString:self.Entity.Photo] placeholderImage:placeImg];
    }else{
        [_preview setImage:placeImg];
    }
    [self.view addSubview:_preview];
    [self.view sendSubviewToBack:_preview];
    
    //topY=310;
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
    
    LoginButtons *buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-[self topHeight]-44, self.view.bounds.size.width, 44)];
    buttons.cancel.frame=CGRectMake(0, 0, self.view.bounds.size.width/3, 44);
    buttons.submit.frame=CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, buttons.frame.size.height);
    [buttons.cancel setTitle:@"上一步" forState:UIControlStateNormal];
    [buttons.cancel addTarget:self action:@selector(buttonPrevClick) forControlEvents:UIControlEventTouchUpInside];
    [buttons.submit setTitle:@"完成" forState:UIControlStateNormal];
    [buttons.submit addTarget:self action:@selector(buttonSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    buttons.cancel.hidden=YES;
    /***
    if (self.operateType==2) {
        buttons.cancel.hidden=YES;
        buttons.submit.frame=CGRectMake(0, 0, buttons.frame.size.width, buttons.frame.size.height);
        [buttons.submit setTitle:@"完成" forState:UIControlStateNormal];
        [buttons.submit addTarget:self action:@selector(buttonSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [buttons.cancel setTitle:@"取消" forState:UIControlStateNormal];
        [buttons.submit setTitle:@"完成" forState:UIControlStateNormal];
        [buttons.cancel addTarget:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [buttons.submit addTarget:self action:@selector(buttonSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    }
     ***/
    [self.view addSubview:buttons];
    [buttons release];
    
}
//上一步
- (void)buttonPrevClick{
    if (self.operateType==2) {//修改
        if (_imageCropper) {
            [self uploadImageWithId:self.Entity.ID completed:^(NSString *fileName) {
                SEL sel=NSSelectorFromString(@"finishSelectedImage:");
                if (self.delegate&&[self.delegate respondsToSelector:sel]) {
                    [self.delegate performSelector:sel withObject:[_imageCropper getCroppedImage]];
                }
                SEL sel1=NSSelectorFromString(@"finishUploadFileName:");
                if (self.delegate&&[self.delegate respondsToSelector:sel1]) {
                    [self.delegate performSelector:sel1 withObject:fileName];
                }
            }];
        }
    }else{
        if (_imageCropper) {
            //[self uploadImageWithId:self.Entity.ID completed:nil];
            SEL sel2=NSSelectorFromString(@"finishSelectedImage:");
            if (self.delegate&&[self.delegate respondsToSelector:sel2]) {
                [self.delegate performSelector:sel2 withObject:[_imageCropper getCroppedImage]];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finishedImage:(UIImage*)image{
    
    if (image.size.width<90||image.size.height<104) {
        [AlertHelper initWithTitle:@"提示" message:@"头像大小必须大于或等于90*104像素!"];
        return;
    }
    if (_imageCropper) {
        [_imageCropper removeFromSuperview];
        [_imageCropper release];
    }
    
    //UIImage *realImage=[image scaleToSize:CGSizeMake(300, 300)];
    UIImage *realImage=[image scaleToSize:[self autoImageSize:image.size]];
    
    CGRect r=CGRectMake((self.view.bounds.size.width-realImage.size.width)/2,(270-realImage.size.height)/2, realImage.size.width, realImage.size.height);
    _imageCropper = [[NLImageCropperView alloc] initWithFrame:r];
    [self.view addSubview:_imageCropper];
    [_imageCropper setImage:realImage];
    [_imageCropper setCropRegionRect:CGRectMake((realImage.size.width-170)*_imageCropper.scaleReal/2, (realImage.size.width-178)*_imageCropper.scaleReal/2, 170*_imageCropper.scaleReal, 178*_imageCropper.scaleReal)];
    
}
- (void)uploadImageWithId:(NSString*)personId completed:(void(^)(NSString *fileName))completed{
    if (_imageCropper) {
        if (!self.hasNetWork) {
            [self showErrorNetWorkNotice:nil];
            return;
        }
        [self showLoadingAnimatedWithTitle:@"正在上传头像,请稍后..."];
        NSString *base64=[[_imageCropper getCroppedImage] imageBase64String];
        NSMutableArray *params=[NSMutableArray arrayWithCapacity:2];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:base64,@"imgbase64", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:personId,@"personID", nil]];
        
        ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
        args.serviceURL=DataWebservice1;
        args.serviceNameSpace=DataNameSpace1;
        args.methodName=@"UpImage";
        args.soapParams=params;
        ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
        [request setCompletionBlock:^{
            BOOL boo=NO;
            NSString *name=@"";
            if (request.ServiceResult.success) {
                XmlNode *node=[request.ServiceResult methodNode];
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
                if (![[dic objectForKey:@"Result"] isEqualToString:@"false"]) {
                    name=[dic objectForKey:@"Result"];
                    boo=YES;
                }
            }
            
            if (!boo) {
                [self hideLoadingFailedWithTitle:@"上传头像失败!" completed:nil];
            }else{
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    if (completed) {
                        completed(name);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
        [request setFailedBlock:^{
            [self hideLoadingFailedWithTitle:@"上传头像失败!" completed:nil];
            if (completed) {
                completed(@"");
            }

        }];
        [request startAsynchronous];
    }else{
        if (completed) {
            completed(@"");
        }
    }
}
//完成
- (void)buttonSubmitClick{
    if (self.operateType==2) {//修改
        if (_imageCropper) {
            [self uploadImageWithId:self.Entity.ID completed:^(NSString *fileName) {
                SEL sel=NSSelectorFromString(@"finishSelectedImage:");
                if (self.delegate&&[self.delegate respondsToSelector:sel]) {
                    [self.delegate performSelector:sel withObject:[_imageCropper getCroppedImage]];
                }
                SEL sel1=NSSelectorFromString(@"finishUploadFileName:");
                if (self.delegate&&[self.delegate respondsToSelector:sel1]) {
                    [self.delegate performSelector:sel1 withObject:fileName];
                }
            }];
        }else{
            //[AlertHelper initWithTitle:@"提示" message:@"未选择头像!"];
        }
    }else{
        if (_imageCropper) {
            //[self uploadImageWithId:self.Entity.ID completed:nil];
            SEL sel2=NSSelectorFromString(@"finishSelectedImage:");
            if (self.delegate&&[self.delegate respondsToSelector:sel2]) {
                [self.delegate performSelector:sel2 withObject:[_imageCropper getCroppedImage]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //[AlertHelper initWithTitle:@"提示" message:@"未选择头像!"];
        }
    }
}
//浏览
- (void)buttonViewerClick{
    [self.cameraImage showAlbumInController:self];
}
//照相
- (void)buttonCameraClick{
    [self.cameraImage showCameraInController:self];
}
- (CGSize)autoImageSize:(CGSize)imgSize
{
    CGFloat oldWidth = imgSize.width;
    CGFloat oldHeight = imgSize.height;
    CGSize saveSize =imgSize;
    
    CGSize defaultSize =CGSizeMake(self.view.bounds.size.width, 250); //默認大小
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
