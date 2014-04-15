//
//  MonitorPersonViewController.m
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "MonitorPersonViewController.h"
#import "SupervisionPerson.h"
#import "AppHelper.h"
#import "UIImageView+WebCache.h"
#import "UIImage+TPCategory.h"
#import "IndexViewController.h"
#import "ASIServiceHTTPRequest.h"
@interface MonitorPersonViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
- (void)loadingMonitors:(NSString*)name message:(NSString*)msg;
@end

@implementation MonitorPersonViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release];
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
    
    CGFloat leftX=self.view.bounds.size.width/2-30;
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(leftX, 0, self.view.bounds.size.width-leftX-3, 44)];
    searchBar.tag=300;
    searchBar.delegate = self;
    searchBar.placeholder =@"请输入名称";
    searchBar.backgroundColor=[UIColor clearColor];
#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        searchBar.barTintColor=[UIColor clearColor];
        UIView *searchV = [[searchBar subviews] lastObject];
        for (id v in searchV.subviews) {
            if ([v isKindOfClass:[UITextField class]])
            {
                UITextField *field=(UITextField*)v;
                field.clearButtonMode=UITextFieldViewModeNever;
                break;
            }
        }
    }
#endif
    //UITextField *field = [[searchBar subviews] lastObject];
    //field.clearButtonMode=UITextFieldViewModeNever;
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *field=(UITextField*)subview;
            field.clearButtonMode=UITextFieldViewModeNever;
            break;
        }
    }
    
    //为UISearchBar添加背景图片
    self.navigationItem.titleView=searchBar;
    [searchBar release];
    
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [self loadingMonitors:@"" message:@"加载"];
}
- (void)loadingMonitors:(NSString*)name message:(NSString*)msg{
    if (![self hasNetWork]) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"WorkNo", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,@"nameStr", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetMonitorPersonInfo";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:[NSString stringWithFormat:@"正在%@,请稍后...",msg]];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        NSDictionary *dic=[request.ServiceResult json];
        if (dic!=nil) {
            [self hideLoadingViewAnimated:nil];
            boo=YES;
            NSArray *source=[dic objectForKey:@"Person"];
            self.list=[AppHelper arrayWithSource:source className:@"SupervisionPerson"];
            [_tableView reloadData];
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:[NSString stringWithFormat:@"%@失败!",msg] completed:nil];
        }

    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:[NSString stringWithFormat:@"%@失败!",msg] completed:nil];
    }];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark -searchbar
/***
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    for (id cc in searchBar.subviews) {
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn=(UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    return YES;
}
 **/
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self loadingMonitors:searchBar.text message:@"查询"];//查询
    //searchBar.showsCancelButton=NO;
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"carCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor=[UIColor clearColor];
        
    }
    SupervisionPerson *entity=self.list[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:entity.Photo] placeholderImage:[UIImage imageNamed:@"bg02.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            if (image.size.width>70||image.size.height>84) {
                [cell.imageView setImage:[image imageByScalingToSize:CGSizeMake(70, 84)]];
            }else{
                [cell.imageView setImage:image];
            }
        }
    }];
    cell.textLabel.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    cell.textLabel.text=entity.Name;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id v=self.navigationController.viewControllers[0];
    if ([v isKindOfClass:[IndexViewController class]]) {
        IndexViewController *controls=(IndexViewController*)v;
        [controls setSelectedSupervisionCenter:self.list[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
