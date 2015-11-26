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

//  认证成功后返回
static NSString *authAction         =   @"returnAuth";
static NSString *bindBankCardAction =   @"returnBankcard";

@interface HTInvestWebViewController () <UIWebViewDelegate>

@end


@implementation HTInvestWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self addCloseBarbutton];
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

#pragma mark - 
#pragma mark webView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestURL = [request.URL absoluteString];
    NSString *scheme = request.URL.scheme;
    
    if ([scheme rangeOfString:@"YZH"].length > 0) {
        NSDictionary *param = [self urlParamterFromRequestURL:requestURL];
        
        InvestCallBackMethod method = InvestCallBackMethodUnknown;
        
        if ([requestURL rangeOfString:authAction].length > 0) {
            method = InvestCallBackMethodAuth;
            
        }else if ([requestURL rangeOfString:bindBankCardAction].length > 0) {
            method = InvestCallBackMethodBindBankCard;
        }
        
        if (_callBackBlock) {
            _callBackBlock(method, param);
        }
        
        return NO;
    }
    
    return YES;
}

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
