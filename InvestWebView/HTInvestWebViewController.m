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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*
    NSString *investTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.title = investTitle;
    */
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"URL:%@", request.URL);
    
    /*
    NSString *requestURL = [request.URL absoluteString];
    NSString *relativePath = [request.URL relativePath];
    */
    
    return YES;
}

- (NSString *)title
{
    return defaultString_investTitle;
}

@end
