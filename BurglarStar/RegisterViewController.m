//
//  RegisterViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "RegisterViewController.h"
#import "TKLabelCell.h"
#import "TKTextFieldCell.h"
#import "NSString+TPCategory.h"
#import "UIButton+TPCategory.h"
#import "LoginButtons.h"
#import <QuartzCore/QuartzCore.h>
#import "AlertHelper.h"
#import "Account.h"
#import "RegisterSuccessViewController.h"
#import "ASIServiceHTTPRequest.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    UILabel *_showInfo;
    UILabel *_phoneShowInfo;
    
    UIImageView *_accountImageView;
    UIImageView *_phoneImageView;
    
    BOOL isExistsNumber;//帐号是否已存在
    BOOL isExistsPhone;//手机号码是否已存在
    
    LoginButtons *_toolBar;
    
    //UIScrollView *_scrollView;
}
@property (nonatomic,assign) CGRect tableRect;
- (void)updateShowInfo:(NSString*)user;
- (void)buttonSubmit;
- (void)buttonCancel;
- (void)checkPhone:(NSString*)phone;
- (void)replacePhonestring;
- (CGRect)fieldToRect:(UITextField*)field;
@end

@implementation RegisterViewController
- (void)dealloc{
    //[UITableView release];
    [super dealloc];
    [_tableView release];
    [_showInfo release];
    [_phoneShowInfo release];
    [_accountImageView release];
    [_phoneImageView release];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册";
    isExistsPhone=NO;
    isExistsNumber=NO;
    
    
   CGRect r=self.view.bounds;
    r.size.height-=[self topHeight]+44;
    self.tableRect=r;
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
     _tableView.backgroundColor=[UIColor clearColor];
    _tableView.bounces=NO;
    [self.view addSubview:_tableView];
    
    _toolBar=[[LoginButtons alloc] initWithFrame:CGRectMake(0,_tableView.frame.size.height+_tableView.frame.origin.y, self.view.bounds.size.width, 44)];
    [_toolBar.submit addTarget:self action:@selector(buttonSubmit) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.cancel addTarget:self action:@selector(buttonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toolBar];
    
    
    
    TKLabelCell *cell1=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell1.label.text=@"帐号";
    
    _showInfo=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, self.view.bounds.size.width-50, 20)];
    _showInfo.textColor=[UIColor redColor];
    _showInfo.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _showInfo.backgroundColor=[UIColor clearColor];
    [cell1.contentView addSubview:_showInfo];
    
    _accountImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 0.5, 20, 29)];
    [_accountImageView setImage:[UIImage imageNamed:@"ico19.png"]];
    [cell1.contentView addSubview:_accountImageView];
    _accountImageView.hidden=YES;
    
    
    
    TKTextFieldCell *cell2=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.textField.placeholder=@"请输入帐号";
    cell2.textField.delegate=self;
    cell2.textField.keyboardType=UIKeyboardTypeAlphabet;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textUserChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [cell2.textField addTarget:self action:@selector(textUserChange:) forControlEvents:UIControlEventValueChanged];
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"昵称";
    
    TKTextFieldCell *cell4=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell4.textField.placeholder=@"请输入昵称";
    cell4.textField.delegate=self;
    //cell4.textField.keyboardType=UIKeyboardTypeAlphabet;
    
    TKLabelCell *cell5=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell5.label.text=@"手机号码";
    
    _phoneShowInfo=[[UILabel alloc] initWithFrame:CGRectMake(80, 5, self.view.bounds.size.width-80, 20)];
    _phoneShowInfo.textColor=[UIColor redColor];
    _phoneShowInfo.font=[UIFont fontWithName:DeviceFontName size:DeviceFontSize];
    _phoneShowInfo.backgroundColor=[UIColor clearColor];
    [cell5.contentView addSubview:_phoneShowInfo];
    
    _phoneImageView=[[UIImageView alloc] initWithFrame:CGRectMake(80, 0.5, 20, 29)];
    [_phoneImageView setImage:[UIImage imageNamed:@"ico19.png"]];
    [cell5.contentView addSubview:_phoneImageView];
    _phoneImageView.hidden=YES;
    
    
    TKTextFieldCell *cell6=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell6.textField.placeholder=@"请输入手机号码";
    cell6.textField.delegate=self;
    cell6.textField.keyboardType=UIKeyboardTypeAlphabet;
    [cell6.textField addTarget:self action:@selector(textUserChange:) forControlEvents:UIControlEventValueChanged];
    
    TKLabelCell *cell7=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell7.label.text=@"密码";
    
    TKTextFieldCell *cell8=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell8.textField.placeholder=@"请输入密码";
    cell8.textField.secureTextEntry=YES;
    cell8.textField.delegate=self;
    
    TKLabelCell *cell9=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell9.label.text=@"确认密码";
    
    TKTextFieldCell *cell10=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell10.textField.placeholder=@"请输入确认密码";
    cell10.textField.secureTextEntry=YES;
    cell10.textField.delegate=self;
    

    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6,cell7,cell8,cell9,cell10, nil];
    
    
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
        
        
        
        r1.origin.y=self.view.bounds.size.height-kbFrame.size.height-r1.size.height;
        r.size.height=r1.origin.y;
       
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
//注册
- (void)buttonSubmit{
    
    TKTextFieldCell *cell1=self.cells[1];
    if (!cell1.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"帐号不为空!"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    if(isExistsNumber)
    {
        [AlertHelper initWithTitle:@"提示" message:@"帐号已被注册,请重新输入!"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    TKTextFieldCell *cell2=self.cells[3];
    if (!cell2.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"昵称不为空!"];
        [cell2.textField becomeFirstResponder];
        return;
    }
    TKTextFieldCell *cell3=self.cells[5];
    if (!cell3.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码不为空!"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    if (![cell3.textField.text isNumberString]) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码只能为数字!"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    if(strlen([cell3.textField.text UTF8String])<11)
    {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码必须为11位！"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    if(isExistsPhone)
    {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码已被注册,请重新输入!"];
        [cell3.textField becomeFirstResponder];
        return;
    }
    TKTextFieldCell *cell4=self.cells[7];
    if (!cell4.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"密码不为空!"];
        [cell4.textField becomeFirstResponder];
        return;
    }
    if(strlen([cell4.textField.text UTF8String])<6)
    {
        [AlertHelper initWithTitle:@"提示" message:@"密码不能少于6位大于12位！"];
        [cell4.textField becomeFirstResponder];
        return;
    }
    TKTextFieldCell *cell5=self.cells[9];
    if (!cell5.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"确认密码不为空!"];
        [cell5.textField becomeFirstResponder];
        return;
    }
    if (![cell4.textField.text isEqualToString:cell5.textField.text]) {
        [AlertHelper initWithTitle:@"提示" message:@"密码与确认密码不一致!"];
        [cell5.textField becomeFirstResponder];
        return;
    }
    [self textFieldShouldReturn:cell1.textField];
    [self textFieldShouldReturn:cell2.textField];
    [self textFieldShouldReturn:cell3.textField];
    [self textFieldShouldReturn:cell4.textField];
    [self textFieldShouldReturn:cell5.textField];
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:2];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell1.textField.text Trim],@"Account", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell2.textField.text Trim],@"LOCALNAME", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"NOTES", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell3.textField.text Trim],@"MobilePhone", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell4.textField.text Trim],@"Pwd", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"UserRegister";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"注册中,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        NSString *msg=@"注册失败!";
        NSString *status=@"";
        BOOL boo=NO;
        //NSLog(@"result=%@",result.request.responseString);
        if(request.ServiceResult.success){
            XmlNode *node=[request.ServiceResult methodNode];
            status=node.Value;
            if (![status isEqualToString:@"Fail"]&&![status isEqualToString:@"Exists"]) {
                [self hideLoadingViewAnimated:nil];
                boo=YES;
                Account *acc=[[[Account alloc] init] autorelease];
                acc.WorkNo=node.Value;
                acc.UserId=[cell1.textField.text Trim];
                acc.Password=[cell4.textField.text Trim];
                acc.Name=[cell2.textField.text Trim];
                acc.Phone=[cell3.textField.text Trim];
                
                RegisterSuccessViewController *registerSuccess=[[RegisterSuccessViewController alloc] init];
                registerSuccess.Entity=acc;
                [self.navigationController pushViewController:registerSuccess animated:YES];
                [registerSuccess release];
            }
        }
        if(!boo)
        {
            if ([status isEqualToString:@"Exists"]) {
                msg=@"帐号已存在!";
            }
            [self hideLoadingFailedWithTitle:msg completed:nil];
        }
    }];
    [request setFailedBlock:^{
        [self hideLoadingFailedWithTitle:@"注册失败!" completed:nil];
    }];
    [request startAsynchronous];
}
//取消 
- (void)buttonCancel{
    [self.navigationController popViewControllerAnimated:YES];
}
//检测帐号
- (void)textUserChange:(NSNotification*)notifice{
    UITextField *field=[notifice object];
    TKTextFieldCell *cell=self.cells[1];
    if (cell.textField==field) {
        //检测帐号
        NSString *acc=[field.text Trim];
        if([acc length]>0)
        {
            [self updateShowInfo:acc];
        }else{
            _showInfo.text=@"";
            _accountImageView.hidden=YES;
        }
    }
    TKTextFieldCell *cell1=self.cells[5];
    if (cell1.textField==field) {//手机号码检测
        //检测手机号码
        NSString *phone=[field.text Trim];
        if ([phone length]==11) {
            [self checkPhone:cell1.textField.text];
        }else{
            _phoneShowInfo.text=@"";
            _phoneImageView.hidden=YES;
        }
    }
}
//判断帐号是否存在
- (void)updateShowInfo:(NSString*)user{
   
    //TKTextFieldCell *cell=self.cells[1];
    if ([user length]==0) {
        _showInfo.text=@"";
        _accountImageView.hidden=YES;
        return;
    }
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"IsExitsAccounts";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:user,@"account", nil], nil];
    
     ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            if ([node.Value isEqualToString:@"false"]) {
                isExistsNumber=NO;
                _showInfo.text=@"";
                _accountImageView.hidden=NO;
            }else{
                isExistsNumber=YES;
                _accountImageView.hidden=YES;
                _showInfo.text=@"帐号已被注册!";
                _showInfo.textColor=[UIColor redColor];
            }
        }else{
            isExistsNumber=NO;
            _accountImageView.hidden=YES;
            _showInfo.text=@"帐号检测异常!";
            _showInfo.textColor=[UIColor redColor];
        }
    }];
    [request setFailedBlock:^{
        isExistsNumber=NO;
        _accountImageView.hidden=YES;
        _showInfo.text=@"帐号检测异常!";
        _showInfo.textColor=[UIColor redColor];
    }];
    [request startAsynchronous];
}
- (void)replacePhonestring{
    NSRegularExpression *regular;
    regular = [[NSRegularExpression alloc] initWithPattern:@"[^0-9]+"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    TKTextFieldCell *cell1=self.cells[5];
    NSString *str=[cell1.textField.text Trim];
    cell1.textField.text = [regular stringByReplacingMatchesInString:str options:NSRegularExpressionCaseInsensitive  range:NSMakeRange(0, [str length]) withTemplate:@""];
}
- (void)checkPhone:(NSString*)phone{
   // TKTextFieldCell *cell=self.cells[5];
    if ([phone length]==0||[phone length]<11) {
        _phoneShowInfo.text=@"";
        _phoneImageView.hidden=YES;
        return;
    }
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"IsExitsMobileNo";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:phone,@"mobileNo", nil], nil];
      ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            if ([node.Value isEqualToString:@"false"]) {
                _phoneShowInfo.text=@"";
                _phoneImageView.hidden=NO;
                isExistsPhone=NO;
            }else{
                isExistsPhone=YES;
                _phoneImageView.hidden=YES;
                _phoneShowInfo.text=@"已注册!";
                _phoneShowInfo.textColor=[UIColor redColor];
            }
        }else{
            isExistsPhone=NO;
            _phoneImageView.hidden=YES;
            _phoneShowInfo.text=@"手机号码检测异常!";
            _phoneShowInfo.textColor=[UIColor redColor];
        }
    }];
    [request setFailedBlock:^{
        isExistsPhone=NO;
        _phoneImageView.hidden=YES;
        _phoneShowInfo.text=@"手机号码检测异常!";
        _phoneShowInfo.textColor=[UIColor redColor];
    }];
    [request startAsynchronous];
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
    TKTextFieldCell *cell=self.cells[1];//帐号
     TKTextFieldCell *cell4=self.cells[3];//昵称
    TKTextFieldCell *cell3=self.cells[5];
    if (cell.textField==textField||cell3.textField==textField) {
        if (cell3.textField==textField) {//手机号码
            [self replacePhonestring];
           
            if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)
                boo=NO;
        }else{//帐号
            if(strlen([textField.text UTF8String]) >= 20 && range.length != 1)
                boo=NO;
            }
    }
    if (cell4.textField==textField) {
        if([textField.text length] >= 20 && range.length != 1)
            boo=NO;
    }
    TKTextFieldCell *cell1=self.cells[7];//密码
    TKTextFieldCell *cell2=self.cells[9];//确认密码
    
    if (cell1.textField==textField||cell2.textField==textField) {
        if(strlen([textField.text UTF8String]) >= 12 && range.length != 1)
            boo=NO;
    }
    return boo;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IOSVersion<6.1) {
        id v=[textField superview];
        while (![v isKindOfClass:[UITableViewCell class]]) {
            v=[v superview];
        }
        UITableViewCell *cell=(UITableViewCell*)v;
        NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([cell isKindOfClass:[TKLabelCell class]]) {
        return 30.0;
    }
    return 44.0;
}
@end
