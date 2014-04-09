//
//  MeterViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MeterViewController.h"
#import "UIImage+TPCategory.h"
@interface MeterViewController ()

@end

@implementation MeterViewController

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
	self.title=[NSString stringWithFormat:@"%@ %@",self.Entity.Name,self.Entity.formatDateText];
    
    UIImage *image=[[UIImage imageNamed:@"meta.png"] imageByScalingToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-44)];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, image.size.width, image.size.height)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    [imageView release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
