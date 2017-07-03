//
//  VC_InEnterprise.m
//  自由找
//
//  Created by xiaoqi on 16/6/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_InEnterprise.h"
#import "Cell_InEnterprise.h"
#import "MineService.h"
static NSString *CellIdentifier = @"Cell_InEnterpriser";

@interface VC_InEnterprise (){
   CGFloat _cellHeight;
    UserDomain *_userdomain;
    MineService *_mineService;
    NSMutableArray *_arr_data;
    
    NSString *_companyName;
    //1 -- 从资质查询详情页跳转进入
    NSInteger _type;
    BOOL _shouldToDetail;
    
    UIBarButtonItem *_rightItem;

}

@end

@implementation VC_InEnterprise

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"企业展示";
    [self zyzOringeNavigationBar];

    [self initData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadarrdata) name:@"RE_ARR_DATA" object:nil];
    
    _companyName = [self.parameters objectForKey:kPageDataDic];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    
    _shouldToDetail = NO;
    if (_type == 1) {
        [self fromCompanyDetail];
    }

}

- (void)fromCompanyDetail {
    if (_arr_data.count>0) {
//        [JAlertHelper jAlertWithTitle:@"亲，您已经添加了一家企业，继续操作将替换您已经添加的企业，是否继续？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                NSDictionary *dic=@{@"type":@(0), kPageDataDic:_companyName, kPageType:@3};
//                [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine  parameters:dic  parent:self];
//                
//            }
//        }];
        [JAlertHelper jAlertWithTitle:@"亲，最多只能添加三家企业." message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
    }else{
        
        NSDictionary *dic=@{@"type":@(1), kPageDataDic:_companyName, kPageType:@3};
        [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine  parameters:dic  parent:self];
    }
}

-(void)layoutUI{
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加企业" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    _rightItem.tintColor=[UIColor whiteColor];
    [_rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];
    [self setNavigationBarRightItem:_rightItem];
    _tableView.rowHeight=50;
    [self hideTableViewFooter:_tableView];
    
}
-(void)reloadarrdata{
    [self initData];
    [_tableView reloadData];
    
    if (_type == 1) {
        _shouldToDetail = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (_shouldToDetail) {
        _shouldToDetail = NO;
        [PageJumpHelper pushToVCID:@"VC_IncompanyDetail" storyboard:Storyboard_Mine parameters:@{kPageType:@1}  parent:self];
    }
    [self changeRightItemText];
}

- (void)changeRightItemText {
    if (_arr_data.count == 0) {
        [_rightItem setTitle:@"添加企业"];
    } else {
        [_rightItem setTitle:@"继续添加"];
    }
}

-(void)initData{
    _arr_data=[NSMutableArray array];
     _userdomain=[CommonUtil getUserDomain];
    [_arr_data addObjectsFromArray:_userdomain.Sites];
     _mineService=[MineService sharedService];
    NSRange range = [_lb_two.text rangeOfString:@"“添加企业”"];
    [CommonUtil setTextColor:_lb_two FontNumber:[UIFont systemFontOfSize:15] AndRange:range AndColor:[UIColor colorWithHex:@"ff7b23"]];
    if (_userdomain.Sites.count==0 ) {
        _tableView.hidden=YES;
//        _iv_tishi.hidden=YES;
//        _lb_tishiF.hidden=YES;
//        _lb_tishiS.hidden=YES;
        _iv_empty.hidden=NO;
        _lb_one.hidden=NO;
        _lb_two.hidden=NO;
       
    }else{
//        _iv_tishi.hidden=NO;
//        _lb_tishiF.hidden=NO;
//        _lb_tishiS.hidden=NO;
        _tableView.hidden=NO;
        _iv_empty.hidden=YES;
        _lb_one.hidden=YES;
        _lb_two.hidden=YES;
    }
    _lb_tishiS.text=@"1、如果您添加的企业是平台中没有的企业，审核通过后，将在资质查询中展示您企业的资质和联系方式。\n2、如果企业信息有误，可以更正信息，第一次更改信息时，需进行身份认证，认证后，您将作为该企业的联系人在资质查询中进行展示。\n3、企业展示内最多可添加3家公司。";
   
}
-(void)rightItem_press{
    if (_arr_data.count>2) {
//        [JAlertHelper jAlertWithTitle:@"亲，您已经添加了一家企业，继续操作将替换您已经添加的企业，是否继续？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                NSDictionary *dic=@{@"type":@(1)};
//                [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine  parameters:dic  parent:self];
////                [PageJumpHelper pushToVCID:@"VC_AddCompany" storyboard:Storyboard_Mine   parent:self];
//                
//            }
//        }];
        [JAlertHelper jAlertWithTitle:@"亲，最多只能添加三家企业." message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
    }else{

         NSDictionary *dic=@{@"type":@(1)};
        [PageJumpHelper pushToVCID:@"VC_AddEditCompany" storyboard:Storyboard_Mine  parameters:dic  parent:self];

//      [PageJumpHelper pushToVCID:@"VC_AddCompany" storyboard:Storyboard_Mine   parent:self];
    }
    
}
#pragma mark - tableviewx datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SiteDomain *site=[_arr_data objectAtIndex:indexPath.row];
    Cell_InEnterprise*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.sits=site;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [PageJumpHelper pushToVCID:@"VC_IncompanyDetail" storyboard:Storyboard_Mine  parent:self];

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView

           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_mineService unbindCompanyToResult:^(NSInteger code) {
            if (code==1) {
                [_arr_data removeObjectAtIndex:indexPath.row];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView endUpdates];
                if (_arr_data.count==0) {
                    _tableView.hidden=YES;
//                    _iv_tishi.hidden=YES;
//                    _lb_tishiF.hidden=YES;
//                    _lb_tishiS.hidden=YES;
                    _iv_empty.hidden=NO;
                    _lb_one.hidden=NO;
                    _lb_two.hidden=NO;
                }
                [self changeRightItemText];
            }
        }];
       
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_SECTION2_NOTIFICATION" object:nil];
    [self goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
////设置不同字体颜色
//-(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
//{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
//    //设置字号
//    [str addAttribute:NSFontAttributeName value:font range:range];
//    //设置文字颜色
//    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
//    
//    label.attributedText = str;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
