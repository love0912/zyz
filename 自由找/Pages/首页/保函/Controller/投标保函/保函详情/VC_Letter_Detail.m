//
//  VC_Letter_Detail.m
//  自由找
//
//  Created by 郭界 on 16/10/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Letter_Detail.h"
#import "Masonry.h"
#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BidLetterDomain.h"
#import "ProductService.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "JZAlbumViewController.h"
#import "LetterAddressService.h"

#define WEBVIEW_TAG 10000
#define CellBuyWebView @"WEBVIEW"
#define CellBuyEvaluateCount @"EvaluateCount"
#define CellBuyEvaluateFirst @"EvaluateFirst"

@interface VC_Letter_Detail ()<MGTemplateEngineDelegate>
{
    NSArray *_arr_menu;
    CGFloat _webViewHeight;
    
    NSArray *_sharePlatformSubType;
    BidLetterDomain *_bidLetter;
    ProductService *_productService;
    
    ProductDetailsDomain *_productInfo;
    
    LetterAddressService *_letterAddressService;

}

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation VC_Letter_Detail

- (void)initData {
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.scrollEnabled = NO;
    _webView.tag = WEBVIEW_TAG;
    _webView.delegate = self;
    _webViewHeight = 0;
    
    _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
    
    _bidLetter = [self.parameters objectForKey:kPageDataDic];
    _productService = [ProductService sharedService];
    _letterAddressService = [LetterAddressService sharedService];
    
//    _bidLetter = [[BidLetterDomain alloc] init];
//    _bidLetter.Name = @"浦发银行投标保函";
//    _bidLetter.Bank = @"浦发银行";
//    _bidLetter.Description = @"7天之后交稿";
//    _bidLetter.Remark = @"备注个擦擦擦擦擦擦";
//    _bidLetter.Phone = @"17708347776";
//    _bidLetter.PayParameter = @"1000";
    
}

- (void)layoutUI {
    [self hideTableViewFooter:_tableView];
    [self hideTableViewHeader:_tableView];
    self.jx_title = _bidLetter.Name;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedPressed)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"保函详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self initMenuWithType:2];
    [self getProductInfo];
//    [self loadWebViewByBidLetter:_bidLetter];
    
    [CountUtil countBidLetterDetail];
}

/**
 *  layout视图
 *
 *  @param type 1 -- 有评价, 2 -- 无评价
 */
- (void)initMenuWithType:(NSInteger)type {
    if (type == 1) {
        _arr_menu = @[
                      @[
                          @{kCellKey: CellBuyWebView}
                          ],
                      @[
                          @{kCellKey: CellBuyEvaluateCount},
                          @{kCellKey: CellBuyEvaluateFirst}
                          ]
                      ];
    } else {
        _arr_menu = @[
                      @[
                          @{kCellKey: CellBuyWebView}
                          ]
                      ];
    }
    
//    [self loadWebViewByBidLetter:_bidLetter];
}

- (void)getProductInfo {
    [_productService getProductDetailsWithID:_bidLetter.SerialNo productType:3 region:nil result:^(NSInteger code, ProductDetailsDomain *productInfo) {
        if (code == 1) {
            _productInfo = productInfo;
            if (productInfo.CommentTopItem == nil) {
                [self initMenuWithType:2];
            } else {
                [self initMenuWithType:1];
            }
            [self loadWebViewByBidLetter:_bidLetter];
        } else {
            [ProgressHUD showInfo:@"获取产品详情失败" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
}

- (void)loadWebViewByBidLetter:(BidLetterDomain *)bidLetter {
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"银行保函" ofType:@"html"];
    
    NSString *baseURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
    [engine setObject:_bidLetter.Name forKey:@"name"];
    NSString *price;
    if ([_bidLetter.PayMode isEqualToString:@"1"]) {
        CGFloat tmpPriceF = _bidLetter.PayParameter.floatValue * 100;
        CGFloat tmpPriceMax = _bidLetter.PayParameterMax.floatValue * 100;
        if (tmpPriceF == tmpPriceMax) {
            price = [NSString stringWithFormat:@"%@%%", [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", tmpPriceF]]];
        } else {
            price = [NSString stringWithFormat:@"%@%% - %@%%", [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", tmpPriceF]], [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", tmpPriceMax]]];
        }
        [engine setObject:@"费率" forKey:@"PriceName"];
    } else {
        if ([_bidLetter.PayParameter isEqualToString:_bidLetter.PayParameterMax]) {
            price = [NSString stringWithFormat:@"￥%@元", [CommonUtil removeFloatAllZero:_bidLetter.PayParameter]];
            [engine setObject:@"价格" forKey:@"PriceName"];
        } else {
            price = [NSString stringWithFormat:@"￥%@ - %@元", [CommonUtil removeFloatAllZero:_bidLetter.PayParameter], [CommonUtil removeFloatAllZero:_bidLetter.PayParameterMax]];
            [engine setObject:@"价格" forKey:@"PriceName"];
        }
    }
    
    [engine setObject:price forKey:@"price"];
    [engine setObject:_bidLetter.Description forKey:@"description"];
    [engine setObject:_bidLetter.Bank forKey:@"bank"];
    [engine setObject:_bidLetter.Phone forKey:@"phone"];
    [engine setObject:_bidLetter.Remark forKey:@"remark"];
    [engine setObject:_bidLetter.NormalUrl == nil ? @"" : [_bidLetter.NormalUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"normalurl"];
    NSString *htmlString = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_menu objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *ID_WebView = @"Cell_WebView";
    static NSString *ID_Text = @"Cell_Text";
    static NSString *ID_Evaluate = @"Cell_Evaluate";
    
    Cell_Evaluate *cell_Evaluate = [tableView dequeueReusableCellWithIdentifier:ID_Evaluate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_Text];
    UIWebView *webView = [cell.contentView viewWithTag:WEBVIEW_TAG];
    if (webView != nil) {
        [webView removeFromSuperview];
    }
    NSDictionary *tmpDic = [[_arr_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = [tmpDic objectForKey:kCellKey];
    cell.imageView.image = nil;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHex:@"999999"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if ([CellBuyWebView isEqualToString:key]) {
        [cell.contentView addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.top.equalTo(cell.contentView.mas_top);
            make.right.equalTo(cell.contentView.mas_right);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        return cell;
    } else if ([CellBuyEvaluateCount isEqualToString:key]) {
        NSString *text = [NSString stringWithFormat:@"产品评价（%@）", _productInfo.CommentCount];
        cell.textLabel .text = text;
        return cell;
    } else if ([CellBuyEvaluateFirst isEqualToString:key]) {
        cell_Evaluate.delegate = self;
        cell_Evaluate.evaluate = _productInfo.CommentTopItem;
        return cell_Evaluate;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _webViewHeight;
    } else {
        if (indexPath.row == 0) {
            return 48;
        } else {
            return 169;
        }
    }
}

#pragma mark - webview
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"container\").offsetHeight;"];
    _webViewHeight = [heightString floatValue];
    [_tableView reloadData];
    NSString *method = [NSString stringWithFormat:@"loadImage('NormalUrl','%@',loadResult);", _bidLetter.NormalUrl];
    [_webView stringByEvaluatingJavaScriptFromString:method];
    
//    if ([_bidLetter.PayMode isEqualToString:@"1"]) {
//        [_webView stringByEvaluatingJavaScriptFromString:@"hidebutton();"];
//    }
//    [self getProductInfo];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString=[[request URL] absoluteString];
    NSRange range = [urlString rangeOfString:@"jx://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) {
        if ([urlString hasSuffix:@"showPrice"]) {
            [self showPriceView];
        } else if ([urlString hasSuffix:@"showBigImage"]) {
            [self performSelector:@selector(showBigImage) withObject:nil afterDelay:0.2];
//            [self showBigImage];
        } else if ([urlString hasSuffix:@"call"]) {
            [CommonUtil callWithPhone:_bidLetter.Phone];
        } else if ([urlString hasSuffix:@"finishLoadImage"]) {
            NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"container\").offsetHeight;"];
            _webViewHeight = [heightString floatValue];
            [_tableView reloadData];
        }
        return NO;
    }
    return YES;
}


- (void)showBigImage {
    JZAlbumViewController *jzAlbum = [[JZAlbumViewController alloc] init];
    jzAlbum.currentIndex = 0;//这个参数表示当前图片的index，默认是0
//    jzAlbum.imgArr = [NSMutableArray arrayWithObject:(_bidLetter.NormalUrl == nil ? @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1209/10/c1/13758581_1347257278695.jpg" : _bidLetter.NormalUrl)];
    jzAlbum.imgArr = [NSMutableArray arrayWithObject:[_bidLetter.NormalUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self presentViewController:jzAlbum animated:YES completion:nil];
}

- (void)showPriceView {
    [PageJumpHelper pushToVCID:@"VC_LetterPriceDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:_bidLetter.SerialNo, @"JX_Title":_bidLetter.Name, kPageType: _bidLetter.PayMode} parent:self];
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
        NSString *url = [NSString stringWithFormat:@"%@", _bidLetter.Url];
        NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@", _bidLetter.Name, url]
                                             images:imageArray
                                                url:[NSURL URLWithString:url]
                                              title:_bidLetter.Name
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

- (void)viewAllEvaluate {
    [PageJumpHelper pushToVCID:@"VC_EvaluateList" storyboard:Storyboard_Main parameters:@{kPageDataDic: @{@"ProjectID": _bidLetter.SerialNo, @"Count": _productInfo.CommentCount}, kPageType: @(3)} parent:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_openLetter_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_ConfirmLetter" storyboard:Storyboard_Main parent:self];
    [CountUtil countBidLetterOpen];
    
//    [PageJumpHelper pushToVCID:@"VC_ConfirmLetter" storyboard:Storyboard_Main parameters:@{kPageDataDic: _bidLetter} parent:self];
//    [PageJumpHelper pushToVCID:@"VC_NewBidLetterBuy" storyboard:Storyboard_Main parameters:@{kPageDataDic: _bidLetter} parent:self];
    
    [_letterAddressService getOurDefaultAddressToResult:^(NSInteger code, LetterAddressDomain *letterAddress) {
        if (code == 1) {
            if (letterAddress == nil) {
                [PageJumpHelper pushToVCID:@"VC_LetterAddress" storyboard:Storyboard_Main parameters:@{kPageType: @0} parent:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitNotification:) name:@"Notification_Submit_Letter_Order" object:nil];
            } else {
                [self pushToLetterOrder:letterAddress];
            }
        }
    }];
    
}

- (void)submitNotification:(NSNotification *)notification {
    [self openLetter];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)openLetter {
    [_letterAddressService getOurDefaultAddressToResult:^(NSInteger code, LetterAddressDomain *letterAddress) {
        [self pushToLetterOrder:letterAddress];
    }];
}

- (void)pushToLetterOrder:(LetterAddressDomain *)letterAddress {
    [PageJumpHelper pushToVCID:@"VC_NewBidLetterBuy" storyboard:Storyboard_Main parameters:@{kPageType:@1, kPageDataDic:@{@"LetterAddress": letterAddress, @"BidLetter": _bidLetter}, @"StatusType":@0 } parent:self];
}

@end
