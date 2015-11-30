
![yun](https://www.yunzhanghu.com/img/logo.png)

# iOSWebViewDemo

## Instruction

1. 直接使用，通过修改WebViewConfig来配置需求

2. 自定义，直接继承HTWebViewController 参考HTInvestWebViewController

#### - WebViewConfig
- @Description `配置系统色调，相关字体的颜色`

 -  进度条颜色		`defaultColor_progressViewColor`

 -	webView背景色 	`defaultColor_webViewBackGroudColor`
 
 -  理财应用标题 		`defaultString_investTitle`

```
//	回调函数返回参数
typedef NS_ENUM(NSInteger, InvestCallBackMethod) {
    //  认证返回
    InvestCallBackMethodAuth         = 0,
    //  绑定银行卡返回
    InvestCallBackMethodBindBankCard = 1,
    //  未知情况
    InvestCallBackMethodUnknown      = -1
};

```

#### - HTWebViewController
- @Description `加载网页， 添加消息头参，显示加载进度，加载视图，加载错误视图`

- @Param url `请求的url链接`

- @param webView `网页视图`


+ NavigationBarShouldPopItemProtocol
+ @Descriptio `是否允许 UINavigationController pop ViewController 的事件处理协议`

#### - HTInvestWebViewController 
- @Description `继承自HTWebViewController ，控制网页返回， 显示关闭按钮`

1
1

****

> **Powered by [Mr.Yang](https://github.com/youran1024)**
> >**Copy right @[云账户](https://www.yunzhanghu.com/)**


[^MrYang]: hi
