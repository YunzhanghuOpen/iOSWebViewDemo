//
//  HTWebViewController.h
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  返回按钮事件处理协议
 *
 *  @Description: 如需控制NavigationController是否允许pop ViewController 只需在Controller里遵守此协议
 */

@protocol NavigationBarShouldPopItemProtocol <NSObject>

/**
 *  是否允许NavigationController pop ViewController
 *
 *  @return @YES 允许 @NO 不允许
 */
- (BOOL)navigationBarShouldPopItem;

@end



@interface HTWebView : UIWebView


@end


@interface HTWebViewController : UIViewController <UIWebViewDelegate>

/**
 *  请求的URL链接
 */
@property (nonatomic, strong)               NSURL *url;
@property (nonatomic, strong, readonly)     HTWebView *webView;


//  在Header里添加要传的参数
- (void)setHeaderObject:(id)anObject forKey:(id)aKey;

@end
