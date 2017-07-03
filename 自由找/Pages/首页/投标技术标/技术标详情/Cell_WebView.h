//
//  Cell_WebView.h
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWebViewDidLoadDelegate <NSObject>

- (void)webViewTextWithHeight:(CGFloat)height;

@end

@interface Cell_WebView : UITableViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)configureWithUrlString:(NSString *)urlString;

@property (weak, nonatomic) id<JWebViewDidLoadDelegate> delegate;

@end
