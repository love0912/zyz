//
//  VC_Authen.m
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Authen.h"
#import "ProducerService.h"
#import "AuthenLetterService.h"

@interface VC_Authen ()
{
    NSMutableArray *_arr_menu;
    ProducerService *_producerService;
    AuthenLetterService *_authenLetterService;
    ProducerDomain *_producer;
}
@end

@implementation VC_Authen

- (void)initData {
    _arr_menu = [NSMutableArray arrayWithArray:@[
                  @{kCellName: @"接单认证", kCellKey: @"JIEDAN", kCellDefaultText: @" "},
                  @{kCellName: @"保函认证", kCellKey: @"BAOHAN", kCellDefaultText: @" "}
                  ]];
    _producerService = [ProducerService sharedService];
    _authenLetterService = [AuthenLetterService sharedService];
}

- (void)layoutUI {
    [self hideTableViewFooter:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshloadCer) name:@"RE_Certification_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLetterAuth) name:@"Notification_Refresh_LetterAuth" object:nil];
    
    [self loadCer:0];
    [self refreshLetterAuth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我要认证";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Authen";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = _arr_menu[indexPath.row];
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.text = tmpDic[kCellDefaultText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = _arr_menu[indexPath.row];
    if ([tmpDic[kCellKey] isEqualToString:@"JIEDAN"]) {
        [self loadCer:1];
    } else {
        [self pushToAuthenLetter];
    }
}


-(void)loadCer:(NSInteger)touchType{
    if ([CommonUtil isLogin]) {
        [ProgressHUD showProgressHUDWithInfo:@""];
        //            查看认证信息
        [_producerService getSelfInfoToResult:^(NSInteger code, ProducerDomain *producer) {
            if (code==1) {
                _producer=producer;
                
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[_arr_menu objectAtIndex:0]];
                if (producer!=nil && producer.ProductLevel.Value !=nil && [producer.AuthStatus integerValue]==2) {
                    [dic setValue:producer.ProductLevel.Value forKey:kCellDefaultText];
                }else if([producer.AuthStatus integerValue]==4){
                    [dic setValue:@"未通过" forKey:kCellDefaultText];
                }else if([producer.AuthStatus integerValue]==1){
                    [dic setValue:@"审核中" forKey:kCellDefaultText];
                }else if([producer.AuthStatus integerValue]==0){
                    [dic setValue:@"编制资料人员在此认证" forKey:kCellDefaultText];
                }
                [_arr_menu replaceObjectAtIndex:0 withObject:dic];
                //                    [self reloadIndexSelction:2];
                [self.tableView reloadData];
                if (touchType==1) {
                    if (producer!=nil) {
                        if([producer.AuthStatus integerValue]==1){
                            [ProgressHUD showInfo:@"正在审核中，请耐心等待..." withSucc:NO withDismissDelay:2];
                        }else{
                            [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{@"producerdomian":producer,kPageType:@"0"} parent:self];
                        }
                    }else{
                        [PageJumpHelper pushToVCID:@"VC_Certification" storyboard:Storyboard_Mine parameters:@{kPageType:@"0"} parent:self];
                    }
                }
                
            }else{
                if (touchType==1) {
                    [ProgressHUD showInfo:@"获取数据失败，请稍后重试！" withSucc:NO withDismissDelay:2];
                }
            }
        }];
    }else{
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[_arr_menu objectAtIndex:1]];
        [dic setValue:@"" forKey:kCellDefaultText];
        [_arr_menu replaceObjectAtIndex:0 withObject:dic];
        [_tableView reloadData];
        if (touchType==1) {
            [PageJumpHelper presentLoginViewController];
        }
        
    }
    
}

- (void)pushToAuthenLetter {
    [_authenLetterService getAuthenInfoResult:^(AuthenLetterDomain *authenLetter, NSInteger code) {
        if (code == 1) {
            [PageJumpHelper pushToVCID:@"VC_AuthenLetter" storyboard:Storyboard_Mine parameters:@{kPageDataDic: authenLetter} parent:self];
        }
    }];
}

- (void)refreshLetterAuth {
    [_authenLetterService getAuthenInfoResult:^(AuthenLetterDomain *authenLetter, NSInteger code) {
        if (code == 1) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[_arr_menu objectAtIndex:1]];
            if ([authenLetter.AuthStatus integerValue]==2) {
                [dic setValue:@"已认证" forKey:kCellDefaultText];
            }else if([authenLetter.AuthStatus integerValue]==4){
                [dic setValue:@"未通过" forKey:kCellDefaultText];
            }else if([authenLetter.AuthStatus integerValue]==1){
                [dic setValue:@"审核中" forKey:kCellDefaultText];
            }else if([authenLetter.AuthStatus integerValue]==0){
                [dic setValue:@"担保公司人员在此认证" forKey:kCellDefaultText];
            }
            [_arr_menu replaceObjectAtIndex:1 withObject:dic];
            [self.tableView reloadData];
        }
    }];
}

-(void)refreshloadCer{
    [self loadCer:0];
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
