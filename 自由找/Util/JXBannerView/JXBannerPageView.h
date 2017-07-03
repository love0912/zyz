//
//  JXBannerPageView.h
//  BaseProject
//
//  Created by guojie on 15/12/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerPageDomain.h"

#define kTitleLabelHeight 20

#define kBottomPadding 5

@interface JXBannerPageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *lb_title;

@property (nonatomic, strong) UIToolbar *toolbar;

+ (instancetype)pageWithFrame:(CGRect)frame;

- (void)setPageDomain:(BannerPageDomain *)pageDomain;

@end
