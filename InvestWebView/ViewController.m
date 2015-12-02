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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = [self titles][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HTInvestWebViewController *invest = [[HTInvestWebViewController alloc] init];
    
    [invest setCallBackBlock:^(InvestCallBackMethod method, ReturnCode code, NSString* returnMsg, id obj) {
        
        /**
         *  错误情况处理
         */
        if (code == ReturnCodeMoreTimeError) {
            //  用户多次输入错误，强制退出
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
            
        }else if (code == ReturnCodeError) {
            //  用户输入错误
            
            return;
        }
        
        /**
         *  流程回调处理
         */
        if (method == InvestCallBackMethodAuth) {
            //  认证真实姓名
            
        }else if (method == InvestCallBackMethodBindBankCard){
            //  绑定银行卡
            
        }else if (method == InvestCallBackMethodInvest) {
            //  投资流程
        
        }else {
            // 处理未知情况
        
        }
        
    }];
    
#warning 请知晓
    /**
     *  实际开发过程中，需要在用户进入云账户前，需要向服务端（非云账户服务端）请求包含签名的URL链接
     */
    
    NSString *url = [self urls][0];
    invest.url = [NSURL URLWithString:url];
    
    [self.navigationController pushViewController:invest animated:YES];
}

- (NSArray *)titles
{
    return @[@"实名认证流程", @"绑卡流程", @"绑卡未实名流程", @"投资未绑卡未实名流程", @"常规流程"];
}

- (NSArray *)urls
{
    return @[@"https://test.yunzhanghu.com",
             @"",
             @"",
             @"",
             @""];
}

- (NSString *)title
{
    return defaultString_investTitle;
}

@end
