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


@protocol HTURLHookProtocol <NSObject>

@required
- (void)ht_urlHookWithRequest:(NSURLRequest *)request;
- (BOOL)ht_isImplementCallBackBlock;

@end

#pragma mark -
#pragma mark HTURLProtocol

static NSString *hookString = nil;
static id <HTURLHookProtocol> hookDelegate = nil;


@interface HTURLProtocol : NSURLProtocol

@property (nonatomic, copy)void(^hookBlock)(void);

+ (void)hookWithString:(NSString *)string andDelegate:(id<HTURLHookProtocol>)delegate;

+ (void)unHook;

@end

@implementation HTURLProtocol

+ (void)urlHook
{
    [NSURLProtocol registerClass:[HTURLProtocol class]];
}

+ (void)unHook
{
    hookString = nil;
    hookDelegate = nil;
    
    [NSURLProtocol unregisterClass:[HTURLProtocol class]];
}

+ (void)hookWithString:(NSString *)string andDelegate:(id<HTURLHookProtocol>)delegate
{
    [self urlHook];
    
    hookDelegate = delegate;
    hookString = string;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *host = request.URL.description;
    if ([host rangeOfString:hookString].location != NSNotFound) {
        if (DEBUG) {
            NSLog(@"%@", request.URL);
        }
        
        return YES;
    }
    
    return NO;
}

- (void)startLoading
{
    if (hookDelegate) {
        [hookDelegate ht_urlHookWithRequest:self.request];
    }
    
    if (hookDelegate) {
        if ([hookDelegate ht_isImplementCallBackBlock]) {
            [self sendResponse];
        }
    }
}

- (void)sendResponse
{
    NSData *data = [@"app" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                              statusCode:200
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:nil];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    
}

@end


#pragma mark - HTInvestWebViewController

@interface HTInvestWebViewController () <UIWebViewDelegate, HTURLHookProtocol>
{
    /*--------监控对方的设置状态------------*/
    
    BOOL _isInteractivePopGestureRecognizerEnable;
    
    /*-------- End-----------------------*/
}

@end


@implementation HTInvestWebViewController

- (void)dealloc
{
    [HTURLProtocol unHook];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HTURLProtocol hookWithString:ht_urlHookStr andDelegate:self];
}

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

}

- (void)ht_urlHookWithRequest:(NSURLRequest *)request
{
    [self handleUserHttpRequest:request];
}

- (BOOL)ht_isImplementCallBackBlock
{
    return _callBackBlock ? YES : NO;
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

#pragma mark -  解析URL
- (void)handleUserHttpRequest:(NSURLRequest *)request
{
    NSString *urlString = request.URL.description;
    NSArray *array = [urlString componentsSeparatedByString:@"?"];
    if (array.count > 0) {
        NSString *userAction = array[0];
        NSArray *hostArray = [userAction componentsSeparatedByString:@"/"];
        userAction = [hostArray lastObject];
        
        InvestCallBackMethod method = InvestCallBackMethodUnknown;
        if ([userAction isEqualToString:ht_investAction]) {
            method = InvestCallBackMethodInvest;
        }else if ([userAction isEqualToString:ht_authAction]) {
            method = InvestCallBackMethodAuth;
        }else if ([userAction isEqualToString:ht_bindBankCardAction]) {
            method = InvestCallBackMethodBindBankCard;
        }
        
        NSDictionary *param = [self urlParamterFromRequestURL:urlString];
        
        NSInteger returnCode = [[param objectForKey:@"code"] integerValue];
        
        ReturnCode code;
        if (returnCode == 0) {
            code = ReturnCodeSuccess;
        }else if (returnCode == 1) {
            code = ReturnCodeError;
        }else {
            code = ReturnCodeMoreTimeError;
        }
        
        NSString *returnMsg = [param objectForKey:@"msg"];
        NSString *data = [param objectForKey:@"data"];
        data = [self decodeString:data];
        /*
        NSAssert(data != nil, @"参数Data为空");
         */
        
        id obj = nil;
        
        if (data != nil) {
            obj = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        }

        if (_callBackBlock) {
            _callBackBlock(method, code, returnMsg, obj);
        }
    }
}

/*
 // 暂且搁置
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
 {
    return [self handleUserRequest:request];
 }
 */

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

#pragma mark - 
#pragma mark URLDecoding

-(NSString *)decodeString:(NSString*)encodedString{
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
