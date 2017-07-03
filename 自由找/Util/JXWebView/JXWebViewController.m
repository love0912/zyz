//
//  JXWebViewController.m
//  FreeJob
//
//  Created by guojie on 15/12/12.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import "JXWebViewController.h"

static void *JXContext = &JXContext;

NSString *defaultTipString = @"由重庆自由找网络科技提供";

@interface JXWebViewController()
{
    CGRect _boundsRect;
}

@property (nonatomic, assign) BOOL previousNavigationControllerToolbarHidden, previousNavigationControllerNavigationBarHidden;

@property (nonatomic, strong) NSTimer *fakeProgressTimer;

@property (nonatomic, assign) BOOL uiWebViewIsLoading;

@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;

@end

@implementation JXWebViewController

#pragma mark - init

+ (JXWebViewController *)jx_webView {
    return [JXWebViewController jx_webBrowserWithConfiguration:nil];
}

+ (JXWebViewController *)jx_webBrowserWithConfiguration:(WKWebViewConfiguration *)configuration {
    JXWebViewController *jxWebViewController = [[JXWebViewController alloc] initWithConfiguration:configuration];
    return jxWebViewController;
}

+ (UINavigationController *)navigationControllerWithWebView {
    JXWebViewController *jx_webView = [[JXWebViewController alloc] initWithConfiguration:nil];
    return [JXWebViewController navigationControllerWithJXWebView:jx_webView];
}

+ (UINavigationController *)navigationControllerWithWebViewWithConfiguration:(WKWebViewConfiguration *)configuration {
    JXWebViewController *jx_webView = [[JXWebViewController alloc] initWithConfiguration:configuration];
    return [JXWebViewController navigationControllerWithJXWebView:jx_webView];
}

+ (UINavigationController *)navigationControllerWithJXWebView:(JXWebViewController *)jx_webView {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:jx_webView action:@selector(cancelButtonPressed:)];
    [jx_webView.navigationItem setLeftBarButtonItem:doneButton];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:jx_webView];
    return navigationController;
}

#pragma mark - Initializers

- (id)init {
    return [self initWithConfiguration:nil];
}

- (id)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if(self) {
//        _boundsRect = self.view.bounds;
        self.backLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.backLabel setTextAlignment:NSTextAlignmentCenter];
        [self.backLabel setTextColor:[UIColor blackColor]];
        if([WKWebView class]) {
            if(configuration) {
                self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
            }
            else {
                self.wkWebView = [[WKWebView alloc] init];
            }
        }
        else {
            self.uiWebView = [[UIWebView alloc] init];
        }
        
//        self.actionButtonHidden = NO;
//        self.showsURLInNavigationBar = NO;
//        self.showsPageTitleInNavigationBar = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    _boundsRect = self.view.bounds;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.backLabel setFrame:CGRectMake(0, 20, CGRectGetWidth(_boundsRect), 20)];
    self.backLabel.hidden = YES;
    self.previousNavigationControllerToolbarHidden = self.navigationController.toolbarHidden;
    self.previousNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
    
    [self.view addSubview:self.backLabel];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    if(self.wkWebView) {
        [self.wkWebView setFrame:_boundsRect];
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setMultipleTouchEnabled:YES];
        [self.wkWebView setAutoresizesSubviews:YES];
        [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
        [self.wkWebView.scrollView setBackgroundColor:[UIColor clearColor]];
        [self.wkWebView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.wkWebView];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:JXContext];
        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
    } else if(self.uiWebView) {
        [self.uiWebView setFrame:_boundsRect];
        [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.uiWebView setDelegate:self];
        [self.uiWebView setMultipleTouchEnabled:YES];
        [self.uiWebView setAutoresizesSubviews:YES];
        [self.uiWebView setScalesPageToFit:YES];
        [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
        [self.uiWebView setBackgroundColor:[UIColor clearColor]];
        [self.uiWebView.scrollView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.uiWebView];
        
    }
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setTintColor:[UIColor whiteColor]];
    [self.progressView setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height-self.progressView.frame.size.height, _boundsRect.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
////    [self.navigationController setToolbarHidden:NO animated:YES];
//    
    [self.navigationController.navigationBar addSubview:self.progressView];
    
//    [self updateToolbarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:self.previousNavigationControllerNavigationBarHidden animated:animated];
//    
//    [self.navigationController setToolbarHidden:self.previousNavigationControllerToolbarHidden animated:animated];
    
    [self.uiWebView setDelegate:nil];
    [self.progressView removeFromSuperview];
}

#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    if(self.wkWebView) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0]];
    }
    else if(self.uiWebView) {
        [self.uiWebView loadRequest:[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0]];
    }
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
    [self.navigationController.navigationBar setTintColor:tintColor];
    [self.navigationController.toolbar setTintColor:tintColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
    [self.navigationController.navigationBar setBarTintColor:barTintColor];
    [self.navigationController.toolbar setBarTintColor:barTintColor];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView == self.uiWebView) {
        self.uiWebViewCurrentURL = request.URL;
        self.uiWebViewIsLoading = YES;
//        [self updateToolbarState];
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.navigationItem.title = theTitle;
        [self fakeProgressViewStartLoading];
        
        if([self.delegate respondsToSelector:@selector(jx_webView:didStartLoadingURL:)]) {
            [self.delegate jx_webView:self didStartLoadingURL:request.URL];
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
//            [self updateToolbarState];
            
            [self fakeProgressBarStopLoading];
        }
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showBackLabel) userInfo:nil repeats:NO];
        if([self.delegate respondsToSelector:@selector(jx_webView:didFinishLoadingURL:)]) {
            [self.delegate jx_webView:self didFinishLoadingURL:self.uiWebView.request.URL];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
//            [self updateToolbarState];
            
            [self fakeProgressBarStopLoading];
        }
        if([self.delegate respondsToSelector:@selector(jx_webView:didFailToLoadURL:error:)]) {
            [self.delegate jx_webView:self didFailToLoadURL:self.uiWebView.request.URL error:error];
        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
//        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(jx_webView:didStartLoadingURL:)]) {
            [self.delegate jx_webView:self didStartLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showBackLabel) userInfo:nil repeats:NO];
//        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(jx_webView:didFinishLoadingURL:)]) {
            [self.delegate jx_webView:self didFinishLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)showBackLabel {
    if (self.backTipString == nil) {
        self.backLabel.text = defaultTipString;
    } else {
        self.backLabel.text = self.backTipString;
    }
    self.backLabel.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
//        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(jx_webView:didFailToLoadURL:error:)]) {
            [self.delegate jx_webView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
//        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(jx_webView:didFailToLoadURL:error:)]) {
            [self.delegate jx_webView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}

#pragma mark - cancel Button Action

- (void)cancelButtonPressed:(id)sender {
    [self dismissAnimated:YES];
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebView) {
            self.navigationItem.title = self.wkWebView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated {
    [self.navigationController dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.uiWebView setDelegate:nil];
    
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    if ([self isViewLoaded]) {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }
}

//#pragma mark - Toolbar State 该项目使用不到的前进返回，刷新等功能
//
//- (void)updateToolbarState {
//
//    BOOL canGoBack = self.wkWebView.canGoBack || self.uiWebView.canGoBack;
//    BOOL canGoForward = self.wkWebView.canGoForward || self.uiWebView.canGoForward;
//
//    [self.backButton setEnabled:canGoBack];
//    [self.forwardButton setEnabled:canGoForward];
//
//    if(!self.backButton) {
//        [self setupToolbarItems];
//    }
//
//    NSArray *barButtonItems;
//    if(self.wkWebView.loading || self.uiWebViewIsLoading) {
//        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.stopButton, self.flexibleSeparator];
//
//        if(self.showsURLInNavigationBar) {
//            NSString *URLString;
//            if(self.wkWebView) {
//                URLString = [self.wkWebView.URL absoluteString];
//            }
//            else if(self.uiWebView) {
//                URLString = [self.uiWebViewCurrentURL absoluteString];
//            }
//
//            URLString = [URLString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
//            URLString = [URLString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
//            URLString = [URLString substringToIndex:[URLString length]-1];
//            self.navigationItem.title = URLString;
//        }
//    }
//    else {
//        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.refreshButton, self.flexibleSeparator];
//
//        if(self.showsPageTitleInNavigationBar) {
//            if(self.wkWebView) {
//                self.navigationItem.title = self.wkWebView.title;
//            }
//            else if(self.uiWebView) {
//                self.navigationItem.title = [self.uiWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
//            }
//        }
//    }
//
//    if(!self.actionButtonHidden) {
//        NSMutableArray *mutableBarButtonItems = [NSMutableArray arrayWithArray:barButtonItems];
//        [mutableBarButtonItems addObject:self.actionButton];
//        barButtonItems = [NSArray arrayWithArray:mutableBarButtonItems];
//    }
//
//    [self setToolbarItems:barButtonItems animated:YES];
//}
//
//- (void)setupToolbarItems {
//    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
//    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButtonPressed:)];
//    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
//    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed:)];
//    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
//    self.fixedSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    self.fixedSeparator.width = 50.0f;
//    self.flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//}

//#pragma mark - UIBarButtonItem Target Action Methods
//
//- (void)backButtonPressed:(id)sender {
//    
//    if(self.wkWebView) {
//        [self.wkWebView goBack];
//    }
//    else if(self.uiWebView) {
//        [self.uiWebView goBack];
//    }
//    [self updateToolbarState];
//}
//
//- (void)forwardButtonPressed:(id)sender {
//    if(self.wkWebView) {
//        [self.wkWebView goForward];
//    }
//    else if(self.uiWebView) {
//        [self.uiWebView goForward];
//    }
//    [self updateToolbarState];
//}
//
//- (void)refreshButtonPressed:(id)sender {
//    if(self.wkWebView) {
//        [self.wkWebView stopLoading];
//        [self.wkWebView reload];
//    }
//    else if(self.uiWebView) {
//        [self.uiWebView stopLoading];
//        [self.uiWebView reload];
//    }
//}
//
//- (void)stopButtonPressed:(id)sender {
//    if(self.wkWebView) {
//        [self.wkWebView stopLoading];
//    }
//    else if(self.uiWebView) {
//        [self.uiWebView stopLoading];
//    }
//}
@end

@implementation UINavigationController(JXWebViewController)

- (JXWebViewController *)rootWebViewController {
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
    return (JXWebViewController *)rootViewController;
}

@end
