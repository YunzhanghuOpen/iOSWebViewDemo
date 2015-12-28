
//
//  HTWebLoadingView.m
//  InvestWebView
//
//  Created by Mr.Yang on 15/12/28.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTWebLoadingView.h"
#import "WebViewConfig.h"

@interface HTWebLoadingView ()

@property (nonatomic, strong)   IBOutlet UIImageView *backImageView;
@property (nonatomic, strong)   IBOutlet UIImageView *animateImageView;
@property (nonatomic, strong)   IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)   IBOutlet UILabel *subTitleLabel;

@end

@implementation HTWebLoadingView

- (void)awakeFromNib
{
    self.backgroundColor = ht_hexColor(0xefefef);
    
    self.titleLabel.textColor = ht_hexColor(0x9e9e9e);
    self.subTitleLabel.textColor = ht_hexColor(0x9e9e9e);
    
    UIImage *image1 = [UIImage imageNamed:@"Sources.bundle/whale1"];
    UIImage *image2 = [UIImage imageNamed:@"Sources.bundle/whale2"];
    UIImage *image3 = [UIImage imageNamed:@"Sources.bundle/whale3"];
    UIImage *image4 = [UIImage imageNamed:@"Sources.bundle/whale4"];
    
    self.animateImageView.animationImages = @[image1,image2, image3, image4];
    self.animateImageView.animationDuration = 1.2f;
    [self.animateImageView startAnimating];
    
    self.backImageView.image = image1;
    
}

@end
