//
//  VC_IncompanyDetail.m
//  自由找
//
//  Created by xiaoqi on 16/7/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_IncompanyDetail.h"
@interface VC_IncompanyDetail (){
  UserDomain *_userdomain;
    SiteDomain *_site;
}

@end

@implementation VC_IncompanyDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"企业详情";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadarrdata) name:@"RE_Deatil_DATA" object:nil];
    
    if (self.parameters != nil) {
        if([[self.parameters objectForKey:kPageType] integerValue] == 1) {
            [self rightItem_press];
        }
    }
}
-(void)reloadarrdata{
    [self loadData];
}
-(void)loadData{
    _userdomain=[CommonUtil getUserDomain];
    if (_userdomain.Sites != nil && _userdomain.Sites.count > 0) {
        _site = _userdomain.Sites.firstObject;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_site.Url]];
    [_web_comanyDetail loadRequest:request];
   
}
-(void)layoutUI{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"更正信息" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];
}
-(void)rightItem_press{
//    
//    if([_site.OwnerId isEqualToString:_userdomain.UserId]){
//        NSDictionary *dic=@{@"type":@(0)};
//        [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine parameters:dic  parent:self];
//        return;
//    }
    
//        if (_site.OwnerId == nil || ![_site.OwnerId isEqualToString:_userdomain.UserId] ) {
            if([_site.Status isEqualToString:@"REVIEWING"]){
                    [ProgressHUD showInfo:@"身份确认还在审核中！" withSucc:YES withDismissDelay:2];
            }else if ([_site.Status isEqualToString:@"NoReview"]){
                [JAlertHelper jAlertWithTitle:@"身份审核未通过，请重新上传企业资料！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [PageJumpHelper pushToVCID:@"VC_UploadCompany" storyboard:Storyboard_Mine parent:self];
        
                    }
                }];
            }else if ([_site.Status isEqualToString:@"CREATED"] && ![_site.OwnerId isEqualToString:_userdomain.UserId]){
                [JAlertHelper jAlertWithTitle:@"请重新上传企业资料！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [PageJumpHelper pushToVCID:@"VC_UploadCompany" storyboard:Storyboard_Mine parent:self];
                        
                    }
                }];
            }
            else {
                if (_site.OwnerId == nil || ![_site.OwnerId isEqualToString:_userdomain.UserId] ) {
                    [JAlertHelper jAlertWithTitle:@"为保证数据的准确性，请先上传营业执照或名片以确认你的身份！" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [PageJumpHelper pushToVCID:@"VC_UploadCompany" storyboard:Storyboard_Mine parent:self];
                            
                        }
                    }];
                }else if([_site.OwnerId isEqualToString:_userdomain.UserId]){
                    NSDictionary *dic=@{@"type":@(0)};
                   [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine parameters:dic  parent:self];
            }
        }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
