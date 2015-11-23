//
//  ViewController.m
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/23.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"
#import "HTInvestWebViewController.h"

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
    
    invest.url = [NSURL URLWithString:@"https://test.yunzhanghu.com/#/app/logout"];
    
    [self.navigationController pushViewController:invest animated:YES];
}

- (NSString *)title
{
    return @"投资";
}

@end
