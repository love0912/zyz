//
//  VC_CompanyDetail.m
//  自由找
//
//  Created by guojie on 16/7/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CompanyDetail.h"
#import "BaseService.h"
#import "NewQueryService.h"
#import "VC_Choice.h"
#import "InCompanyService.h"

@interface VC_CompanyDetail ()
{
    NSString *_urlString;
    BaseService *_baseService;
    NewQueryService *_queryService;
    NSString *_companyID;
    NSString *_companyName;
    InCompanyService *_inCompanyService;
}

@end

@implementation VC_CompanyDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"企业详情";
    [self zyzOringeNavigationBar];
    _inCompanyService=[InCompanyService sharedService];
    _urlString = @"";
    if (self.parameters != nil) {
        _urlString = [self.parameters objectForKey:kPageDataDic];
        _companyID = [self.parameters objectForKey:kCompanyID];
        _companyName = [self.parameters objectForKey:kCompanyName];
    }
    _baseService = [BaseService sharedService];
    
    [self showWebContent];
    _queryService = [NewQueryService sharedService];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebContent) name:@"Reload_Company_Detail" object:nil];
}

- (void)showWebContent {
    
    if ([_urlString isEmptyString]) {
        [ProgressHUD showInfo:@"查看企业详情失败" withSucc:NO withDismissDelay:2];
        [self goBack];
    } else {
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
//        [_baseService getHtmlStringWithUrl:_urlString success:^(id responseObject) {
//            NSString *htmlString = responseObject;
//            [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:HTML_BASE_HOST]];
//        } fail:^{
//            
//        }];
        [ProgressHUD showProgressHUDWithInfo:@""];
        NSURL *url = [NSURL URLWithString:_urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ProgressHUD hideProgressHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [ProgressHUD hideProgressHUD];
    [ProgressHUD showInfo:@"访问出错，请返回重试!" withSucc:NO withDismissDelay:2];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *pathString=[[request URL] absoluteString];
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        if ([pathString hasPrefix:@"tel:"]) {
            [CountUtil countSearchViewDetailCall];
            
            NSMutableString *checkString=[NSMutableString stringWithFormat:@"%@",pathString];
            [checkString deleteCharactersInRange:NSMakeRange(0,4)];
            [_baseService countCallWithType:0 recordID:_companyID direction:0 phone:checkString];
        }
    }
    NSString *urlString=[[request URL] absoluteString];
    NSRange range = [urlString rangeOfString:@"zyz://"];
    NSUInteger loc = range.location;
    if (loc != NSNotFound) {
        if ([urlString hasPrefix:@"zyz://edit"]) {
            [self editCompanyWithUrlOfString:urlString];
        } else if ([urlString hasPrefix:@"zyz://details"]) {
            [self viewDetail];
        }
        return NO;
    }
    
    return YES;
}

- (void)editCompanyWithUrlOfString:(NSString *)urlString {
    if ([urlString hasSuffix:@"true"]) {
        //是企业所有者
        NSDictionary *dic=@{@"type":@(0), kPageType:@4};
        [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine parameters:dic  parent:self];
    } else {
        [JAlertHelper jAlertWithTitle:@"绑定后，你的电话在该企业详情展示，在我的里面删除，是否继续?" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [_queryService getAlisRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
                    if (code != 1) {
                        return;
                    }
                    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
                    vc_choice.nav_title = @"请选择经营区域";
                    NSMutableArray *selectArray = [NSMutableArray array];
                    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
                    KeyValueDomain *native = dataArray.firstObject;
                    if ([native.Key isEqualToString:@"0"]) {
                        [dataArray removeObjectAtIndex:0];
                    }
                    [vc_choice setDataArray:dataArray selectArray:selectArray];
                    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
                        NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObject:resultDic forKey:@"Region"];
                        [paramDic setObject:_companyID forKey:@"CompanyOId"];
                        [paramDic setObject:@"" forKey:@"ImgUrl"];
                        [_inCompanyService updateFromCompanyWithParameters:paramDic result:^(NSUInteger code) {
                            if (code != 1) {
                                return;
                            }
                            [JAlertHelper jAlertWithTitle:@"为保证数据的准确性，请先上传营业执照或名片以确认你的身份！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    [paramDic setObject:@1 forKey:kPageType];
                                    [PageJumpHelper pushToVCID:@"VC_UploadCompany" storyboard:Storyboard_Mine parameters:paramDic parent:self];
                                }
                            }];
                        }];
                    };
                    [self.navigationController pushViewController:vc_choice animated:YES];
                }];
            }
        }];
    }
}

- (void)viewDetail {
    [_queryService getProjectPerformanceWithSearchType:0 name:nil companyOId:_companyID page:1 result:^(NSArray<PerformanceDoamin *> *performList, NSInteger code) {
        if (code != 1) {
            return;
        }
        if (performList.count == 0) {
            [ProgressHUD showInfo:@"没有查询到数据!" withSucc:NO withDismissDelay:2];
            return;
        }
        [PageJumpHelper pushToVCID:@"VC_PerformanceList" storyboard:Storyboard_Main parameters:@{kPageDataDic:performList, kPage:@(1), @"CompanyOId": _companyID} parent:self];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
