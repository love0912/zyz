//
//  VC_TechBuy_Desc.m
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_TechBuy_Desc.h"
#import "Masonry.h"
#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ProductService.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

#define WEBVIEW_TAG 10000

#define CellBuyWebView @"WEBVIEW"
#define CellBuyProducerCount @"ProducerCount"
#define CellBuyEvaluateCount @"EvaluateCount"
#define CellBuyEvaluateFirst @"EvaluateFirst"

@interface VC_TechBuy_Desc ()<MGTemplateEngineDelegate>
{
    NSArray *_arr_menu;
    CGFloat _webViewHeight;
    //分享
    NSArray *_sharePlatformSubType;
    ProductService *_productService;
    ProductDomain *_product;
    NSDictionary *_region;
    ProductDetailsDomain *_productInfo;
    /**
     *  1 -- 技术标购买, 2 -- 投标预算标购买
     */
    NSInteger _type;
}

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation VC_TechBuy_Desc

- (void)initData {
    _webView = [[UIWebView alloc] init];
    _webView.scrollView.scrollEnabled = NO;
    _webView.tag = WEBVIEW_TAG;
    _webView.delegate = self;
    _webViewHeight = 0;
    
     _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
    
    _productService = [ProductService sharedService];
    
    _product = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"Product"];
    _region = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"Region"];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    
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
                          @{kCellKey: CellBuyProducerCount},
                          @{kCellKey: CellBuyEvaluateCount},
                          @{kCellKey: CellBuyEvaluateFirst}
                          ]
                      ];
    } else {
        _arr_menu = @[
                      @[
                          @{kCellKey: CellBuyWebView}
                          ],
                      @[
                          @{kCellKey: CellBuyProducerCount}
                          ]
                      ];
    }
}

- (void)layoutUI {
    [self hideTableViewFooter:_tableView];
    [self hideTableViewHeader:_tableView];
    self.jx_title = _product.Name;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedPressed)];
    [self setNavigationBarRightItem:rightItem];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [_webView loadRequest:request];
//    [ProgressHUD showProgressHUDWithInfo:@""];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
    [self getProductInfo];
    
    if (_type == 1) {
        [CountUtil countTechDetail];
    } else {
        [CountUtil countBudgeDetail];
    }
}

- (void)getProductInfo {
    [_productService getProductDetailsWithID:_product.SerialNo region:_region result:^(NSInteger code, ProductDetailsDomain *productInfo) {
        if (code == 1) {
            _productInfo = productInfo;
            if (productInfo.CommentTopItem == nil) {
                [self initMenuWithType:2];
            } else {
                [self initMenuWithType:1];
            }
//            [self loadWebView];
            [self loadWebViewByProduct:_product];
        } else {
            [ProgressHUD showInfo:@"获取产品详情失败" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
}

- (void)loadWebViewByProduct:(ProductDomain *)product {
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"商品预览" ofType:@"html"];
    NSString *baseURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
    [engine setObject:product.Name forKey:@"Name"];
    [engine setObject:product.FullName forKey:@"FullName"];
    [engine setObject:product.Standard forKey:@"Standard"];
    [engine setObject:product.Remark forKey:@"Remark"];
    [engine setObject:product.PerPrice forKey:@"PerPrice"];
    [engine setObject:product.Phone forKey:@"Phone"];
    [engine setObject:product.QQ forKey:@"QQ"];
    [engine setObject:product.WeChat forKey:@"WeChat"];
    
    NSString *htmlString = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURL]];
}

- (void)loadWebView {
    [ProgressHUD showProgressHUDWithInfo:@""];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_product.Url]];
    [_webView loadRequest:request];
    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [_productService getHtmlStringWithUrl:_product.Url success:^(id responseObject) {
//        NSString *htmlString = responseObject;
//        [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:HTML_BASE_HOST]];
//    } fail:^{
//        //Error
//        
//    }];
}


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

#pragma mark --分享
-(void)shareButtonIndex:(int)buttonIndex{
    if (buttonIndex !=9999) {
        //1、创建分享参数
        NSString *url = [NSString stringWithFormat:@"%@", _product.Url];
        NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@", _product.Name, url]
                                             images:imageArray
                                                url:[NSURL URLWithString:url]
                                              title:_product.Name
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

#pragma mark - webview
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD hideProgressHUD];
    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"container\").offsetHeight;"];
    _webViewHeight = [heightString floatValue];
    [_tableView reloadData];
    if (_type == 1) {
        [_webView stringByEvaluatingJavaScriptFromString:@"showtype1();"];
    } else {
        [_webView stringByEvaluatingJavaScriptFromString:@"showtype2();"];
    }
    
//    if (IS_IPHONE_4_OR_LESS) {
//        _webViewHeight = [self countWebViewHieght] - 71 + 44;
//    } else if (IS_IPHONE_5) {
//        _webViewHeight = [self countWebViewHieght] - 71 + 140;
//    }else if (IS_IPHONE_6) {
//        _webViewHeight = [self countWebViewHieght] + 162 + 58;
//    } else {
//        _webViewHeight = [self countWebViewHieght] + 132 + 56;
//    }
//    [_tableView reloadData];
//    
    [self performSelector:@selector(refreshWebView) withObject:nil afterDelay:0.2];
}

- (void)refreshWebView {
    _webViewHeight = [self countWebViewHieght] + 2 + 54;
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        _webViewHeight += 4;
    }
    [_tableView reloadData];
}

- (CGFloat)countWebViewHieght {
//    return [[self.webView stringByEvaluatingJavaScriptFromString:@"(document.height !== undefined) ? document.height : document.body.offsetHeight;"] floatValue];
    return [[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"container\").offsetHeight;"] floatValue];
//    NSLog(@"%@", self.webView.scrollView);
//    return  self.webView.scrollView.contentSize.height;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD hideProgressHUD];
    [ProgressHUD showInfo:@"查看产品详情失败，请稍后重试" withSucc:NO withDismissDelay:2];
    [self backPressed];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString=[[request URL] absoluteString];
    NSRange range = [urlString rangeOfString:@"hm://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) {
        _webViewHeight = [self countWebViewHieght] + 2 + 54;
        if (IS_IPHONE_6 || IS_IPHONE_6P) {
            _webViewHeight += 4;
        }
        [_tableView reloadData];
        return NO;
    }
    return YES;
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
    } else if ([CellBuyProducerCount isEqualToString:key]) {
        cell.contentView.backgroundColor = [UIColor colorWithHex:@"fff0bd"];
        cell.backgroundColor = [UIColor colorWithHex:@"fff0bd"];
        cell.textLabel.textColor = [UIColor colorWithHex:@"ff6718"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *text = [NSString stringWithFormat:@"%@有%@人接单", _region[kCommonValue], _productInfo.RegionCount];
        cell.textLabel.text = text;
        cell.imageView.image = [UIImage imageNamed:@"Buy_ProducerCount_Tips"];
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
    
    
    
//    if (indexPath.section == 0) {
//        [cell.contentView addSubview:_webView];
//        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cell.contentView.mas_left);
//            make.top.equalTo(cell.contentView.mas_top);
//            make.right.equalTo(cell.contentView.mas_right);
//            make.bottom.equalTo(cell.contentView.mas_bottom);
//        }];
//        return cell;
//    } else {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"重庆市有好多人接单";
//            return cell;
//        } else if (indexPath.row == 1) {
//            cell.textLabel.text = @"产品评价(200)";
//            return cell;
//        } else {
//            cell_Evaluate.delegate = self;
//            [cell_Evaluate configWithEvaluateDomain:nil];
//            return cell_Evaluate;
//        }
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _webViewHeight;
    } else {
        if (indexPath.row == 0) {
            return 48;
        } else if (indexPath.row == 1) {
            return 48;
        } else {
            return 169;
        }
    }
}

//- (void)backPressed {
//    NSArray *vcs = self.navigationController.viewControllers;
//    UIViewController *descVC = [vcs objectAtIndex:vcs.count - 3];
//    [self.navigationController popToViewController:descVC animated:YES];
//}

- (void)viewAllEvaluate {
    [PageJumpHelper pushToVCID:@"VC_EvaluateList" storyboard:Storyboard_Main parameters:@{kPageDataDic: @{@"ProjectID": _product.SerialNo, @"Count": _productInfo.CommentCount}} parent:self];
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

- (IBAction)btn_ordering_pressed:(id)sender {
    if (_type == 1) {
        [CountUtil countTechToOrder];
    } else {
        [CountUtil countBudgeToOrder];
    }
    
    
    NSInteger count = [_productInfo.RegionCount integerValue];
    if (count == 0 && _type == 2) {
        [ProgressHUD showInfo:@"该区域暂时无人接单" withSucc:NO withDismissDelay:2];
    } else {
        [PageJumpHelper pushToVCID:@"VC_OrderReview" storyboard:Storyboard_Main parameters:@{kPageDataDic: @{@"Product": _product, @"Region": _region}, kPageType: @(_type)} parent:self];
    }
//    [PageJumpHelper pushToVCID:@"VC_OrderReview" storyboard:Storyboard_Main parent:self];
}
@end
