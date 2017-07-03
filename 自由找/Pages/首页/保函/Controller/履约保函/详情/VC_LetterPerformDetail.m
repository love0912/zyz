//
//  VC_LetterPerformDetail.m
//  zyz
//
//  Created by 郭界 on 16/10/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_LetterPerformDetail.h"
#import "LetterPerformDomain.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "AuthenLetterService.h"
#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "LetterService.h"


@interface VC_LetterPerformDetail ()<MGTemplateEngineDelegate>
{
    LetterPerformDomain *_letterPerform;
    AuthenLetterService *_authLetterService;
    LetterService *_letterService;
    NSArray *_sharePlatformSubType;
    BOOL _isAuthed;
}
@end

@implementation VC_LetterPerformDetail

- (void)initData {
    _letterPerform = [self.parameters objectForKey:kPageDataDic];
    _authLetterService = [AuthenLetterService sharedService];
    _letterService = [LetterService sharedService];
    
    _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
    
    _isAuthed = NO;
}

- (void)layoutUI {
    if (_letterPerform != nil) {
        [self loadWebViewByBidLetter:_letterPerform];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedPressed)];
    [self setNavigationBarRightItem:rightItem];
    [self loadWebViewData];
}

- (void)loadWebViewData {
    [_authLetterService getAuthenInfoResult:^(AuthenLetterDomain *authenLetter, NSInteger code) {
        if (code == 1) {
            if ([authenLetter.AuthStatus isEqualToString:@"2"]) {
                _isAuthed = YES;
            }
        }
        [self loadWebViewByBidLetter:_letterPerform];
    }];
}

- (void)loadWebViewByBidLetter:(LetterPerformDomain *)letterPerform {
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"履约保函" ofType:@"html"];
    
    NSString *baseURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
    [engine setObject:letterPerform.ProjectName forKey:@"ProjectName"];
//    NSString *price;
//    if ([letterPerform.PayMode isEqualToString:@"1"]) {
//        CGFloat tmpPriceF = letterPerform.PayParameter.floatValue * 100;
//        price = [NSString stringWithFormat:@"%@%%", [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", tmpPriceF]]];
//    } else {
//        price = [NSString stringWithFormat:@"￥%@元", [CommonUtil removeFloatAllZero:letterPerform.PayParameter]];
//    }
    if (_isAuthed) {
        [engine setObject:letterPerform.Phone forKey:@"Phone"];
    } else {
        [engine setObject:@"*********" forKey:@"Phone"];
    }
    [engine setObject:letterPerform.Period forKey:@"Period"];
    [engine setObject:letterPerform.Company forKey:@"Company"];
    [engine setObject:letterPerform.OwnerName forKey:@"OwnerName"];
    [engine setObject:letterPerform.ProjectArea.Value forKey:@"ProjectArea"];
    [engine setObject:letterPerform.ProjectCategory.Value forKey:@"ProjectCategory"];
    [engine setObject:((letterPerform.Remark == nil || letterPerform.Remark.isEmptyString) ? @"无" : letterPerform.Remark) forKey:@"Remark"];
    CGFloat priceFloat = _letterPerform.Amount.floatValue / 10000;
    NSString *price = [NSString stringWithFormat:@"%f", priceFloat];
    
    [engine setObject:[CommonUtil removeFloatAllZero:price] forKey:@"Amount"];
    
    NSString *htmlString = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURL]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"履约保函详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}


#pragma mark - webview delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString=[[request URL] absoluteString];
    NSRange range = [urlString rangeOfString:@"jx://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) {
        if ([urlString hasSuffix:@"call"]) {
            [self getCallInfo];
        } else if ([urlString hasSuffix:@"collection"]) {
            [self collectionLetter];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_letterPerform.IsFavorited isEqualToString:@"1"]) {
        [_webView stringByEvaluatingJavaScriptFromString:@"keepactive();"];
    }
}

#pragma mark -

- (void)collectionLetter {
    [_letterService collectionLetterPerformByID:_letterPerform.SerialNo result:^(NSInteger code) {
        if (code == 1) {
            [_webView stringByEvaluatingJavaScriptFromString:@"keepactive();"];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LetterPerform_Refresh object:nil];
        }
    }];
}

- (void)getCallInfo {
    if (_isAuthed) {
        [CommonUtil callWithPhone:_letterPerform.Phone];
        return;
    }
    [_authLetterService getAuthenInfoResult:^(AuthenLetterDomain *authenLetter, NSInteger code) {
        if (code == 1) {
            if ([authenLetter.AuthStatus isEqualToString:@"2"]) {
                [CommonUtil callWithPhone:_letterPerform.Phone];
            } else {
                [ProgressHUD showInfo:@"您不是担保公司认证用户，无权查看联系方式" withSucc:NO withDismissDelay:2];
            }
        }
    }];
}

#pragma mark --分享
- (void)sharedPressed {
    ShareHelper *sharehelper=[[ShareHelper alloc] init];
    sharehelper.shareTitle=@"分享邀请好友";
    [sharehelper setButtonTitles:[NSMutableArray arrayWithObjects:@"QQ好友", @"微信好友",@"朋友圈", @"短信", nil]];
    [sharehelper setButtonImages:[NSMutableArray arrayWithObjects:@"m1", @"m2",@"m3", @"m4", @"m4",nil]];
    [sharehelper setOnButtonTouchUpInside:^(ShareHelper *shareHelper, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[shareHelper tag]);
        [self shareButtonIndex:buttonIndex];
        [shareHelper close];
        
    }];
    [sharehelper show];
}

-(void)shareButtonIndex:(int)buttonIndex{
    if (buttonIndex !=9999) {
        //1、创建分享参数
        NSString *url = [NSString stringWithFormat:@"%@", _letterPerform.Url];
        NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@""]
                                             images:imageArray
                                                url:[NSURL URLWithString:url]
                                              title:_letterPerform.ProjectName
                                               type:SSDKContentTypeAuto];
            
            [ShareSDK share:[[_sharePlatformSubType objectAtIndex:buttonIndex]integerValue] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                NSLog(@"%@", error);
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        [ProgressHUD showInfo:@"分享成功" withSucc:NO withDismissDelay:2];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        [ProgressHUD showInfo:@"分享失败" withSucc:NO withDismissDelay:2];
                        break;
                    }
                    default:
                        break;
                }
            }];
            
        }
    }
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
