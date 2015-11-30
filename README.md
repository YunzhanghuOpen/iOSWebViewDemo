
![yun](https://www.yunzhanghu.com/img/logo.png)

# iOSWebViewDemo

## 使用说明
1. 将SDK引入工程
2. Push `HTInvestWebViewController`之前，设置`HTInvestWebViewController`的各项参数
	
	2.1 设置要打开的url
	
	2.2 设置回调Block
	
3. 配置WebViewConfig里边的相关参数,统一页面样式

#### - WebViewConfig
- @Description `配置系统色调，相关字体的颜色`

 -  进度条颜色		`defaultColor_progressViewColor`

 -	webView背景色 	`defaultColor_webViewBackGroudColor`
 
 -  理财应用标题 		`defaultString_investTitle`

```
//	回调方法枚举
typedef NS_ENUM(NSInteger, InvestCallBackMethod) {
    //  认证返回
    InvestCallBackMethodAuth         = 0,
    //  绑定银行卡返回
    InvestCallBackMethodBindBankCard = 1,
    //  未知情况
    InvestCallBackMethodUnknown      = -1
};

//  返回的状态码枚举
typedef NS_ENUM(NSInteger, ReturnCode) {
    //  用户成功
    ReturnCodeSuccess = 0,
    //  填写错误
    ReturnCodeError = 1,
    //  多次填写错误
    ReturnCodeMoreTimeError
};

```

#### - HTWebViewController
- @Description `加载网页， 添加消息头参，显示加载进度，加载视图，加载错误视图`

- @Param url `请求的url链接`

- @param webView `网页视图`

#### - HTInvestWebViewController 
- @Description `继承自HTWebViewController ，控制网页返回， 显示关闭按钮`


> Powered by [Mr.Yang](https://github.com/youran1024) Copy right @**[云账户](https://www.yunzhanghu.com/)**


[^MrYang]: hi
