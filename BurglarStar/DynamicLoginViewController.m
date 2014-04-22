//
//  DynamicLoginViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/17.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "DynamicLoginViewController.h"
#import "TKLabelCell.h"
#import "TKTextFieldCell.h"
#import "TKDynamicPasswordCell.h"
#import "TKRegisterCheckCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+TPCategory.h"
#import "RegisterCheck.h"
#import "AlertHelper.h"
#import "RegisterViewController.h"
#import "Account.h"
#import "MainViewController.h"
#import "LoginButtons.h"
#import "ASIServiceHTTPRequest.h"
@interface DynamicLoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    LoginButtons *_buttons;
}
@property (nonatomic,assign) CGRect tableRect;
- (void)buttonRegister;
- (void)buttonDynamicPwdClick;
- (void)buttonLoginClick;
- (void)buttonCancel;
- (void)replacePhonestring;
@end

@implementation DynamicLoginViewController
- (void)dealloc{
    [super dealloc];
    [_tableView release];
    [_buttons release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight]+48+44;
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.bounces=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    self.tableRect=r;
    [self.view addSubview:_tableView];
    
    TKLabelCell *cell1=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell1.label.text=@"手机号码";
    
    TKTextFieldCell *cell2=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.textField.placeholder=@"请输入手机号";
    cell2.textField.layer.borderWidth=2.0;
    cell2.textField.layer.cornerRadius=5.0;
    cell2.textField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
    cell2.textField.delegate=self;
    cell2.textField.keyboardType=UIKeyboardTypeNumberPad;
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"密      码";
    
    TKDynamicPasswordCell *cell4=[[[TKDynamicPasswordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell4.textField.placeholder=@"动态密码";
    cell4.textField.layer.borderWidth=2.0;
    cell4.textField.layer.cornerRadius=5.0;
    cell4.textField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
     cell4.textField.delegate=self;
    [cell4.button addTarget:self action:@selector(buttonDynamicPwdClick) forControlEvents:UIControlEventTouchUpInside];
    
    TKRegisterCheckCell *cell5=[[[TKRegisterCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell5.check.registerButton addTarget:self action:@selector(buttonRegister) forControlEvents:UIControlEventTouchUpInside];

    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5, nil];
	
    _buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0,_tableView.frame.origin.y+_tableView.frame.size.height, self.view.bounds.size.width, 44)];
    [_buttons.submit addTarget:self action:@selector(buttonLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttons.cancel addTarget:self action:@selector(buttonCancel) forControlEvents:UIControlEventTouchUpInside];
    _buttons.submit.enabled=NO;
    [self.view addSubview:_buttons];
    
    //点击空白处，聊藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapGestureRecognizer.numberOfTapsRequired =1;
    tapGestureRecognizer.cancelsTouchesInView =NO;
    [_tableView addGestureRecognizer:tapGestureRecognizer];  //只需要点击非文字输入区域就会响应hideKeyBoard
    [tapGestureRecognizer release];
    //监听键盘的显示与隐藏
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
    TKTextFieldCell *cell=self.cells[1];
    [cell.textField resignFirstResponder];
    
    TKDynamicPasswordCell *cell1=self.cells[3];
    [cell1.textField resignFirstResponder];
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
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            _tableView.frame=r;
            _buttons.frame=r1;
           
        }];
        
    }
    else {//隐藏键盘
        CGRect r=_tableView.frame;
        CGRect r1=_buttons.frame;
        r.size.height=self.tableRect.size.height;
        r1.origin.y=self.tableRect.origin.y+r.size.height;
        [UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
             _buttons.frame=r1;
            _tableView.frame=r;
        }];
    }
}
-(void) showLoadingAnimated:(void (^)(AnimateLoadView *errorView))process{
    AnimateLoadView *loadingView = [self loadingView];
    if (process) {
        process(loadingView);
    }
    [self.view addSubview:loadingView];
    CGRect r=loadingView.frame;
    r.origin.y=2;
    [loadingView.activityIndicatorView startAnimating];
    [UIView animateWithDuration:0.5f animations:^{
        loadingView.frame=r;
    }];
}
-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process{
    AnimateErrorView *errorView = [self errorView];
    if (process) {
        process(errorView);
    }
    [self.view addSubview:errorView];
    CGRect r=errorView.frame;
    r.origin.y=2;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
}
-(void) showSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))process{
    AnimateErrorView *errorView = [self successView];
    if (process) {
        process(errorView);
    }
    [self.view addSubview:errorView];
    CGRect r=errorView.frame;
    r.origin.y=2;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dynamicCodeTimeOut{
    _buttons.submit.enabled=NO;
}
- (void)replacePhonestring{
    NSRegularExpression *regular;
    regular = [[NSRegularExpression alloc] initWithPattern:@"[^0-9]+"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    TKTextFieldCell *cell1=self.cells[1];
    NSString *str=[cell1.textField.text Trim];
    cell1.textField.text = [regular stringByReplacingMatchesInString:str options:2  range:NSMakeRange(0, [str length]) withTemplate:@""];
}
//取消
- (void)buttonCancel{
    TKTextFieldCell *cell1=self.cells[1];
    cell1.textField.text=@"";
    [cell1.textField resignFirstResponder];
    
    TKDynamicPasswordCell *cell2=self.cells[3];
    [cell2 resetOrgin];
    TKRegisterCheckCell *cell3=self.cells[4];
    [cell3.check setSelectItemSwitch:1];
    _buttons.submit.enabled=NO;
    
    for (id v in self.view.subviews) {
        if ([v isKindOfClass:[AnimateErrorView class]]||[v isKindOfClass:[AnimateLoadView class]]) {
            [v removeFromSuperview];
        }
    }
}
//登录
- (void)buttonLoginClick{
   TKTextFieldCell *cell1=self.cells[1];
   TKDynamicPasswordCell *cell2=self.cells[3];
    if (!cell1.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码不为空!"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    if (![cell1.textField.text isNumberString]) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码只能为数字!"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    if(strlen([cell1.textField.text UTF8String])<11)
    {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码必须为11位！"];
        [cell1.textField becomeFirstResponder];
        return;
    }
    if (!cell2.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"动态密码不为空!"];
        [cell2.textField becomeFirstResponder];
        return;
    }
    [cell1.textField resignFirstResponder];
    [cell2.textField resignFirstResponder];
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    TKRegisterCheckCell *cell3=self.cells[4];
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:2];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell1.textField.text Trim],@"mobileNum", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell2.textField.text Trim],@"code", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"DynamicLogin";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在登录,请稍后..."];
    ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([dic objectForKey:@"Account"]) {
                boo=YES;
                [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                    //登录
                    [Account loginDynamicWithUserId:[cell1.textField.text Trim] password:[cell2.textField.text Trim] rememberPassword:cell3.check.hasRemember withData:dic];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                   
                }];
                return;
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"输入的帐号或密码错误,请重新输入!" completed:nil];
        }
    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:@"输入的帐号或密码错误,请重新输入!" completed:nil];
    }];
    [request startAsynchronous];
}
//动态密码
- (void)buttonDynamicPwdClick{
    TKDynamicPasswordCell *cell1=self.cells[3];

    TKTextFieldCell *cell=self.cells[1];
    if (!cell.hasValue) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码不为空!"];
        return;
    }
    if (![cell.textField.text isNumberString]) {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码只能为数字!"];
        return;
    }
    if(strlen([cell.textField.text UTF8String])<11)
    {
        [AlertHelper initWithTitle:@"提示" message:@"手机号码必须为11位！"];
        [cell.textField becomeFirstResponder];
        return;
    }
    [cell1.textField resignFirstResponder];
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"GetDynamicCode";
    args.soapParams=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:cell.textField.text,@"mobileNum", nil], nil];
    [self showLoadingAnimatedWithTitle:@"短信发送中,注意查收,请稍后..."];
     ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerXml dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([dic objectForKey:@"code"]) {//表示成功
                boo=YES;
                cell1.dynamicCode=[dic objectForKey:@"code"];
                NSString *time1=[dic objectForKey:@"codeTime"];
                [cell1 startTimerWithTime:time1 process:^(NSTimeInterval afterInterval) {
                    [self performSelector:@selector(hideLoadingViewAnimated:) withObject:nil afterDelay:afterInterval];
                }];
            }
        }
        if (!boo) {
            [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
                [self showMessageWithTitle:@"手机号码错误或未注册!"];
            }];
        }
    }];
    [request setFailedBlock:^{
        [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
            [self showMessageWithTitle:@"手机号码错误或未注册!"];
        }];

    }];
    [request startAsynchronous];
}
//注册
- (void)buttonRegister{
    RegisterViewController *controller=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
#pragma mark UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    BOOL boo=YES;
    TKTextFieldCell *cell=self.cells[1];
    if (cell.textField==textField) {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)
            boo=NO;
    }else{
        if(strlen([textField.text UTF8String]) >= 12 && range.length != 1)
            boo=NO;
    }
    TKTextFieldCell *cell1=self.cells[3];
    if ([[cell.textField.text Trim] length]>0&&[[cell1.textField.text Trim] length]>0) {
        _buttons.submit.enabled=YES;
    }else{
        _buttons.submit.enabled=NO;
    }
    return boo;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    TKTextFieldCell *cell=self.cells[1];
    TKTextFieldCell *cell1=self.cells[3];
    if ([[cell.textField.text Trim] length]>0&&[[cell1.textField.text Trim] length]>0) {
        _buttons.submit.enabled=YES;
    }else{
         _buttons.submit.enabled=NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cells count];
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
    if ([cell isKindOfClass:[TKRegisterCheckCell class]]) {
        return 90.0;
    }
    return 44.0;
}@end
