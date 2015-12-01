//
//  ViewController.m
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"
#import "HTInvestWebViewController.h"
#import "WebViewConfig.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addInvsetButton];
    
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = returnButtonItem;

    
    
}

- (void)addInvsetButton
{
    UIButton *investButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [investButton setTitle:@"投资" forState:UIControlStateNormal];
    investButton.frame = CGRectMake(0, 0, 100, 100);
    investButton.center = self.view.center;
    [investButton addTarget:self action:@selector(invesetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:investButton];
}

- (void)invesetButtonClicked
{
    HTInvestWebViewController *invest = [[HTInvestWebViewController alloc] init];
    
//    [invest setCallBackBlock:^(InvestCallBackMethod method, ReturnCode code, NSString* returnMsg, id obj) {
//        
//        if (method == InvestCallBackMethodAuth) {
//            self.view.backgroundColor = [UIColor redColor];
//        }else {
//            self.view.backgroundColor = [UIColor blueColor];
//        }
//        
//    }];
    
    //123
    invest.url = [NSURL URLWithString:@"https://test.yunzhanghu.com/#/app/logout"];
    invest.url = [NSURL URLWithString:@"https://test.yunzhanghu.com"];
    
//    invest.url = [NSURL URLWithString:@"http://10.10.1.116:8000"];
//    invest.url = nil;
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"html"];
    NSString *fileStr = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
//    [invest.webView loadHTMLString:fileStr baseURL:[NSURL fileURLWithPath:file]];

    
    [self.navigationController pushViewController:invest animated:YES];
}

- (NSString *)title
{
    return defaultString_investTitle;
}

@end
