//
//  JXWebViewController.h
//  FreeJob
//
//  Created by guojie on 15/12/12.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//
//使用方法
/*
 */



#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class JXWebViewController;


@interface UINavigationController(JXWebViewController)

- (JXWebViewController *)rootWebViewController;

@end


@protocol JXWebViewDelegate <NSObject>
@optional
- (void)jx_webView:(JXWebViewController *)webView didStartLoadingURL:(NSURL *)URL;
- (void)jx_webView:(JXWebViewController *)webView didFinishLoadingURL:(NSURL *)URL;
- (void)jx_webView:(JXWebViewController *)webView didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
@end



@interface JXWebViewController : UIViewController<WKNavigationDelegate, UIWebViewDelegate>

#pragma mark - Public Properties

@property (nonatomic, weak) id <JXWebViewDelegate> delegate;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *backItem;

//下拉背后显示提示
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) NSString *backTipString;

// The web views
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration NS_AVAILABLE_IOS(8_0);

#pragma mark - Static Initializers

+ (JXWebViewController *)jx_webView;
+ (JXWebViewController *)jx_webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration NS_AVAILABLE_IOS(8_0);

+ (UINavigationController *)navigationControllerWithWebView;
+ (UINavigationController *)navigationControllerWithWebViewWithConfiguration:(WKWebViewConfiguration *)configuration NS_AVAILABLE_IOS(8_0);


#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL;

- (void)loadURLString:(NSString *)URLString;



@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL actionButtonHidden;
@property (nonatomic, assign) BOOL showsURLInNavigationBar;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

@property (nonatomic, strong) UIBarButtonItem *backButton, *forwardButton, *refreshButton, *stopButton, *actionButton, *fixedSeparator, *flexibleSeparator;

@end
