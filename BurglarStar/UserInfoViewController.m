//
//  UserInfoViewController.m
//  LocationService
//
//  Created by aJia on 2013/12/23.
//  Copyright (c) 2013年 lz. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginButtons.h"
#import "TKLabelCell.h"
#import "TKTextFieldCell.h"
#import "Account.h"
#import "AlertHelper.h"
#import "ASIServiceHTTPRequest.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    LoginButtons *_buttons;
}
@property (nonatomic,assign) CGRect tableRect;
-(void)buttonCancel;
-(void)buttonSubmit;
- (void)replacePhonestring;
@end

@implementation UserInfoViewController
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
    self.title=@"个人信息";
    CGRect r=self.view.bounds;
    r.size.height-=[self topHeight]+44;
    _tableView=[[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.bounces=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    self.tableRect=r;
    [self.view addSubview:_tableView];
    
    Account *acc=[Account unarchiverAccount];
    
    TKLabelCell *cell1=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell1.label.text=@"帐号";
    
    TKTextFieldCell *cell2=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell2.textField.layer.borderWidth=2.0;
    cell2.textField.layer.cornerRadius=5.0;
    cell2.textField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
    cell2.textField.backgroundColor=[UIColor grayColor];
    cell2.textField.enabled=NO;
    cell2.textField.text=acc.UserId;
    
    TKLabelCell *cell3=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell3.label.text=@"手机号码";
    
    TKTextFieldCell *cell4=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell4.textField.layer.borderWidth=2.0;
    cell4.textField.layer.cornerRadius=5.0;
    cell4.textField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
    cell4.textField.text=acc.Phone;
    cell4.textField.keyboardType=UIKeyboardTypeNumberPad;
    cell4.textField.delegate=self;
    cell4.textField.placeholder=@"请输入手机号码";
    
    
    TKLabelCell *cell5=[[[TKLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell5.label.text=@"昵称";
    
    TKTextFieldCell *cell6=[[[TKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell6.textField.layer.borderWidth=2.0;
    cell6.textField.layer.cornerRadius=5.0;
    cell6.textField.layer.borderColor=[UIColor colorFromHexRGB:@"6ab3c3"].CGColor;
    cell6.textField.text=acc.Name;
    cell6.textField.delegate=self;
    cell6.textField.placeholder=@"请输入昵称";
    //cell6.textField.keyboardType=UIKeyboardTypeAlphabet;
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];
    
    _buttons=[[LoginButtons alloc] initWithFrame:CGRectMake(0,_tableView.frame.origin.y+_tableView.frame.size.height, self.view.bounds.size.width, 44)];
    [_buttons.submit addTarget:self action:@selector(buttonSubmit) forControlEvents:UIControlEventTouchUpInside];
    [_buttons.cancel addTarget:self action:@selector(buttonCancel) forControlEvents:UIControlEventTouchUpInside];
    _buttons.submit.enabled=NO;
    [_buttons.submit setTitle:@"完成" forState:UIControlStateNormal];
    _buttons.submit.enabled=YES;
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
    TKTextFieldCell *cell=self.cells[3];
    [cell.textField resignFirstResponder];
    
    TKTextFieldCell *cell1=self.cells[5];
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
            _tableView.frame=r;
            _buttons.frame=r1;
        }];
    }
}
- (void)replacePhonestring{
    NSRegularExpression *regular;
    regular = [[NSRegularExpression alloc] initWithPattern:@"[^0-9]+"
                                                   options:NSRegularExpressionCaseInsensitive
                                                     error:nil];
    TKTextFieldCell *cell1=self.cells[3];
    NSString *str=[cell1.textField.text Trim];
    cell1.textField.text = [regular stringByReplacingMatchesInString:str options:2  range:NSMakeRange(0, [str length]) withTemplate:@""];
}
//取消
- (void)buttonCancel{
    Account *acc=[Account unarchiverAccount];
    TKTextFieldCell *cell1=self.cells[3];
    TKTextFieldCell *cell2=self.cells[5];
    cell1.textField.text=acc.Phone;
    cell2.textField.text=acc.Name;
    [self textFieldShouldReturn:cell1.textField];
    [self textFieldShouldReturn:cell2.textField];
}
//提交
- (void)buttonSubmit{
    TKTextFieldCell *cell1=self.cells[3];
    TKTextFieldCell *cell2=self.cells[5];

    
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
        [AlertHelper initWithTitle:@"提示" message:@"昵称不为空!"];
        [cell2.textField becomeFirstResponder];
        return;
    }
    [self textFieldShouldReturn:cell1.textField];
    [self textFieldShouldReturn:cell2.textField];
    if (!self.hasNetWork) {
        [self showErrorNetWorkNotice:nil];
        return;
    }
    
     Account *acc=[Account unarchiverAccount];
    
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:2];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:acc.WorkNo,@"WorkNo", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell2.textField.text Trim],@"LOCALNAME", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:[cell1.textField.text Trim],@"Phone", nil]];
    
    ASIServiceArgs *args=[[[ASIServiceArgs alloc] init] autorelease];
    args.methodName=@"UpdateUserInfo";
    args.soapParams=params;
    [self showLoadingAnimatedWithTitle:@"正在更新个人信息,请稍后..."];
     ASIServiceHTTPRequest *request=[ASIServiceHTTPRequest requestWithArgs:args];
    [request setCompletionBlock:^{
        BOOL boo=NO;
        if (request.ServiceResult.success) {
            XmlNode *node=[request.ServiceResult methodNode];
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            if ([[dic objectForKey:@"Result"] isEqualToString:@"1"]) {
                boo=YES;
                [self hideLoadingSuccessWithTitle:@"个人信息更新成功!" completed:^(AnimateErrorView *successView) {
                    [Account updateInfo:[cell1.textField.text Trim] nick:[cell2.textField.text Trim]];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return;
            }
        }
        if (!boo) {
            [self hideLoadingFailedWithTitle:@"个人信息更新失败!" completed:nil];
        }
    }];
    [request setFailedBlock:^{
         [self hideLoadingFailedWithTitle:@"个人信息更新失败!" completed:nil];
    }];
    [request startAsynchronous];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    BOOL boo=YES;
    TKTextFieldCell *cell1=self.cells[3];
    if (cell1.textField==textField) {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)
            boo=NO;
    }
    TKTextFieldCell *cell2=self.cells[5];
    if (cell2.textField==textField) {
        if([textField.text length] >= 20 && range.length != 1)
            boo=NO;
    }
    if ([[cell1.textField.text Trim] length]==0||[[cell2.textField.text Trim] length]==0) {
        _buttons.submit.enabled=NO;
    }else{
        _buttons.submit.enabled=YES;
    }
    return boo;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    TKTextFieldCell *cell1=self.cells[3];
    TKTextFieldCell *cell2=self.cells[5];
    if ([[cell1.textField.text Trim] length]==0||[[cell2.textField.text Trim] length]==0) {
        _buttons.submit.enabled=NO;
    }else{
        _buttons.submit.enabled=YES;
    }
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
