//
//  EditSupervisionViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/27.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "EditSupervisionViewController.h"
#import "ToolBarView.h"
#import "TKLabelCell.h"
#import "TKTextFieldCell.h"
#import "UIImageView+WebCache.h"
#import "EditSupervisionHead.h"
#import "Account.h"
#import "AlertHelper.h"
#import "SupervisionExtend.h"
#import "TKEmptyCell.h"
#import "UIBarButtonItem+TPCategory.h"
#import "ASIServiceHTTPRequest.h"
@interface EditSupervisionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    UIImageView *_imageHead;
    ToolBarView *_toolBar;
   
}
@property (nonatomic,assign) CGRect tableRect;
- (void)buttonSubmit;
- (void)buttonCancel;
- (void)buttonChooseImage;
- (void)finishEditTrajectory:(void(^)(NSString *personId))completed;
- (void)loadingPersonInfo;
@end

@implementation EditSupervisionViewController
- (void)dealloc{
    //[UITableView release];
    [super dealloc];
    [_tableView release];
    [_imageHead release];
    [_toolBar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadingPersonInfo];//修改时加载信息
}
//回列表
- (void)buttonListClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"车辆管理";
    
    UIBarButtonItem *rightBtn=[UIBarButtonItem barButtonWithTitle:@"列表" target:self action:@selector(buttonListClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
	CGRect r=self.view.bounds;
    r.size.height-=44+[self topHeight];
    
    self.tableRect=r;
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.bounces=NO;
    //_tableView.autoresizesSubviews=YES;
    //_tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    
    _toolBar=[[ToolBarView alloc] initWithFrame:CGRectMake(0,_tableView.frame.size.height+_tableView.frame.origin.y, self.view.bounds.size.width, 44)];
    //_toolBar.cancel.frame=CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 44);
    //_toolBar.submit.frame=CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 44);
    //[_toolBar.cancel setTitle:@"下一步" forState:UIControlStateNormal];
    [_toolBar.button setTitle:@"完成" forState:UIControlStateNormal];
    [_toolBar.button addTarget:self action:@selector(buttonSubmit) forControlEvents:UIControlEventTouchUpInside];
    //[_toolBar.cancel addTarget:self action:@selector(buttonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
    
    //头像
    TKEmptyCell *cell9=[[[TKEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    UIView *bgView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)] autorelease];
    bgView.backgroundColor=[UIColor clearColor];
    UIImage *image=[UIImage imageNamed:@"head_photo.png"];
    _imageHead=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-image.size.width)/2,bgView.frame.size.height-image.size.height, image.size.width, image.size.height)];
    [_imageHead setImageWithURL:[NSURL URLWithString:self.Entity.Photo] placeholderImage:image];
    [bgView addSubview:_imageHead];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=_imageHead.frame;
    [btn addTarget:self action:@selector(buttonChooseImage) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    [cell9.contentView addSubview:bgView];
    
    
    TKLabelCell *cell1=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell1.label.text=@"名称";
    
    TKTextFieldCell *cell2=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.textField.placeholder=@"请输入名称";
    cell2.textField.delegate=self;
    cell2.textField.text=self.Entity.Name;
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"IMEI号码";
    
    TKTextFieldCell *cell4=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell4.textField.placeholder=@"请输入IMEI号码";
    cell4.textField.text=self.Entity.IMEI;
    cell4.textField.delegate=self;
    
    TKLabelCell *cell5=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell5.label.text=@"SIM卡号";
    
    TKTextFieldCell *cell6=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell6.textField.placeholder=@"请输入SIM卡号";
    cell6.textField.delegate=self;
    cell6.textField.text=self.Entity.SimNo;
    
    TKLabelCell *cell7=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell7.label.text=@"密码";
    
    TKTextFieldCell *cell8=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell8.textField.placeholder=@"请输入密码";
    cell8.textField.secureTextEntry=YES;
    cell8.textField.delegate=self;
    cell8.textField.text=self.Entity.Password;
    
    self.cells=[NSMutableArray arrayWithObjects:cell9,cell1,cell2,cell3,cell4,cell5,cell6,cell7,cell8, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //取得键盘的大小
    CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {//显示键盘
        CGRect r=_tableView.frame;
        CGRect r1=_toolBar.frame;
        r.size.height=self.tableRect.size.height-kbFrame.size.height;
        
        r1.origin.y=r.origin.y+r.size.height;
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            _tableView.frame=r;
            _toolBar.frame=r1;
        }];
    }
    else {//隐藏键盘
        CGRect r=_tableView.frame;
        CGRect r1=_toolBar.frame;
        r.size.height=self.tableRect.size.height;
        
        r1.origin.y=self.tableRect.origin.y+r.size.height;
       
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            _tableView.frame=r;
            _toolBar.frame=r1;
        }];
    }
}
//修改时，加载信息
- (void)loadingPersonInfo{
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"GetPersonByID";
    args.serviceURL=DataWebservice1;
    args.serviceNameSpace=DataNameSpace1;
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"personID", nil], nil];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        NSDictionary *dic=[request.ServiceResult json];
        if(dic!=nil)
        {
            NSArray *source=[dic objectForKey:@"Person"];
            if ([source count]>0) {
                NSDictionary *item=[source objectAtIndex:0];
                //self.PhoneName=[item objectForKey:@"Photo"];//手机号码
                
                self.Entity.Name=[item objectForKey:@"Name"];
                self.Entity.SimNo=[item objectForKey:@"SimNo"];
                self.Entity.IMEI=[item objectForKey:@"DeviceID"];
                self.Entity.Password=[item objectForKey:@"Password"];
                TKTextFieldCell *cell1=self.cells[2];
                cell1.textField.text=self.Entity.Name;
                
                TKTextFieldCell *cell2=self.cells[4];
                cell2.textField.text=self.Entity.IMEI;
                
                TKTextFieldCell *cell3=self.cells[6];
                cell3.textField.text=self.Entity.SimNo;
                
                TKTextFieldCell *cell4=self.cells[8];
                cell4.textField.text=self.Entity.Password;
                
                
                /***
                 "ID":"99deee78-2705-453a-a5e7-3e9d4ca8d433",   --监控目标唯一ID
                 "Name":"韦昌",    --监控目标名称
                 "SimNo":"358688000000158",    --手机SIM卡号
                 "DeviceID":"18665892568",    --终端号
                 "Password":"123456",     --终端密码
                 "Photo":"201308060308567830.png"    --头像图片
                 ***/
                
            }
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//修改
- (void)finishEditTrajectory:(void(^)(NSString *personId))completed{
   
    Account *acc=[Account unarchiverAccount];
    TKTextFieldCell *cell1=self.cells[2];
    
    if (!cell1.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入名称!"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    
    TKTextFieldCell *cell2=self.cells[4];
    if (!cell2.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入IMEI号码!"];
        [cell2.textField becomeFirstResponder];
        return;
    }
    TKTextFieldCell *cell3=self.cells[6];
    if (!cell3.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入SIM卡号!"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    if (![cell3.textField.text isNumberString]) {
        [AlertHelper initWithTitle:@"提示" message:@"SIM卡号只能为数字!"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    if(strlen([cell3.textField.text UTF8String])<11)
    {
        [AlertHelper initWithTitle:@"提示" message:@"SIM卡号必须为11位！"];
        [cell3.textField becomeFirstResponder];
        return;
    }

    TKTextFieldCell *cell4=self.cells[8];
    if (!cell4.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"请输入密码!"];
        [cell4.textField becomeFirstResponder];
        return;
    }
    [self textFieldShouldReturn:cell1.textField];
    [self textFieldShouldReturn:cell2.textField];
    [self textFieldShouldReturn:cell3.textField];
    [self textFieldShouldReturn:cell4.textField];
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    [self showLoadingAnimatedWithTitle:@"修改车辆管理,请稍后..."];
    
        NSMutableArray *params=[NSMutableArray arrayWithCapacity:6];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.ID,@"personID", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell1.textField.text Trim],@"Name", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell3.textField.text Trim],@"phoneNum", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell2.textField.text Trim],@"strIMEI", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell4.textField.text Trim],@"Password", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.Entity.fileName,@"photo", nil]];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"CurWorkNo", nil]];
        
        ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
        args.serviceURL=DataWebservice1;
        args.serviceNameSpace=DataNameSpace1;
        args.methodName=@"UpdatePerson";
        args.soapParams=params;
       ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        NSString *status=@"";
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([[dic objectForKey:@"Result"] isEqualToString:@"1"]) {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    if (completed) {
                        completed(self.Entity.ID);
                    }
                }];
                return;
            }
            if ([dic.allKeys containsObject:@"Result"]) {
                status=[dic objectForKey:@"Result"];
            }
            
        }
        if (!boo) {
            NSString *errorMsg=@"修改车辆管理失败!";
            if ([status isEqualToString:@"Exists"]) {
                errorMsg=@"名称重复!";
            }
            if ([status isEqualToString:@"2"]) {
                errorMsg=@"输入的手机号码已绑定终端,无法修改!";
            }
            if ([status isEqualToString:@"5"]) {
                errorMsg=@"输入的密码与IMEI的密码不匹配,无法修改!";
            }
            if ([status isEqualToString:@"6"]) {
                errorMsg=@"输入的SIM卡号与IMEI的SIM卡不匹配,无法修改!";
            }
            if ([status isEqualToString:@"7"]) {
                errorMsg=@"已存在该终端的目标,无法修改!";
            }
            
            [self hideLoadingFailedWithTitle:errorMsg completed:nil];
        }
    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:@"修改车辆管理失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//完成
- (void)buttonSubmit{
    [self finishEditTrajectory:^(NSString *personId) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
//下一步
- (void)buttonCancel{
    [self finishEditTrajectory:^(NSString *personId) {
        SupervisionExtend *extend=[[SupervisionExtend alloc] init];
        extend.operateType=2;//修改
        extend.PersonId=personId;
        extend.DeviceCode=self.Entity.DeviceCode;
        [self.navigationController pushViewController:extend animated:YES];
        [extend release];
    }];
}
//选照片
- (void)buttonChooseImage{
    EditSupervisionHead *head=[[EditSupervisionHead alloc] init];
    head.Entity=self.Entity;
    head.operateType=2;//新增
    head.delegate=self;
    [self.navigationController pushViewController:head animated:YES];
    [head release];
}
- (void)finishSelectedImage:(UIImage*)image{
    [_imageHead setImage:image];
}
- (void)finishUploadFileName:(NSString*)fileName{
    self.Entity.Photo=fileName;
}
- (void)replacePhonestring:(UITextField*)field{
    NSRegularExpression *regular;
    regular = [[NSRegularExpression alloc] initWithPattern:@"[^0-9]+"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    NSString *str=[field.text Trim];
    field.text = [regular stringByReplacingMatchesInString:str options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [str length]) withTemplate:@""];
}
- (CGRect)fieldToRect:(UITextField*)field{
    id v=[field superview];
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v=[v superview];
    }
    UITableViewCell *cell=(UITableViewCell*)v;
    CGRect r=[_tableView convertRect:cell.frame fromView:_tableView];
    CGRect r1=[cell convertRect:field.frame fromView:cell];
    r.origin.y+=44+r1.origin.y;
    r.origin.x=r1.origin.x;
    
    return r;
}
#pragma mark UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    BOOL boo=YES;
    TKTextFieldCell *cell1=self.cells[8];
    if (cell1.textField==textField) {
        if(strlen([textField.text UTF8String]) >= 12 && range.length != 1)
            boo=NO;
    }
    //TKTextFieldCell *cell2=self.cells[4];
    TKTextFieldCell *cell3=self.cells[6];
    if (cell3.textField==textField) {
        [self replacePhonestring:textField];
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)
            boo=NO;
    }
    return boo;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell=self.cells[indexPath.row];
    if ([cell isKindOfClass:[TKEmptyCell class]]) {
        return 110.0;
    }
    if ([cell isKindOfClass:[TKLabelCell class]]) {
        return 30.0;
    }
    return 44.0;
}
@end
