//
//  JXBannerView.h
//  BaseProject
//
//  Created by guojie on 15/12/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXBannerPageView.h"
#import "BannerPageDomain.h"


typedef void(^PageClickAtIndex)(NSInteger index);

//@interface JXBannerView : UIView<UIScrollViewDelegate>
//{
//    NSInteger _autoScrollDelay;
//    NSInteger _currentIndex;
//    NSInteger _maxImageCount;
//    CGFloat _width;
//    CGFloat _height;
//    NSTimer *_timer;
//}
//
//@property (nonatomic, strong) JXBannerPageView *jx_page_left, *jx_page_center, *jx_page_right;
//
//@property (nonatomic, strong) UIScrollView *scrollView;
//
//@property (nonatomic, strong) UIPageControl *pageControl;
//
//@property (nonatomic, strong) NSArray<BannerPageDomain *> *arr_pageDomain;
//
//@property (nonatomic, strong) PageClickAtIndex jx_clickAtIndex;
//
//+ (instancetype)bannerWithFrame:(CGRect)frame pages:(NSArray<BannerPageDomain *> *) pages;

@interface JXBannerView : UIView<UIScrollViewDelegate>

//切换图片时间间隔 默认3s 可选
@property (nonatomic, assign) CGFloat timeInterval;

//初始化ScrollView 并把需要的图片存在数组里传进来（网络的图片讲url存到数组即可）
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

+ (instancetype)bannerWithFrame:(CGRect)frame pages:(NSArray<BannerPageDomain *> *) pages;

//指示器颜色 默认灰色 可选
@property (nonatomic, strong) UIColor *pageControlIndicatorTintColor;
//当前页书颜色 默认白色 可选
@property (nonatomic, strong) UIColor *currentPageColor;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PageClickAtIndex jx_clickAtIndex;

@end
