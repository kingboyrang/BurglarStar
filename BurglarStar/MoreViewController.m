//
//  MoreViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/23.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "MoreViewController.h"
#import "EditPwdViewController.h"
#import "AlertHelper.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "Account.h"
#import "SupervisionViewController.h"
#import "AreaViewController.h"
#import "OnlineMapViewController.h"
#import "UIButton+TPCategory.h"
@interface MoreViewController ()
@end

@implementation MoreViewController

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
    
    self.title=@"个人中心";
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
	MoreMenuView *menu=[[MoreMenuView alloc] initWithFrame:r];
    menu.delegate=self;
    [self.view addSubview:menu];
    [menu release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UICollectionViewDataSource
- (void)selectedMenuItemIndex:(NSInteger)index sender:(id)sender{
    if (index==0) {//电子围栏
        AreaViewController *area=[[AreaViewController alloc] init];
        [self.navigationController pushViewController:area animated:YES];
        [area release];    }
    if (index==1) {//离线地图
         OnlineMapViewController *edit=[[OnlineMapViewController alloc] init];
         [self.navigationController pushViewController:edit animated:YES];
         [edit release];
    }
    if (index==2) {//个人信息
        UserInfoViewController *user=[[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:user animated:YES];
        [user release];
    }
    if (index==3) {//修改密码
        EditPwdViewController *edit=[[EditPwdViewController alloc] init];
        [self.navigationController pushViewController:edit animated:YES];
        [edit release];
    }
    if (index==4) {//注销帐号
        [AlertHelper initWithTitle:@"提示" message:@"确认注销?" cancelTitle:@"取消" cancelAction:nil confirmTitle:@"确认" confirmAction:^{
            [Account closed];
            LoginViewController *login=[[[LoginViewController alloc] init] autorelease];
            //login.navigationItem.leftBarButtonItem=[login barBackButtonItem];
            NSMutableArray *arr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [arr replaceObjectAtIndex:1 withObject:login];
            self.navigationController.viewControllers=arr;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    if (index==5) {//意见反馈
        
    }
    if (index==6) {//关于我们
        
    }
    if (index==7) {//帮助
        
    }
}
@end
