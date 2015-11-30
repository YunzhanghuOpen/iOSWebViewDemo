//
//  HTInvestWebViewController.h
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTWebViewController.h"
#import "WebViewConfig.h"

/**
 *  继承自HTWebViewController ，控制网页返回， 显示关闭按钮, 分析客户端回调函数.
 *  接入客户端直接使用此控制器，打开相关业务链接即可
 */
@interface HTInvestWebViewController : HTWebViewController

@property (nonatomic, copy) InvestCallBackBlock callBackBlock;

@end
