//
//  SOSAddViewController.m
//  BurglarStar
//
//  Created by aJia on 2014/4/16.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "SOSAddViewController.h"
#import "TKHeadPhotoCell.h"
#import "TKSoSBusCell.h"
#import "TKTextViewCell.h"
#import "LoginButtons.h"
#import "UIImage+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
#import "ManagerPhotoSelectViewController.h"
#import "AlertHelper.h"
#import "CVUISelect.h"
@interface SOSAddViewController ()<UITableViewDelegate,UITableViewDataSource,CVUISelectDelegate>{
    UITableView *_tableView;
    LoginButtons *_buttons;
}
@property (nonatomic,assign) CGRect tableRect;
- (void)buttonCancelClick;
- (void)buttonSubmitClick:(UIButton*)btn;
- (void)buttonSelectedPhotoClick;
- (void)done:(id)sender;
- (void)loadBusSource;//加载车辆号码
@end

@implementation SOSAddViewController
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
        
    }
    return self;
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
    TKSoSBusCell *cell2=[[[TKSoSBusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.select.delegate=self;
    TKTextViewCell *cell3=[[[TKTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.textView.placeholder=@"请输入意见反馈";
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3, nil];
    
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
    
    [self loadBusSource];//加载车辆号码
}
//点击弹出车牌号码选择
-(void)showPopoverSelect:(id)sender{
    TKTextViewCell *cell=self.cells[2];
    [cell.textView resignFirstResponder];
    [self loadBusSource];
}
//加载车辆号码
- (void)loadBusSource{
    TKSoSBusCell *cell=self.cells[1];
    if (cell.select.pickerData&&[cell.select.pickerData count]>0) {
        return;
    }
    Account *acc=[Account unarchiverAccount];
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.methodName=@"GetSuperviseInfo";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"WorkNo", nil], nil];
    
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            NSArray *source=[dic objectForKey:@"Person"];
            //ID,Name
            [cell.select setDataSourceForArray:source dataTextName:@"Name" dataValueName:@"ID"];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)done:(id)sender
{
     TKTextViewCell *cell=self.cells[2];
     [cell.textView resignFirstResponder];
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

    TKHeadPhotoCell *cell1=self.cells[0];
    if (!cell1.hasImage) {
        [AlertHelper initWithTitle:@"提示" message:@"请上传头像!"];
        return;
    }
    TKSoSBusCell *cell2=self.cells[1];
    if ([cell2.select.value length]==0) {
        [AlertHelper initWithTitle:@"提示" message:@"请选择车牌号码!"];
        return;
    }
    TKTextViewCell *cell3=self.cells[2];
    if (!cell3.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入意见反馈!"];
        return;
    }
    NSString *imageStr=@"";
    if (cell1.imageView.image) {
        imageStr=[cell1.imageView.image imageBase64String];
    }
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
    [request setCompletionBlock:^{
        btn.enabled=YES;
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            NSDictionary *dic=[request.ServiceResult json];
            if (dic&&[dic.allKeys containsObject:@"Result"]&&[[dic objectForKey:@"Result"] length]>2) {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"SOS报警新增失败！" completed:nil];
        }
        
    }];
    [request setFailedBlock:^{
        btn.enabled=YES;
        [self hideLoadingFailedWithTitle:@"SOS报警新增失败！" completed:nil];
    }];
    [request startAsynchronous];

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
- (UIImage*)viewerShowImage{
    TKHeadPhotoCell *cell1=self.cells[0];
    if (cell1.hasImage) {
        return cell1.imageView.image;
    }
    return nil;
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
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
    if ([cell isKindOfClass:[TKHeadPhotoCell class]]) {
        return 150.0;
    }
    if ([cell isKindOfClass:[TKTextViewCell class]]) {
        return 150;
    }
    return 44.0;
}
@end
