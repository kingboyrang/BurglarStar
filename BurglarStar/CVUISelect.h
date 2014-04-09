//
//  CVUISelect.h
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVUIPopoverView.h"
#import "CVUIPopoverText.h"

@protocol CVUISelectDelegate <NSObject>
@optional
-(void)doneChooseItem:(id)sender;
-(void)closeSelect:(id)sender;
@end

@interface CVUISelect : UIView<CVUIPopoverTextDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CVUIPopoverViewDelegate>
@property(nonatomic,retain) NSArray *pickerData;
@property(nonatomic,retain) NSDictionary *itemData;
@property(nonatomic,retain) UIPickerView *picker;
@property(nonatomic,retain) CVUIPopoverView *popoverView;
@property(nonatomic,retain) CVUIPopoverText *popoverText;
@property(nonatomic,readonly) NSString *key;
@property(nonatomic,readonly) NSString *value;
@property(nonatomic,assign) BOOL isChange;//前一次与当前选中项是否发生改变

@property(nonatomic,copy) NSString *bindName;//绑定的key字段
@property(nonatomic,copy) NSString *bindValue;//绑定的value字段
@property(nonatomic,assign) id<CVUISelectDelegate> delegate;

//设置第几项被选中
-(void)findBindName:(NSString*)search;
-(void)findBindValue:(NSString*)search;
-(void)setIndex:(int)i;
//设定数据源
-(void)setDataSourceForArray:(NSArray*)source;
-(void)setDataSourceForArray:(NSArray*)source dataTextName:(NSString*)textName dataValueName:(NSString*)valueName;
-(void)setDataSourceForDictionary:(NSDictionary*)source;
-(void)setDataSourceForDictionary:(NSDictionary*)source dataTextName:(NSString*)textName dataValueName:(NSString*)valueName;
@end
