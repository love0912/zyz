//
//  JXBannerPageView.m
//  BaseProject
//
//  Created by guojie on 15/12/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//


#import "JXBannerPageView.h"
#import <UIImageView+WebCache.h>

@implementation JXBannerPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kTitleLabelHeight, CGRectGetWidth(self.bounds), kTitleLabelHeight)];
        _lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kTitleLabelHeight)];
        _lb_title.textAlignment = NSTextAlignmentCenter;
        _lb_title.font = [UIFont systemFontOfSize:14];
        _lb_title.textColor = [UIColor darkGrayColor];
//        _lb_title.backgroundColor = [UIColor blackColor];
        [_toolbar addSubview:_lb_title];
//        [self addSubview:_toolbar];
    }
    return self;
}

+ (instancetype)pageWithFrame:(CGRect)frame {
    return [[JXBannerPageView alloc] initWithFrame:frame];
}

- (void)setPageDomain:(BannerPageDomain *)pageDomain {
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:pageDomain.imgUrl] placeholderImage:nil];
    if ([pageDomain.ImgUrl hasPrefix:@"http"]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:pageDomain.ImgUrl] placeholderImage:[UIImage imageNamed:@"banner_default"]];
    } else {
        _imageView.image = [UIImage imageNamed:pageDomain.ImgUrl];
    }
    _lb_title.text = pageDomain.Title;
}

@end
