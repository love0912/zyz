//
//  VC_HelpDetail.m
//  自由找
//
//  Created by guojie on 16/7/15.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_HelpDetail.h"

@interface VC_HelpDetail ()

@end

@implementation VC_HelpDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    if (self.parameters != nil) {
        self.jx_title = [self.parameters objectForKey:@"Name"];
        
        NSString *urlString = [self.parameters objectForKey:@"Url"];
        if (![urlString hasPrefix:@"http://"]) {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *url = [NSURL URLWithString:urlString];
        [ProgressHUD showProgressHUDWithInfo:@""];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD hideProgressHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD hideProgressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
