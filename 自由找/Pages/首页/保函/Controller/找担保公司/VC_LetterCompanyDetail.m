//
//  VC_LetterCompanyDetail.m
//  zyz
//
//  Created by 郭界 on 17/1/9.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_LetterCompanyDetail.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "LetterCompanyDomain.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "BaseService.h"
#import "Cell_LetterCompanyDesc.h"
#import "JZAlbumViewController.h"

@interface VC_LetterCompanyDetail ()<CellLetterCompanyDescDelegate>
{
    NSArray *_sharePlatformSubType;
    LetterCompanyDomain *_company;
    
    NSMutableArray *_arr_menu;
    BaseService *_baseService;
}
@end

@implementation VC_LetterCompanyDetail

- (void)initData {
    _baseService = [BaseService sharedService];
    
    _company = [self.parameters objectForKey:kPageDataDic];
    _sharePlatformSubType=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeQQFriend],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatSession],[NSString stringWithFormat:@"%lu",SSDKPlatformSubTypeWechatTimeline],[NSString stringWithFormat:@"%lu",SSDKPlatformTypeSMS], nil];
    
    _arr_menu = [NSMutableArray arrayWithCapacity:11];
    
    [self addInputByName:@"公司名称" detailText:_company.Name type:0];
    [self addInputByName:@"经营类别" detailText:_company.BusinessCategory[kCommonValue] type:0];
    if ([_company.BusinessCategory[kCommonKey] isEqualToString:@"1"]) {
        [self addInputByName:@"代打额度" detailText:_company.LimitPrice type:0];
        self.jx_title = @"投资公司详情";
    } else {
        [self addInputByName:@"保函额度" detailText:_company.LimitPrice type:0];
        self.jx_title = @"担保公司详情";
    }
    [self addInputByName:@"费    率" detailText:_company.FeeValue type:0];
    [self addInputByName:@"经营范围" detailText:_company.Scope type:0];
    [self addInputByName:@"经营区域" detailText:_company.RegionTitle type:0];
    [self addInputByName:@"联 系 人" detailText:_company.Contact type:0];
    [self addInputByName:@"联系电话" detailText:_company.Phone type:1];
    [self addInputByName:@"公司地址" detailText:_company.Address type:0];
    [self addInputByName:@"公司官网" detailText:_company.Url type:2];
//    [self addInputByName:@"公司简介" detailText:_company.Description type:0];
    
    NSMutableDictionary *descDic = [NSMutableDictionary dictionaryWithDictionary:@{kCellName: @"公司简介", kCellDefaultText:(_company.Description == nil ? @"": _company.Description), kCellEditType: @(3)}];
    if (_company.ImgUrls.isNotEmptyString) {
        NSArray *imgUrls = [_company.ImgUrls componentsSeparatedByString:@","];
        [descDic setObject:imgUrls forKey:@"ImgUrl"];
    }
    [_arr_menu addObject:descDic];
}

- (void)addInputByName:(NSString *)name detailText:(NSString *)detailText type:(NSInteger)type {
    [_arr_menu addObject:@{kCellName: name, kCellDefaultText:(detailText == nil ? @"": detailText), kCellEditType: @(type)}];
}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedPressed)];
    [self setNavigationBarRightItem:rightItem];
    
    [self hideTableViewFooter:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"担保公司详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    static NSString *CellID2 = @"Cell_Website";
    static NSString *CellID3 = @"Cell_LetterCompanyDesc";
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    NSInteger type = [tmpDic[kCellEditType] integerValue];
    if (type == 3) {
        Cell_LetterCompanyDesc *cellDesc = [tableView dequeueReusableCellWithIdentifier:CellID3];
        cellDesc.dataDic = tmpDic;
        cellDesc.delegate = self;
        return cellDesc;
    }
    
    UITableViewCell *cell;
    if (type == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:tmpDic[kCellDefaultText]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        cell.detailTextLabel.attributedText = content;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        cell.detailTextLabel.text = tmpDic[kCellDefaultText];
    }
    if (type == 1) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bh_call"]];
        NSString *phone = tmpDic[kCellDefaultText];
        if ([phone isNotEmptyString]) {
            phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        cell.detailTextLabel.text = phone;
    } else {
        cell.accessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    cell.textLabel.text = tmpDic[kCellName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    NSInteger type = [tmpDic[kCellEditType] integerValue];
    CGFloat height = 48;
    if (type == 3) {
        height = [tableView fd_heightForCellWithIdentifier:@"Cell_LetterCompanyDesc" cacheByIndexPath:indexPath configuration:^(Cell_LetterCompanyDesc *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
        if (height < 48) {
            height = 48;
        }
    }
    return height;
}

- (void)configureCell:(Cell_LetterCompanyDesc *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    cell.dataDic = tmpDic;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    NSInteger type = [tmpDic[kCellEditType] integerValue];
    NSString *text = tmpDic[kCellDefaultText];
    if (type == 1) {
        [CommonUtil callWithPhone:text];
        [_baseService countCallWithType:3 recordID:_company.OId direction:0 phone:text];
        
    } else if (type == 2) {
        if ([text hasPrefix:@"www"]) {
            text = [NSString stringWithFormat:@"http://%@", text];
        }
        [CommonUtil jxWebViewShowInController:self loadUrl:text backTips:@""];
    }
}

- (void)showBigImageByImageUrlString:(NSString *)imgUrl {
    JZAlbumViewController *jzAlbum = [[JZAlbumViewController alloc] init];
    jzAlbum.currentIndex = 0;//这个参数表示当前图片的index，默认是0
    //    jzAlbum.imgArr = [NSMutableArray arrayWithObject:(_bidLetter.NormalUrl == nil ? @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1209/10/c1/13758581_1347257278695.jpg" : _bidLetter.NormalUrl)];
    jzAlbum.imgArr = [NSMutableArray arrayWithObject:imgUrl];
    [self presentViewController:jzAlbum animated:YES completion:nil];
}

#pragma mark - shared 
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
        NSString *url = [NSString stringWithFormat:@"%@", _company.ShareUrl];
        NSArray* imageArray = @[[UIImage imageNamed:@"sharedImage"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@""]
                                             images:imageArray
                                                url:[NSURL URLWithString:url]
                                              title:_company.Name
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
    // Dispose of any resources that can be recreated.
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
