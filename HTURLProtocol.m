//
//  HTURLProtocol.m
//  InvestWebView
//
//  Created by Mr.Yang on 15/11/26.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTURLProtocol.h"

@implementation HTURLProtocol

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"%@", request.URL);
    return YES;
}

- (void)startLoading
{
    
    
}

- (void)stopLoading
{
    
    
}

@end
