//
//  SOSEditHandleController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SOSEditHandleController.h"
#import "TKHeadPhotoCell.h"
#import "TKLabelCell.h"
#import "TKTextViewCell.h"
#import "ASIServiceHTTPRequest.h"
#import "ManagerPhotoSelectViewController.h"
@interface SOSEditHandleController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}
@property (nonatomic,assign) CGRect tableRect;
- (void)loadSingleSosInfo;
- (void)updateFormUI;
- (void)updateFormUI:(NSDictionary*)item;
@end

@implementation SOSEditHandleController
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSingleSosInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"SOS报警";
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight];
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    self.tableRect=r;
    
   
    
    TKHeadPhotoCell *cell1=[[[TKHeadPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    TKLabelCell *cell2=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.label.text=@"车牌号码:";
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"内容";
    
    TKTextViewCell *cell4=[[[TKTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    //cell4.textView.placeholder=@"请输入内容";
    cell4.textView.editable=NO;
    
    TKLabelCell *cell5=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell5.label.text=@"处理回复";
    
    TKTextViewCell *cell6=[[[TKTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell6.textView.placeholder=@"请输入处理回复";
    cell6.textView.editable=NO;
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
    
}
//加载单笔信息
- (void)loadSingleSosInfo{
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"GetSOSInfo";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.SOSPKID,@"SOSPKID", nil], nil];
    [self showLoadingAnimatedWithTitle:@"正在加载,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            NSArray *arr=[dic objectForKey:@"Result"];
            if (arr&&[arr count]>0) {
                boo=YES;
                NSDictionary *item=[arr objectAtIndex:0];
                [self updateFormUI:item];
            }
        }
        if (!boo) {
           [self updateFormUI];
           [self hideLoadingFailedWithTitle:@"资料加载失败!" completed:nil];
        }
    }];
    [request setFailedBlock:^{
        [self updateFormUI];
        [self hideLoadingFailedWithTitle:@"资料加载失败!" completed:nil];
    }];
    [request startAsynchronous];
}
- (void)updateFormUI{
    TKHeadPhotoCell *cell1=self.cells[0];
    [cell1 setPhotoWithImageUrlString:self.Entity.Image];
    TKLabelCell *cell2=self.cells[1];
    cell2.label.text=[NSString stringWithFormat:@"车牌号码:%@",self.Entity.CarNo];
    [_tableView reloadData];
}
- (void)updateFormUI:(NSDictionary*)item{
    TKHeadPhotoCell *cell1=self.cells[0];
    [cell1 setPhotoWithImageUrlString:[item objectForKey:@"Image"]];
    TKLabelCell *cell2=self.cells[1];
    cell2.label.text=[NSString stringWithFormat:@"车牌号码:%@",[item objectForKey:@"CarNo"]];
    
    TKTextViewCell *cell3=self.cells[3];
    cell3.textView.text=[item objectForKey:@"Contents"];
    
    TKTextViewCell *cell4=self.cells[5];
    cell4.textView.text=[item objectForKey:@"BackContent"];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark ManagerPhotoDelegate Methods
- (void)selectedPhotoWithImage:(UIImage*)image{
    TKHeadPhotoCell *cell1=self.cells[0];
    [cell1 setPhotoWithImage:image];
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell1];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (NSString*)viewerImageURLString{
    return self.Entity.Image;
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell=self.cells[indexPath.row];
    if ([cell isKindOfClass:[TKLabelCell class]]) {
        return 30.0;
    }
    if ([cell isKindOfClass:[TKHeadPhotoCell class]]) {
        return 150.0;
    }
    if ([cell isKindOfClass:[TKTextViewCell class]]) {
        return 120;
    }
    return 44.0;
}
@end
