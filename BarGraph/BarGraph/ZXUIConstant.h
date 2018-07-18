//
//  ZXUIConstant.h
//  Comi
//
//  Created by luo luo on 30/11/2017.
//  Copyright © 2017 Bran. All rights reserved.
//

#ifndef ZXUIConstant_h
#define ZXUIConstant_h

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height

/*---------------------------  适配屏幕☟  ---------------------------*/
#define ORIGINAL_WIDTH 320.0      //当前原型图基准iOS设备的逻辑分辨率的宽
#define ORIGINAL_HEIGHT 568.0     //当前原型图基准iOS设备的逻辑分辨率的高

///水平方向适配系数
#define FIT_WIDTH (([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)/ORIGINAL_WIDTH)
///竖直方向适配系数----iphone4下乘以此系数会变小
#define FIT_HEIGHT (([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)/ORIGINAL_HEIGHT)
//*************字体**************
#define FitFontSize(S) [UIFont systemFontOfSize:(S)*FIT_WIDTH]

//*************颜色*****************
// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]
#define kCommonLabelColor  [UIColor colorWithRed:0.553 green:0.545 blue:0.545 alpha:1.000]

//最新
// 设置颜色
#define UIColorRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

/// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 主题背景色 - 淡白
#define kZXBackgroundColor UIColorRGB(238,241,241)

//导航条 - 深蓝
//#define ZXNavationBgColor  RGBACOLOR(94/255.0, 190/255.0, 240/225, 1.0)

//常用背景色 - 淡蓝
#define kZXCommonBlueColor UIColorHex(0x5EBEF0)
//大图片的默认图片
#define kZXBigPictureDefault @"ZXMessageDefault"
//默认无数据图片
#define kZXEmptyPictureDefault @"ZXdatasIsNullDefault"
//默认头像 mine_headImage 我的设置里面的默认头像
#define  kZHeadePictureDefault @"friend_default_head"
//to_study_icon 在线巡课无数据 failed_to_load_icon 数据请求失败的图片 live_icon 无直播数据

//*********************ui标识
#define kZXBaseButtonTag 100

#endif /* ZXUIConstant_h */
