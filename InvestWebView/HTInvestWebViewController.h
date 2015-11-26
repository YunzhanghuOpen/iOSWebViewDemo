//
//  HTInvestWebViewController.h
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTWebViewController.h"
#import "WebViewConfig.h"


@interface HTInvestWebViewController : HTWebViewController

@property (nonatomic, copy) InvestCallBackBlock callBackBlock;

@end
