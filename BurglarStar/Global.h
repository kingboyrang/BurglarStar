//
//  Global.h
//  Eland
//
//  Created by aJia on 13/9/27.
//  Copyright (c) 2013年 rang. All rights reserved.
//

//获取设备的物理大小
#define IOSVersion [[UIDevice currentDevice].systemVersion floatValue]
#define DeviceRect [UIScreen mainScreen].bounds
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define StatusBarHeight 20 //状态栏高度
#define TabHeight 59 //工具栏高度
#define DeviceRealHeight DeviceHeight-20
#define DeviceRealRect CGRectMake(0, 0, DeviceWidth, DeviceRealHeight)
//路径设置
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TempPath NSTemporaryDirectory()
//设备
#define DeviceIsPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad
//通知post name
#define kPushNotificeName @"kPushNotificeNameInfo"
//webservice
#define DataWebserviceURL @"http://ibdcloud.com:8083/User_APP.asmx"
#define DataNameSpace @"http://tempuri.org/"

//帮助
#define BurglarStarHelpURL @"http://www.iBDCloud.com/TheftStar/Wap/Help.aspx"
//意见反馈
#define BurglarStarFeedBackURL @"http://www.iBDCloud.com/TheftStar/Wap/FeedbackList.aspx"

#define DataWebservice1 @"http://www.ibdcloud.com:8083/Pit_APP.asmx"
#define DataNameSpace1 @"http://tempuri.org/"
//sos报警接口
#define DataSOSWebservice @"http://ibdcloud.com:8083/TheftStar_App.asmx"
#define DataSOSNameSpace @"http://tempuri.org/"

//字体设置
#define DeviceFontName @"Helvetica-Bold"
#define DeviceFontColorName @"1e313f"
#define DeviceFontSize 16.0


//取得一周天气=101280601
//#define WeatherWeekURL @"http://m.weather.com.cn/data/%@.html"
#define WeatherWeekURL @"http://mobile.weather.com.cn/data/forecast/%@.html"
//取得今天天气
#define WeatherDayURL @"http://www.weather.com.cn/data/sk/%@.html"
#define WeatherCityDayURL @"http://www.weather.com.cn/data/cityinfo/%@.html"




