//
//  Cell_WebView.m
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_WebView.h"

@implementation Cell_WebView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = webView.scrollView.contentSize.height;
    if ([_delegate respondsToSelector:@selector(webViewTextWithHeight:)]) {
        [_delegate webViewTextWithHeight:webView.scrollView.contentSize.height];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
