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
#import "LoginButtons.h"
#import "ASIServiceHTTPRequest.h"
#import "ManagerPhotoSelectViewController.h"
@interface SOSEditHandleController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    LoginButtons *_buttons;
}
@property (nonatomic,assign) CGRect tableRect;
- (void)buttonCancelClick;
- (void)buttonSubmitClick:(UIButton*)btn;
- (void)loadSingleSosInfo;
- (void)updateFormUI;
- (void)updateFormUI:(NSDictionary*)item;
- (void)buttonSelectedPhotoClick;
- (void)done:(id)sender;
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification;
@end

@implementation SOSEditHandleController
- (void)dealloc{
    [super dealloc];
    [_buttons release];
    [_tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    r.size.height-=[self topHeight]+44;
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    self.tableRect=r;
    
    _buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0, r.size.height+r.origin.y, self.view.bounds.size.width, 44)];
    [_buttons.submit setTitle:@"提交" forState:UIControlStateNormal];
    [_buttons.cancel addTarget:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttons.submit addTarget:self action:@selector(buttonSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttons];
    
    TKHeadPhotoCell *cell1=[[[TKHeadPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell1.button addTarget:self action:@selector(buttonSelectedPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    TKLabelCell *cell2=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.label.text=@"车牌号码:";
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"内容";
    
    TKTextViewCell *cell4=[[[TKTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell4.textView.placeholder=@"请输入内容";
    
    TKLabelCell *cell5=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell5.label.text=@"处理回复";
    
    TKTextViewCell *cell6=[[[TKTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell6.textView.placeholder=@"请输入处理回复";
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
    
    //点击空白处，聊藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapGestureRecognizer.numberOfTapsRequired =1;
    tapGestureRecognizer.cancelsTouchesInView =NO;
    [_tableView addGestureRecognizer:tapGestureRecognizer];  //只需要点击非文字输入区域就会响应hideKeyBoard
    [tapGestureRecognizer release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)done:(id)sender
{
    TKTextViewCell *cell1=self.cells[3];
    [cell1.textView resignFirstResponder];
    
    TKTextViewCell *cell2=self.cells[5];
    [cell2.textView resignFirstResponder];
}
#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //取得键盘的大小
    CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {//显示键盘
        CGRect r=_tableView.frame;
        CGRect r1=_buttons.frame;
        r.size.height=self.tableRect.size.height-kbFrame.size.height;
        r1.origin.y=r.origin.y+r.size.height;
        
        NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        // 添加移动动画，使视图跟随键盘移动
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            _tableView.frame=r;
            _buttons.frame=r1;
        }];
        
    }
    else  {//隐藏键盘
        CGRect r=_tableView.frame;
        CGRect r1=_buttons.frame;
        r.size.height=self.tableRect.size.height;
        
        r1.origin.y=self.tableRect.origin.y+r.size.height;
        
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            _tableView.frame=r;
            _buttons.frame=r1;
        }];
    }
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
//选头像
- (void)buttonSelectedPhotoClick{
    ManagerPhotoSelectViewController *photo=[[ManagerPhotoSelectViewController alloc] init];
    photo.title=@"SOS报警头像";
    photo.photoDelegate=self;
    [self.navigationController pushViewController:photo animated:YES];
    [photo release];
}
//取消
- (void)buttonCancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
- (void)buttonSubmitClick:(UIButton*)btn{
    /***
    btn.enabled=NO;
    Account *acc=[Account unarchiverAccount];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"UserID", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell2.select value],@"CarID", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:imageStr,@"Image", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:cell3.textView.text,@"Contents", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataSOSWebservice;
    args.serviceNameSpace=DataSOSNameSpace;
    args.methodName=@"AddSOSInfo";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在新增SOS报警,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
     ***/
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
