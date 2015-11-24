
//
//  WebViewConfig.h
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//


/**
 *  配置系统色调 ，相关字体颜色， 文字描述
 */

#ifndef WebViewConfig_h
#define WebViewConfig_h

/**
 *  进度条颜色
 */
static uint defaultColor_progressViewColor = 0xf76425;

/**
 *  webView背景色
 */
static uint defaultColor_webViewBackGroudColor = 0xeeeeee;

/**
 *  关闭按钮颜色
 */
static uint defaultColor_closeButtonColor = 0xfa640e;

/**
 *  关闭按钮颜色
 */
static uint defaultColor_closeButtonHighLightColor = 0xea5414;

/**
 *  理财标题
 */
static NSString *defaultString_investTitle = @"云账户";


#pragma mark - 
#pragma mark ExtensionMethod

static inline UIColor * ht_hexColor(uint color)
{
    float r = (color&0xFF0000) >> 16;
    float g = (color&0xFF00) >> 8;
    float b = (color&0xFF);
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

#endif /* WebViewConfig_h */
