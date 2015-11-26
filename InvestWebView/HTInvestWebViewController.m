//
//  HTInvestWebViewController.m
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTInvestWebViewController.h"
#import "WebViewConfig.h"
#import "HTWebViewController.h"
#import "WebViewProxy.h"



@interface HTInvestWebViewController () <UIWebViewDelegate>
{
    /*--------监控对方的设置状态------------*/
    
    BOOL _isInteractivePopGestureRecognizerEnable;
    
    /*-------- End-----------------------*/
}

@end


@implementation HTInvestWebViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //  禁用手势
    UIGestureRecognizer *interactivePopGesture = self.navigationController.interactivePopGestureRecognizer;
    
    _isInteractivePopGestureRecognizerEnable =  interactivePopGesture.isEnabled;
    
    if (interactivePopGesture) {
        interactivePopGesture.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //  恢复滑动返回手势
    if (_isInteractivePopGestureRecognizerEnable) {
        self.navigationController.interactivePopGestureRecognizer.enabled = _isInteractivePopGestureRecognizerEnable;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addCloseBarbutton];
    
    [self setHookString:ht_urlHookStr];
}

- (void)addCloseBarbutton
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:ht_hexColor(defaultColor_closeButtonColor) forState:UIControlStateNormal];
    [closeButton setTitleColor:ht_hexColor(defaultColor_closeButtonHighLightColor) forState:UIControlStateHighlighted];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.rightBarButtonItem = closeItem;
}

- (void)closeButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)navigationBarShouldPopItem
{
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UserActionCallBack

- (void)userActionCallBackWithRequest:(NSURLRequest *)request
{
    [self handleUserHttpRequest:request];
}

#pragma mark - 
#pragma mark webView Delegate

/*
// 暂且搁置
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self handleUserRequest:request];
}
*/
- (void)handleUserHttpRequest:(NSURLRequest *)request
{
    NSString *urlString = request.URL.description;
    NSArray *array = [urlString componentsSeparatedByString:@"?"];
    if (array.count > 0) {
        NSString *userAction = array[0];
        NSArray *hostArray = [userAction componentsSeparatedByString:@"/"];
        userAction = [hostArray lastObject];
        
        NSDictionary *param = [self urlParamterFromRequestURL:urlString];
        
        InvestCallBackMethod method = InvestCallBackMethodUnknown;
        if ([userAction isEqualToString:ht_investAction]) {
            method = InvestCallBackMethodInvest;
        }else if ([userAction isEqualToString:ht_authAction]) {
            method = InvestCallBackMethodAuth;
        }else if ([userAction isEqualToString:ht_bindBankCardAction]) {
            method = InvestCallBackMethodBindBankCard;
        }
        
        if (_callBackBlock) {
            _callBackBlock(method, param);
        }
    }
}

/*
//  暂且搁置
- (BOOL)handleUserRequest:(NSURLRequest *)request
{
    NSString *requestURL = [request.URL absoluteString];
    NSString *scheme = request.URL.scheme;
    NSString *host = request.URL.host;
    
    if ([scheme rangeOfString:@"yzh"].length > 0) {
        NSDictionary *param = [self urlParamterFromRequestURL:requestURL];
        
        InvestCallBackMethod method = InvestCallBackMethodUnknown;
        
        if ([host isEqualToString:ht_authAction]) {
            method = InvestCallBackMethodAuth;
            
        }else if ([host isEqualToString:ht_bindBankCardAction]) {
            method = InvestCallBackMethodBindBankCard;
        }
        
        if (_callBackBlock) {
            _callBackBlock(method, param);
        }
        
        return NO;
    }

    return YES;
}
 
*/

- (NSDictionary *)urlParamterFromRequestURL:(NSString *)urlStr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *array = [urlStr componentsSeparatedByString:@"?"];
    
    if (array.count > 1) {
        NSString *urlParamStr = array[1];
        array = [urlParamStr componentsSeparatedByString:@"&"];
        
        for (NSString *paramStr in array) {
            NSArray *array = [paramStr componentsSeparatedByString:@"="];
            
            NSAssert(array.count == 2, @"解析param 出错~");
            
            if (array.count == 2) {
                [dict setValue:array[1] forKey:array[0]];
            }
        }
        
        return dict;
    }
    
    return nil;
}

- (NSString *)title
{
    return defaultString_investTitle;
}

@end
