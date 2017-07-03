//
//  VC_Tech_OrderDetail.m
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Tech_OrderDetail.h"
#import "ShareHelper.h"
#import "LPTradeView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BidService.h"
#import "ProjectOrderService.h"
#import "ProducerService.h"
#import "PayService.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface VC_Tech_OrderDetail ()<MGTemplateEngineDelegate>
{
    BaseService *_baseService;
    
    //分享
    NSArray *_sharePlatformSubType;
    
    ProjectOrderService *_projectService;
    ProducerService *_producerService;
    ProjectOrderDomain *_projectOrder;
    View_OrderTakeBounced *_orderTakeBounced;
    ProducerDomain * producerdomian;
    PayService *_payService;
    NSString *_orderTypeString;
    
    //隐藏网页里的类别，我的接单
    BOOL _hideType;
    
    Boolean _isNotification;
    NSInteger _payCount;
    
    NSTimer *_payTimer;
    Boolean _isContinuePay;
    NSString *_password;
    NSDictionary *_payInfoDic;


}
/**
 *  1 -- 技术标接单, 2 -- 投标预算标接单,3-我的接单
 */
@property (assign, nonatomic) NSInteger type;
@end

@implementation VC_Tech_OrderDetail
-(void)initData{
    _hideType = NO;
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _projectOrder = [self.parameters objectForKey:kPageDataDic];
    if (_type==3) {
        _hideType = YES;
        _btn_applyOrder.enabled=NO;
        [_btn_applyOrder setTitle:@"已接单" forState:UIControlStateNormal];
        _orderTypeString = [self.parameters objectForKey:@"TakeOrderSnapData"];
    }
    _baseService = [BaseService sharedService];
    _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
    
    _projectService =[ProjectOrderService sharedService];
    _producerService =[ProducerService sharedService];
    _payService=[PayService sharedService];
    self.jx_title = _projectOrder.ProjectTitle;
    
    _isNotification = NO;
    _isContinuePay = NO;
}
-(void)layoutUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPayOrder) name:Notification_RePay_BidLetter object:nil];
    if (_type != 3) {
        if ([_projectOrder.IsLimited isEqualToString:@"1"]) {
            _btn_applyOrder.enabled=NO;
            [_btn_applyOrder setTitle:@"订单已接满" forState:UIControlStateNormal];
        }
    }
    _type = _projectOrder.ProductType.integerValue;
    [self layoutSharedButton];
    if (!_hideType) {
        [_projectService getProjectOrderTypeByProjectID:_projectOrder.SerialNo productType:_type result:^(NSInteger code, NSString *orderTypes) {
            if (code ==1) {
                _orderTypeString = orderTypes;
            }
            [self loadWebViewByProjectOrder:_projectOrder];
        }];
    } else {
        [self loadWebViewByProjectOrder:_projectOrder];
    }
    
    
//    NSURL *url = [NSURL URLWithString:_projectOrder.Url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [ProgressHUD showProgressHUDWithInfo:@""];
//    [_webView loadRequest:request];
}

- (void)notificationPayOrder {
    _isNotification = YES;
    _isContinuePay = YES;
    _payCount = 0;
    _payTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(addPayCount) userInfo:nil repeats:YES];
    [self payWithPassword:_password payInfo:_payInfoDic];
}

- (void)addPayCount {
    _payCount++;
    if (_payCount % 5 == 0) {
        [self payWithPassword:_password payInfo:_payInfoDic];
    }
    if (_payCount > 30) {
        _isNotification = NO;
        _payCount = 0;
        [ProgressHUD hideProgressHUD];
        [ProgressHUD showInfo:@"请稍后再试" withSucc:NO withDismissDelay:2];
        [_payTimer invalidate];
    }
}

- (void)loadWebViewByProjectOrder:(ProjectOrderDomain *)projectOrder {
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setDelegate:self];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"接单预览" ofType:@"html"];
    NSString *baseURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"html"];
    [engine setObject:projectOrder.ProjectTitle == nil ? @"" : projectOrder.ProjectTitle forKey:@"ProjectTitle"];
    [engine setObject:projectOrder.ProjectName == nil ? @"" : projectOrder.ProjectName forKey:@"ProjectName"];
    [engine setObject:projectOrder.ProjectCode == nil ? @"" : projectOrder.ProjectCode forKey:@"ProjectCode"];
    [engine setObject:projectOrder.ProjectType == nil ? @"" : projectOrder.ProjectType.Value forKey:@"ProjectType"];
    [engine setObject:projectOrder.ProjectRegion == nil ? @"" : projectOrder.ProjectRegion.Value forKey:@"ProjectRegion"];
    [engine setObject:projectOrder.ProjectMaterial == nil ? @"" : projectOrder.ProjectMaterial forKey:@"ProjectMaterial"];
    [engine setObject:projectOrder.MaterialAccessCode == nil ? @"" : projectOrder.MaterialAccessCode forKey:@"MaterialAccessCode"];
    [engine setObject:projectOrder.Phone == nil ? @"" : projectOrder.Phone forKey:@"Phone"];
    
    NSString *htmlString = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURL]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"接单";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attention) name:Notification_Bid_Cerification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btn_applyorder_press:(id)sender {
    if([CommonUtil isLogin]){
        [self requset_btn_apply];
    } else {
        [PageJumpHelper presentLoginViewController];
    }
    
}
-(void)requset_btn_apply{
    [_producerService getSelfInfoToResult:^(NSInteger code, ProducerDomain *producer) {
        if (code==1) {
            producerdomian=producer;
            if(producerdomian!=nil){//有用户信息
                if ([producerdomian.AuthStatus integerValue]==1) {
                    [ProgressHUD showInfo:@"正在审核中，请耐心等待!" withSucc:NO withDismissDelay:2];
                }else if([producerdomian.AuthStatus integerValue]==4 ||[producerdomian.AuthStatus integerValue]==0){
                    NSString *titleString;
                    if ([producerdomian.AuthStatus integerValue]==4) {
                        titleString=@"审核被拒，是否前去重新提交认证信息？";
                    }else{
                       titleString=@"您处于未认证，是否前去提交完整认证信息";
                    }
                    [self chooseGoCertification:titleString];
                }else if([producerdomian.AuthStatus integerValue]==2){
                    if ([producerdomian.ProductType integerValue]==_type ||[producerdomian.ProductType isEqualToString:@"0"]){
                        [self requsetOrderData];
                    }else{
                        NSString *typeName = ([producerdomian.ProductType isEqualToString:@"1"] ? @"投标技术标" : @"投标预算");
                        NSString *title = [NSString stringWithFormat:@"您只能接%@类型的订单，如要接此类型的订单，请联系客服", typeName];
                        [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"联系客服"] showInController:nil clickAtIndex:^(NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                [CommonUtil callWithPhone:@"4000213618"];
                            }
                        }];
//                         [ProgressHUD showInfo:@"您如要接此类型单请联系客服！" withSucc:NO withDismissDelay:2];
                    }
                }
            }else{//无用户信息
                [self chooseGoCertification:@"您未认证，是否前去认证？"];
            }
        }else{
            [ProgressHUD showInfo:@"获取数据失败,请稍后重试！" withSucc:NO withDismissDelay:2];
        }
    }];
}
-(void)requsetOrderData{
    [_projectService applyReciveOrderByProjectID:_projectOrder.SerialNo productType:_type result:^(NSInteger code, NSArray<ProjectOrderTypeDomain *> *orderTypes) {
        if (code ==1) {
            if(orderTypes.count==0){
                [ProgressHUD showInfo:@"获取数据失败,请稍后重试！" withSucc:NO withDismissDelay:2];
                return;
            }
            NSMutableArray *newOrderTypes = [NSMutableArray arrayWithCapacity:orderTypes.count];
            NSArray *tmpArray = producerdomian.MaxQuantity;
            if (tmpArray != nil && tmpArray.count > 0) {
                for (ProjectOrderTypeDomain *order in orderTypes) {
                    NSString *key = order.Product.ProductLevel.Key;
                    for (MaxQuantityDomain *tmpQuality in producerdomian.MaxQuantity) {
                        if ([key isEqualToString:tmpQuality.ProductLevel.Key]) {
                            NSInteger avaliableCount = [order.AvaliableQuantity integerValue];
                            NSInteger receiveCount = [tmpQuality.MaxQuantity integerValue];
                            
                            order.receiveCount = avaliableCount >= receiveCount ? receiveCount : avaliableCount;
                        }
                    }
                    [newOrderTypes addObject:order];
                }
            }
            _orderTakeBounced=[[View_OrderTakeBounced alloc]initWithParentView:self.view];
            _orderTakeBounced.producer=producerdomian;
            _orderTakeBounced.pushType=_type;
            _orderTakeBounced.delegate=self;
            _orderTakeBounced.orderTypeArray=[NSMutableArray  arrayWithArray:newOrderTypes];
            _orderTakeBounced.projectTitle=_projectOrder.ProjectTitle;
            [_orderTakeBounced  show];
        }
    }];
}
-(void)chooseGoCertification:(NSString *)titleString{
    [JAlertHelper jAlertWithTitle:titleString message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (producerdomian!=nil) {
                [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{@"producerdomian":producerdomian,kPageType:@"1"} parent:self];
            }else{
                [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
            }
        }
    }];
}
- (void)attention {
     [ProgressHUD showInfo:@"您的认证正在审核中，请耐心等待!" withSucc:NO withDismissDelay:3];
}
#pragma mark - OrderTakeBounced delegate
-(void)SureButtonTouchUp:(NSDictionary *)dic{
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code != 1) {
            return;
        }
        if (wallet.Balance == nil) {
//            [_orderTakeBounced close];
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
        } else {
            [LPTradeView tradeViewNumberKeyboardWithMoney:[dic objectForKey:@"totalPrice"] moneyTag:@"需冻结保证金额" password:^(NSString *password) {
                NSDictionary *userDic = @{@"PayInfo": dic, @"Password": password};
                //        NSLog(@"密码是:%@",password);
                _password = password;
                _payInfoDic = dic;
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:userDic repeats:NO];
            }];
            
            
//            [LPTradeView tradeViewNumberKeyboardWithMoney:[dic objectForKey:@"totalPrice"]password:^(NSString *password) {
//                NSDictionary *userDic = @{@"PayInfo": dic, @"Password": password};
//                //        NSLog(@"密码是:%@",password);
//                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:userDic repeats:NO];
//            }];
        }
    }];

}

- (void)payWithPassword:(NSString *)password payInfo:(NSDictionary *)dic {
    [_projectService confirmOrderByOrderTypeID:[dic objectForKey:@"SerialNo"] quantity:[dic objectForKey:@"Quantity"] payPass:password result:^(NSInteger code,NSString *msg) {
        if (code == 1) {
            if (_isNotification) {
                [_payTimer invalidate];
            }
            //支付成功
            //TODO:
            [_orderTakeBounced close];
            [ProgressHUD showInfo:@"成功接单！" withSucc:YES withDismissDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OrderReceive_Refresh object:nil];
            [self goBack];
        }else if (code==301){//充值
            if (_isNotification) {
                [ProgressHUD showProgressHUDWithInfo:@""];
                return;
            }
//            [_orderTakeBounced close];
            [JAlertHelper jAlertWithTitle:@"余额不足，是否前去充值？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parameters:@{kPageDataDic:[dic objectForKey:@"totalPrice"], kPageReturnType: @1} parent:self];
                }
            }];
            
        }else {
            _password = nil;
        }
        
        if(msg !=nil){
            [_orderTakeBounced close];
            [ProgressHUD showInfo:msg withSucc:NO withDismissDelay:2];
            
        }
    }];

}

- (void)payWithPasswordByTimer:(NSTimer *)timer {
    NSDictionary *userInfoDic = timer.userInfo;
    NSDictionary *dic = userInfoDic[@"PayInfo"];
    NSString *password = userInfoDic[@"Password"];
    [self payWithPassword:password payInfo:dic];
}
-(void)agreementTouchUp{
    [CommonUtil  showReiciveOrderProtocalInController:self];
}
#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD hideProgressHUD];
    if (_orderTypeString != nil && ![_orderTypeString isEqualToString:@"[]"]) {
//        _orderTypeString = [NSString stringWithCString:[_orderTypeString cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        _orderTypeString = [_orderTypeString stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        _orderTypeString = [_orderTypeString stringByReplacingOccurrencesOfString:@";" withString:@","];
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initdata('%@')", [_orderTypeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    if (_type == 2) {
        [_webView stringByEvaluatingJavaScriptFromString:@"showforcast();"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD hideProgressHUD];
    [ProgressHUD showInfo:@"访问出错，请返回重试!" withSucc:NO withDismissDelay:2];
}
- (void)layoutSharedButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedBid)];
    [self setNavigationBarRightItem:rightItem];
}
- (void)sharedBid {
    ShareHelper *sharehelper=[[ShareHelper alloc] init];
    sharehelper.shareTitle=@"分享项目给好友";
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
//        1、创建分享参数
                NSString *url = [NSString stringWithFormat:@"%@&showdownload=1", _projectOrder.Url];
                NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
                if (imageArray) {
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@", _projectOrder.ProjectTitle, url]
                                                     images:imageArray
                                                        url:[NSURL URLWithString:url]
                                                      title:@"有新项目发布了"
                                                       type:SSDKContentTypeAuto];
        
                    [ShareSDK share:[[_sharePlatformSubType objectAtIndex:buttonIndex]integerValue] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                        NSLog(@"%@", error);
                        switch (state) {
                            case SSDKResponseStateSuccess:
                            {
                                [ProgressHUD showInfo:@"分享成功" withSucc:YES withDismissDelay:2];
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
