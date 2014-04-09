//
//  CVUISelect.m
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CVUISelect.h"

@interface CVUISelect()
-(void)findByName:(NSString*)search searchName:(NSString*)name;
-(void)unBindSource;
@end


@implementation CVUISelect
@synthesize popoverView,picker;
@synthesize itemData,pickerData;
@synthesize popoverText;
@synthesize key,value;
@synthesize delegate;
@synthesize isChange;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加文本框
        self.popoverText=[[CVUIPopoverText alloc] initWithFrame:frame];
        self.popoverText.delegate=self;
        [self addSubview:self.popoverText];
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,320, 216)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        self.picker.showsSelectionIndicator = YES;
        self.picker.backgroundColor=[UIColor whiteColor];
        //初始化弹出框
        self.popoverView=[[CVUIPopoverView alloc] initWithFrame:CGRectZero];
        self.popoverView.delegate=self;
        [self.popoverView addChildView:self.picker];
        
    }
    return self;
}
#pragma mark -
#pragma mark 属性重写
-(void)setPickerData:(NSArray *)data{
    if (pickerData!=data) {
        [pickerData release];
        pickerData=[data retain];
    }
    if (!self.bindName) {
        self.bindName=@"key";
    }
    if (!self.bindValue) {
        self.bindName=@"value";
    }
    self.picker.userInteractionEnabled=YES;//以防万一
    [self unBindSource];
}
-(NSString*)key{
    if ([self.itemData count]>0&&[self.bindName length]>0&&[self.itemData objectForKey:self.bindName]!=nil) {
        return [self.itemData objectForKey:self.bindName];
    }
    return @"";
}
-(NSString*)value{
    if ([self.itemData count]>0&&[self.bindValue length]>0&&[self.itemData objectForKey:self.bindValue]!=nil) {
        return [self.itemData objectForKey:self.bindValue];
    }
    return @"";
}
- (void) layoutSubviews{
    [super layoutSubviews];
    CGRect frame=self.frame;
    frame.origin.x=0;
    frame.origin.y=0;
    self.popoverText.frame=frame;
}
#pragma mark -
#pragma mark CVUIPopoverTextDelegate Methods
-(void)doneShowPopoverView:(id)sender senderView:(id)view{
    if (self.popoverView) {
        [self.popoverView show:self];
    }
    
}
#pragma mark -
#pragma mark CVUIPopoverViewDelegate Methods
-(void)showPopoverView{
    //[self setCalendarValue];//赋值
}
-(void)donePopoverView{
    NSInteger row=[self.picker selectedRowInComponent:0];
    NSDictionary *dic=[self.pickerData objectAtIndex:row];
    if (!self.itemData){
      self.isChange=YES;
    }else{
       if ([self.pickerData indexOfObject:self.itemData]==[self.pickerData indexOfObject:dic]) {
         self.isChange=NO;
       }else{
         self.isChange=YES;
       }
    }
    self.itemData=dic;
    self.popoverText.popoverTextField.text=[self key];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(doneChooseItem:)]) {
        [self.delegate doneChooseItem:self];
    }
}
-(void)clearPopoverView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(closeSelect:)]) {
        [self.delegate closeSelect:self];
    }else{
      self.itemData=nil;
      self.popoverText.popoverTextField.text=@"";
    }
    
}
#pragma mark -
#pragma mark UIPickerView DataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pv numberOfRowsInComponent:(NSInteger)component
{
   
    if ([self.pickerData count]==0) {
        self.picker.userInteractionEnabled=NO;
    }
	return [self.pickerData count];
}
#pragma mark Picker Delegate Methods
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dic=[self.pickerData objectAtIndex:row];
    if ([self.bindName length]==0) {
        return @"";
    }
    return [dic objectForKey:self.bindName];
}
#pragma mark -
#pragma mark 私有方法
-(void)findByName:(NSString*)search searchName:(NSString*)name{
    if ([search length]>0&&[name length]>0) {
        NSString *str=[NSString stringWithFormat:@"SELF.%@",name];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%@ LIKE[cd] %@",str,search];
        NSArray *arr=[self.pickerData filteredArrayUsingPredicate:predicate];
        if ([arr count]>0) {
            [self setIndex:[self.pickerData indexOfObject:[arr objectAtIndex:0]]];
        }else{
            predicate=[NSPredicate predicateWithFormat:@"%@ CONTAINS %@",search,str];
            arr=[self.pickerData filteredArrayUsingPredicate:predicate];
            if ([arr count]>0) {
                [self setIndex:[self.pickerData indexOfObject:[arr objectAtIndex:0]]];
            }
        }
    }
}
-(void)unBindSource{
    [self.picker reloadComponent:0];
    self.popoverText.popoverTextField.text=@"";
    self.itemData=nil;
    if ([self.pickerData count]>0) {
        [self.picker selectRow:0 inComponent:0 animated:YES];
    }
}
#pragma mark -
#pragma mark 公有方法
-(void)findBindName:(NSString*)search{
    [self findByName:search searchName:self.bindName];
}
-(void)findBindValue:(NSString*)search{
    [self findByName:search searchName:self.bindValue];
}
//设置选中项
-(void)setIndex:(int)i{
    if (i>=0&&i<[self.pickerData count]) {
        [self.picker selectRow:i inComponent:0 animated:NO];
        self.itemData=[self.pickerData objectAtIndex:i];
        self.popoverText.popoverTextField.text=[self key];
    }
}
//如:soure=["1","2","3"];
-(void)setDataSourceForArray:(NSArray*)source{
    NSMutableArray *arr=[NSMutableArray array];
    for (id k in source) {
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:k,@"key", nil]];
    }
    [self setDataSourceForArray:arr dataTextName:@"key" dataValueName:@"key"];
}
//如:soure with dictionary;
-(void)setDataSourceForArray:(NSArray*)source dataTextName:(NSString*)textName dataValueName:(NSString*)valueName{
    
    self.bindName=textName;
    self.bindValue=valueName;
    self.pickerData=source;
}
-(void)setDataSourceForDictionary:(NSDictionary*)source{
    [self setDataSourceForDictionary:source dataTextName:@"key" dataValueName:@"value"];
}
-(void)setDataSourceForDictionary:(NSDictionary*)source dataTextName:(NSString*)textName dataValueName:(NSString*)valueName
{
    self.bindName=textName;
    self.bindValue=valueName;
    NSMutableArray *arr=[NSMutableArray array];
    for (id k in source.allKeys) {
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:k,self.bindName,[source objectForKey:k], self.bindValue,nil]];
    }
    self.pickerData=arr;
}
-(void)dealloc{
    [popoverView release];
    [itemData release];
    [pickerData release];
    [popoverText release];
    [key release];
    [value release];
    [super dealloc];
}
@end
