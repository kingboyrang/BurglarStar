//
//  BasicNavigationController.m
//  LocationService
//
//  Created by aJia on 2013/12/18.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()
-(void)popself;
-(UIBarButtonItem*)customLeftBackButton;
@end

@implementation BasicNavigationController

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
}
-(void)popself
{
   [self popViewControllerAnimated:YES];
}
-(UIBarButtonItem*)customLeftBackButton{

    UIImage *image=[UIImage imageNamed:@"left_back.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted=YES;
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return  [leftBtn autorelease];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.topViewController isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    }
     if ([self.viewControllers count]==1){
       //viewController.navigationItem.leftBarButtonItem =[self loadLogoImage];
     }else{
       viewController.navigationItem.leftBarButtonItem =[self customLeftBackButton];
     }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
