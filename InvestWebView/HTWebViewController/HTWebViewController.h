//
//  HTWebViewController.h
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

//  进度条颜色
static uint defaultColor_progressViewColor = 0xf76425;
//  webView背景色 
static uint defaultColor_webViewBackGroudColor = 0xeeeeee;


@class HTWebProgressView;
@protocol HTWebViewDelegate;

@interface HTWebView :UIWebView

@property (nonatomic, assign) id <HTWebViewDelegate> progressDelegate;

@end


@interface HTWebViewController : UIViewController

@property (nonatomic, strong)   NSURL *url;
@property (nonatomic, strong, readonly) HTWebView *webView;


- (void)setHeaderObject:(id)anObject forKey:(id)aKey;

@end
