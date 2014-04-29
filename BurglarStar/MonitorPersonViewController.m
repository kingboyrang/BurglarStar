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
- (void)done:(id)sender;
- (void)addMonitorSearch;
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
    self.title=@"车辆信息";
    [self addMonitorSearch];
   
    CGRect r=self.view.bounds;
    r.origin.y=45;
    r.size.height-=[self topHeight]+r.origin.y;
    
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor colorFromHexRGB:@"b8b8b8"];
    [self.view addSubview:_tableView];
    //点击空白处，聊藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapGestureRecognizer.numberOfTapsRequired =1;
    tapGestureRecognizer.cancelsTouchesInView =NO;
    [_tableView addGestureRecognizer:tapGestureRecognizer];  //只需要点击非文字输入区域就会响应hideKeyBoard
    [tapGestureRecognizer release];
    
    [self loadingMonitors:@"" message:@"加载"];
}
- (void)addMonitorSearch{
    UIImage *imgV=[UIImage imageNamed:@"top_bg02.png"];
    imgV=[imgV stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, bgView.frame.size.height)];
    [imgView setImage:imgV];
    [bgView addSubview:imgView];
    [imgView release];
    
    CGFloat leftX=self.view.bounds.size.width-30;
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-leftX)/2, 0.5, leftX, 44)];
    searchBar.tag=300;
    searchBar.delegate = self;
    searchBar.placeholder =@"请输入名称";
    searchBar.backgroundColor=[UIColor clearColor];
#ifdef __IPHONE_7_0
    if (IOSVersion>= 7.0) {
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
        float  iosversion7_1 = 7.1 ;
        if (IOSVersion >= iosversion7_1)
        {
            //iOS7.1
            [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar setBackgroundColor:[UIColor clearColor]];
            
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
    [bgView addSubview:searchBar];
    [searchBar release];
    [self.view addSubview:bgView];
    [bgView release];
}
-(void)done:(id)sender
{
    UISearchBar *searchBar=(UISearchBar*)[self.view viewWithTag:300];
    [searchBar resignFirstResponder];
    [self loadingMonitors:[searchBar.text Trim] message:@"查询"];//查询
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
    //NSLog(@"soap=%@",args.bodyMessage);
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
    UIImage *placeImg=[UIImage createRoundedRectImage:[UIImage imageNamed:@"bg02.png"] size:CGSizeMake(70, 84) radius:8.0];
    SupervisionPerson *entity=self.list[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:entity.Photo] placeholderImage:placeImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            UIImage *img=[UIImage createRoundedRectImage:image size:CGSizeMake(70, 84) radius:8.0];
             [cell.imageView setImage:img];
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
