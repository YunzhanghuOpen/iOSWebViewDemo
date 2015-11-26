//
//  HTWebViewController.m
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTWebViewController.h"
#import "WebViewConfig.h"


#pragma mark -
#pragma mark ExtensionMethod

@interface UIViewController () <NavigationBarShouldPopItemProtocol>

@end

@implementation UINavigationController (PopItem)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    BOOL shouldPop = YES;
    
    UIViewController *topVc = [self topViewController];
    if (topVc && [topVc respondsToSelector:@selector(navigationBarShouldPopItem)]){
        shouldPop = [topVc navigationBarShouldPopItem];
    }
    
    if (shouldPop) {
        [self popViewControllerAnimated:YES];
    }
    
    return shouldPop;
}

@end


#pragma mark -
#pragma mark HTWebProgressView

@interface HTWebProgressView : UIView

@property (nonatomic, assign)   CGFloat progressValue;
@property (nonatomic, strong)   UIColor *tintColor;

@end


@implementation HTWebProgressView


- (id)init
{
    self = [super init];
    
    if (self) {
        [self initVariables];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initVariables];
    }
    
    return self;
}

- (void)initVariables
{
    _tintColor = [UIColor greenColor];
    _progressValue = 0.0f;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    if (progressValue > 1.0f) {
        progressValue = 1.0f;
    }
    
    if (progressValue < .0f) {
        progressValue = .0f;
    }
    
    CGRect rect = self.frame;
    static CGFloat width;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = rect.size.width;
    });

    if (progressValue > _progressValue) {
        _progressValue = progressValue;
        rect.size.width = width * _progressValue;
        self.frame = rect;
    }
}

@end


#pragma mark - 
#pragma mark HTWebViewDelegate

@protocol HTWebViewDelegate <NSObject>

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent;

@end


#pragma mark -
#pragma mark HTWebView

@interface UIWebView ()

-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;

@end




@interface HTWebView ()

@property (nonatomic, assign) id <HTWebViewDelegate> progressDelegate;

@end

@implementation HTWebView
{
    CGFloat _totalCount;
    NSInteger _receiveCount;
}

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    
    return @(_totalCount++);
}

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    _receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:_receiveCount/_totalCount ];
    }

    if (_receiveCount == _totalCount) {
        _receiveCount = 0.0;
        _totalCount = 0.0;
    }
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    
    _receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:(CGFloat)_receiveCount/(CGFloat)_totalCount ];
    }
    
    if (_receiveCount == _totalCount) {
        _receiveCount = 0.0;
        _totalCount = 0.0;
    }
}

@end

@protocol HTURLHookProtocol <NSObject>

- (void)ht_urlHookWithRequest:(NSURLRequest *)request;

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
    NSLog(@"%@", request.URL);
    
    NSString *host = request.URL.description;
    if ([host rangeOfString:hookString].length > 0) {
        
        if (hookDelegate && [hookDelegate respondsToSelector:@selector(ht_urlHookWithRequest:)]) {
            [hookDelegate ht_urlHookWithRequest:request];
        }
        
        return YES;
    }
    
    return NO;
}

- (void)startLoading
{
    
}

- (void)stopLoading
{
    
}

@end

#pragma mark -
#pragma mark HTWebViewController

@interface HTWebViewController () <HTWebViewDelegate, HTURLHookProtocol>
{
    BOOL _loadError;
}

@property (nonatomic, assign)   BOOL loadData;
@property (nonatomic, strong)   HTWebProgressView *progressView;
@property (nonatomic, strong)   NSMutableDictionary *headerDic;

@end


@implementation HTWebViewController

- (void)dealloc
{
    [HTURLProtocol unHook];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  NavigationBar 处理操作
     */
    
}

//  Hook 到urlRequest
- (void)setHookString:(NSString *)hookString
{
    if (![_hookString isEqualToString:hookString]) {
        _hookString = hookString;
        [HTURLProtocol hookWithString:_hookString andDelegate:self];
    }

}

#pragma mark - ht_URLHook

- (void)ht_urlHookWithRequest:(NSURLRequest *)request
{
    [self userActionCallBackWithRequest:request];
}

//  TODO: rewrite in subClass
- (void)userActionCallBackWithRequest:(NSURLRequest *)request
{

}

- (void)setUrl:(NSURL *)url
{
    if (![_url.absoluteString isEqualToString:url.absoluteString]) {
        _url = url;
        [self refresh:url];
    }
}

- (void)loadListRequest
{
    [self refresh:_url];
}

- (void)refresh:(NSURL *)url
{
    if (!url.absoluteString || url.absoluteString.length == 0) {
        return;
    }
    
    if (!_progressView) {
        
        CGFloat topHight = self.navigationController.navigationBar.hidden ? 0.0f : 64.0f;
        
        _progressView = [[HTWebProgressView alloc] initWithFrame:CGRectMake(0, topHight, CGRectGetWidth(self.view.frame), 3)];

        _progressView.backgroundColor = ht_hexColor(defaultColor_progressViewColor);
    }
    
    _progressView.progressValue = .06f;
    
    if (!_webView) {
        _webView = [[HTWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = ht_hexColor(defaultColor_webViewBackGroudColor);
        _webView.progressDelegate = self;
        
        [self.view addSubview:_webView];
        [_webView addSubview:_progressView];
    }
    
    if (_loadData) {
        [_webView loadData:[NSData dataWithContentsOfURL:_url] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:_url];
        _webView.scalesPageToFit = NO;
        
    }else {
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
        urlRequest.allHTTPHeaderFields = [self addRequestHeader:urlRequest.allHTTPHeaderFields];
        [_webView loadRequest:urlRequest];
    }
}

- (void)setHeaderObject:(id)anObject forKey:(id)aKey
{
    [self.headerDic setValue:anObject forKey:aKey];
}

- (NSDictionary *)addRequestHeader:(NSDictionary *)headerDic
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
    
    if (!_headerDic) {
        _headerDic = [NSMutableDictionary dictionary];
    }
    
    for (NSString *key in [_headerDic allKeys]) {
        id obj = [_headerDic objectForKey:key];
        
        [mutDic setValue:obj forKey:key];
    }
    
    return mutDic;
}

#pragma mark - WebViewDelegate

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent
{
    if (persent < .06f || _loadError) {
        return;
    }
    
    _progressView.progressValue = persent;
    
    if (persent >= 1.0f) {
        _progressView.hidden = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadError = YES;
    _progressView.hidden = YES;
    
//    [self showLoadingViewWithState:LoadingStateNetworkError];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self removeLoadingView];
}


@end
