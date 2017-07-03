//
//  JXBannerView.m
//  BaseProject
//
//  Created by guojie on 15/12/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//
//imageView宽
#define kWidth self.bounds.size.width
//imageView高
#define kHeight self.bounds.size.height
//pageControl的Y
#define kPageControlY kHeight - 35
//pageControl的X
#define kPageControlX 0
//pageControl的宽
#define kPageControlWidth kWidth
//pageControl的高
#define kPageControlHeight 30


#import "JXBannerView.h"

@implementation JXBannerView

- (NSArray *)picArray {
    if (!_picArray) {
        _picArray = [NSArray array];
    }
    return _picArray;
}

//布局当前view
- (void)layoutSubviews {
    [self initMainScrollView];
    [self addImageView];
    [self initPageControl];
    [self initTimer];
}

//初始化方法，将存照片名的数组传进来
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array  {
    self = [super initWithFrame:frame];
    if (self) {
        self.picArray = [NSArray arrayWithArray:array];
        self.timeInterval = 3.0;
    }
    return self;
}

+ (instancetype)bannerWithFrame:(CGRect)frame pages:(NSArray<BannerPageDomain *> *) pages {
    return [[JXBannerView alloc] initWithFrame:frame array:pages];
}

//初始化scrollView
- (void)initMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentOffset = CGPointMake(kWidth, 0);
    _mainScrollView.pagingEnabled = YES;
    [self addSubview:_mainScrollView];
}

#pragma mark -- ImageView
- (void)addImageView {
    if (self.picArray != nil) {
        _mainScrollView.contentSize = CGSizeMake( kWidth * (self.picArray.count + 1), 0);
        JXBannerPageView *bannerPageView;
        //创建imageView 比数组中的图片多一张
        for (int i = 0; i < self.picArray.count + 1; i++) {
            
            if (i == self.picArray.count) {
                //将最后一张图添加到第一张图的位置 整体为 3 1 2 3
                bannerPageView = [JXBannerPageView pageWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//                if ([self verifyURL:self.picArray[i-1]]) {
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i-1]]];
//                } else {
//                    imageView.image = [UIImage imageNamed:self.picArray[i - 1]];
//                }
                [bannerPageView setPageDomain:_picArray[i - 1]];
                
            } else {
                bannerPageView = [JXBannerPageView pageWithFrame:CGRectMake(kWidth * (i + 1), 0, kWidth, kHeight)];
//                if ([self verifyURL:self.picArray[i]]) {
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]]];
//                } else {
//                    imageView.image = [UIImage imageNamed:self.picArray[i]];
//                }
                [bannerPageView setPageDomain:_picArray[i]];
            }
            [bannerPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_page_tap:)]];
            
            [self.mainScrollView addSubview:bannerPageView];
        }
    }
}

- (void)jx_page_tap:(UIGestureRecognizer *)recognizer {
    if (self.jx_clickAtIndex != nil) {
        self.jx_clickAtIndex(_pageControl.currentPage);
    }
}


#pragma mark -- pageControl
//初始化pageControl
- (void)initPageControl {
    CGFloat x = (kWidth / 2 - (self.picArray.count * 17.5) / 2);
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, kHeight - kTitleLabelHeight ,self.picArray.count * 17.5, 7)];
    _pageControl.numberOfPages = self.picArray.count;
    //当前pageControl的位置
    NSInteger currentIndex = self.mainScrollView.contentOffset.x / kWidth - 1;
    if (currentIndex >= 0) {
        _pageControl.currentPage = currentIndex;
    } else {
        _pageControl.currentPage = self.picArray.count;
    }
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor =  [UIColor whiteColor];
//    _pageControl.pageIndicatorTintColor = self.pageControlIndicatorTintColor;
//    _pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    [self addSubview:_pageControl];
    
}

#pragma mark -- 定时器
//初始化定时器
- (void)initTimer {
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

//定时器回调方法
- (void)autoPlay {
    //获取当前偏移量
    CGFloat x = self.mainScrollView.contentOffset.x;
    CGFloat width = kWidth;
    //偏移量加上scrollview宽度超过scrollview的contentSize
    if (x + width >= self.mainScrollView.contentSize.width) {
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [self.mainScrollView setContentOffset:CGPointMake(x + width, 0) animated:YES];
    }
    //获取当前pagecontrol的位置
    NSInteger index = x / width ;
    if (index < 0) {
        _pageControl.currentPage = self.picArray.count - 1;
    } else {
        _pageControl.currentPage = index;
        if (index == _picArray.count) {
            [self autoPlay];
        }
    }
}

//开始滑动的时候定时器关闭
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

//滑动结束后定时器开始
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self initTimer];
}


#pragma mark -- scrollView代理
//实现手动循环滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    if (x > self.picArray.count * width) {
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (x < 0) {
        [_mainScrollView setContentOffset:CGPointMake(self.picArray.count * width, 0) animated:NO];
    }
}

//滑动结束后计算pageControl的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前偏移量
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = kWidth;
    NSInteger index = x / width - 1;
    if (index < 0) {
        _pageControl.currentPage = self.picArray.count - 1;
    } else {
        _pageControl.currentPage = index;
    }
    
}

@end

//- (instancetype)initWithFrame:(CGRect)frame pages:(NSArray<BannerPageDomain *> *) pages {
//    self = [super initWithFrame:frame];
//    if (self) {
//        UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
//        [self addSubview:tmpView];
//        _width = self.bounds.size.width;
//        _height = self.bounds.size.height;
//        _arr_pageDomain = [NSArray arrayWithArray:pages];
//        
//        [self layoutScrollView];
//        [self setMaxImageCount:_arr_pageDomain.count];
//    }
//    return self;
//}
//
//+ (instancetype)bannerWithFrame:(CGRect)frame pages:(NSArray<BannerPageDomain *> *) pages {
//    return [[JXBannerView alloc] initWithFrame:frame pages:pages];
//}
//
///**
// *  初始化scrollview
// */
//- (void)layoutScrollView {
//    
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//    _scrollView.backgroundColor = [UIColor clearColor];
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.delegate = self;
//    CGSize contentSize;
//    if (_arr_pageDomain.count > 1) {
//        contentSize = CGSizeMake(_width * 3,0);
//    } else {
//        contentSize = CGSizeMake(_width * _arr_pageDomain.count,0);
//    }
//    _scrollView.contentSize = contentSize;
//    _autoScrollDelay = 2.0f;
//    _currentIndex = 0;
//    [self addSubview:_scrollView];
//}
//
//- (void)setMaxImageCount:(NSInteger)maxImageCount {
//    _maxImageCount = maxImageCount;
//    
//    [self layoutPageView];
//    [self layoutPageControl];
//    
//    if (maxImageCount > 1) {
//        [self setUpTimer];
//    }
//    if (_maxImageCount > 2) {
//        [self changeImageLeft:maxImageCount - 1 center:0 right:1];
//    } else if (_maxImageCount == 2) {
//        [self changeImageLeft:1 center:0 right:1];
//    }
//    
////    if (maxImageCount == 1) {
////        [self changeImageLeft:0 center:0 right:0];
////    } else if (maxImageCount == 2) {
////        [self changeImageLeft:0 center:1 right:0];
////    } else {
////        [self changeImageLeft:maxImageCount - 1 center:0 right:1];
////    }
//}
//
//- (void)layoutPageView {
////    if (_maxImageCount == 1) {
////        _jx_page_left = [JXBannerPageView pageWithFrame:CGRectMake(0, 0, _width, _height)];
////    } else if (_maxImageCount == 2) {
////        _jx_page_left = [JXBannerPageView pageWithFrame:CGRectMake(0, 0, _width, _height)];
////        _jx_page_center = [JXBannerPageView pageWithFrame:CGRectMake(_width, 0, _width, _height)];
////    } else {
////        _jx_page_left = [JXBannerPageView pageWithFrame:CGRectMake(0, 0, _width, _height)];
////        _jx_page_center = [JXBannerPageView pageWithFrame:CGRectMake(_width, 0, _width, _height)];
////        _jx_page_right = [JXBannerPageView pageWithFrame:CGRectMake(_width * 2, 0, _width, _height)];
////        
////    }
//    if (_maxImageCount < 2) {
//        JXBannerPageView *tmpPageView = [JXBannerPageView pageWithFrame:CGRectMake(0 , 0, _width, _height)];
//        [tmpPageView setPageDomain:_arr_pageDomain[0]];
//        [tmpPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_page_tap:)]];
//        [_scrollView addSubview:tmpPageView];
////        for (int i = 0; i < _maxImageCount; i ++) {
////            JXBannerPageView *tmpPageView = [JXBannerPageView pageWithFrame:CGRectMake(i * _width, 0, _width, _height)];
////            tmpPageView.tag = 2000 + i;
////            [tmpPageView setPageDomain:_arr_pageDomain[i]];
////            [tmpPageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_page_tap:)]];
////            [_scrollView addSubview:tmpPageView];
////        }
//    } else {
//        _jx_page_left = [JXBannerPageView pageWithFrame:CGRectMake(0, 0, _width, _height)];
//        _jx_page_center = [JXBannerPageView pageWithFrame:CGRectMake(_width, 0, _width, _height)];
//        _jx_page_right = [JXBannerPageView pageWithFrame:CGRectMake(_width * 2, 0, _width, _height)];
//        _jx_page_left.backgroundColor = [UIColor orangeColor];
//        _jx_page_center.backgroundColor = [UIColor grayColor];
//        _jx_page_right.backgroundColor = [UIColor redColor];
//        
//        [_jx_page_center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jx_page_tap:)]];
//        
//        if (_jx_page_left != nil)
//            [_scrollView addSubview:_jx_page_left];
//        if (_jx_page_center != nil)
//            [_scrollView addSubview:_jx_page_center];
//        if (_jx_page_right != nil)
//            [_scrollView addSubview:_jx_page_right];
//    }
//    
//    
//}
//
//
//- (void)layoutPageControl {
//    CGFloat x = (_width / 2 - (_maxImageCount * 17.5) / 2);
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, _height - kTitleLabelHeight * 2 ,_maxImageCount * 17.5, 7)];
//    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    _pageControl.currentPageIndicatorTintColor =  [UIColor whiteColor];
//    _pageControl.numberOfPages = _maxImageCount;
//    _pageControl.currentPage = 0;
//    [self addSubview:_pageControl];
//}
//
//
//- (void)jx_page_tap:(UIGestureRecognizer *)recognizer {
//    if (self.jx_clickAtIndex != nil) {
//        self.jx_clickAtIndex(_currentIndex);
//    }
//}
//
//- (void)setUpTimer {
//    if (_autoScrollDelay < 0.5) return;
//    
//    _timer = [NSTimer timerWithTimeInterval:_autoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//}
//
//- (void)removeTimer {
//    if (_timer == nil) return;
//    [_timer invalidate];
//    _timer = nil;
//}
//
//- (void)scorll {
////    NSLog(@"%f", _scrollView.contentOffset.x);
////    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _width, 0) animated:YES];
//    
//    //获取当前偏移量
//    CGFloat x = _scrollView.contentOffset.x;
//    CGFloat width = _width;
//    //偏移量加上scrollview宽度超过scrollview的contentSize
//    if (x + width >= _scrollView.contentSize.width) {
//        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    } else {
//        [_scrollView setContentOffset:CGPointMake(x + width, 0) animated:YES];
//    }
//    //获取当前pagecontrol的位置
//    NSInteger index = x / width ;
//    if (index < 0) {
//        _pageControl.currentPage = _maxImageCount - 1;
//    } else {
//        _pageControl.currentPage = index;
//    }
//}
//
//- (void)changeImageLeft:(NSInteger)leftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
//    
//    _jx_page_left.pageDomain = _arr_pageDomain[leftIndex];
//    _jx_page_center.pageDomain = _arr_pageDomain[centerIndex];
//    _jx_page_right.pageDomain = _arr_pageDomain[rightIndex];
//    [_scrollView setContentOffset:CGPointMake(_width, 0)];
//}
//
//#pragma mark scrollViewDelegate
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (_maxImageCount > 1) {
//        [self setUpTimer];
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (_maxImageCount > 1) {
//        [self removeTimer];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (_maxImageCount > 1) {
//        [self changeImageWithOffset:scrollView.contentOffset.x];
//    }
//}
//
//
//- (void)changeImageWithOffset:(CGFloat)offsetX {
//    
//    if (offsetX >= _width * 2) {
//        _currentIndex++;
//        
//        if (_maxImageCount > 2) {
//            if (_currentIndex == _maxImageCount-1) {
//                
//                [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
//                
//            }else if (_currentIndex == _maxImageCount) {
//                
//                _currentIndex = 0;
//                [self changeImageLeft:_maxImageCount-1 center:0 right:1];
//                
//            }else {
//                [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
//            }
//        } else {
//            if (_currentIndex == _maxImageCount-1) {
//                [self changeImageLeft:0 center:1 right:0];
//            } else if (_currentIndex == _maxImageCount) {
//                _currentIndex = 0;
//                [self changeImageLeft:1 center:0 right:1];
//            } else {
//                [self changeImageLeft:0 center:1 right:0];
//            }
//            
//        }
//        _pageControl.currentPage = _currentIndex;
//    }
//    
//    if (offsetX <= 0) {
//        _currentIndex--;
//        if (_maxImageCount > 2) {
//            if (_currentIndex == 0) {
//                
//                [self changeImageLeft:_maxImageCount-1 center:0 right:1];
//                
//            } else if (_currentIndex == -1) {
//                
//                _currentIndex = _maxImageCount-1;
//                [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
//                
//            } else {
//                [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
//            }
//        } else {
//            if (_currentIndex == 0) {
//                [self changeImageLeft:1 center:0 right:1];
//            } else if (_currentIndex == -1) {
//                _currentIndex = _maxImageCount -1;
//                [self changeImageLeft:0 center:1 right:0];
//            } else {
//                [self changeImageLeft:0 center:1 right:0];
//            }
//        }
//        _pageControl.currentPage = _currentIndex;
//    }
//    
//}



//@end
