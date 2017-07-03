//
//  VC_PaymentDeatails.m
//  自由找
//
//  Created by xiaoqi on 16/9/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PaymentDeatails.h"
static NSString *cellID=@"Cell_PaymentDeatails";
@interface VC_PaymentDeatails (){
    NSArray *_arr_Input;
    CGFloat _contentLabelHeight;
    NSInteger _type;//1-付款，2-扣款
    WalletRecordDomain *_walletRecordDomain;
}

@end

@implementation VC_PaymentDeatails

- (void)viewDidLoad {
    [super viewDidLoad];
    _type=[self.parameters[kPageType]integerValue];
    if (_type==1) {
         self.jx_title = @"收款详情";
    }else{
        self.jx_title = @"扣款详情";
    }
    _walletRecordDomain=[self.parameters objectForKey:@"WalletRecordDomain"];
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
}
-(void)loadData{
    if (_type==1) {
        _arr_Input = @[
                       @{kCellKey: kMyorderPaymentTime, kCellName: @"收款时间", kCellDefaultText: _walletRecordDomain.CreateDt == nil ? @"" :_walletRecordDomain.CreateDt},
                       @{kCellKey: kMyorderPaymentMoney, kCellName: @"收款金额", kCellDefaultText:_walletRecordDomain.Amount == nil ? @"" :[NSString stringWithFormat:@"￥%@",_walletRecordDomain.Amount]},
                       @{kCellKey: kMyorderPaymentDescription, kCellName: @"备注", kCellDefaultText: _walletRecordDomain.Description == nil ? @"" :_walletRecordDomain.Description}
                       
                       ];

    }else{
        _arr_Input = @[
                       @{kCellKey: kMyorderDeductionsTime, kCellName: @"扣款时间", kCellDefaultText: _walletRecordDomain.CreateDt == nil ? @"" :_walletRecordDomain.CreateDt},
                       @{kCellKey: kMyorderDeductionsMoney, kCellName: @"扣除保证金", kCellDefaultText: _walletRecordDomain.Amount == nil ? @"" :[NSString stringWithFormat:@"￥%@",_walletRecordDomain.Amount]},
                       @{kCellKey: kMyorderDeductionsDescription, kCellName: @"扣款说明", kCellDefaultText: _walletRecordDomain.Description == nil ? @"" :_walletRecordDomain.Description}
                       
                       ];
    }
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *name = dic_input[kCellName];
    NSString *text = dic_input[kCellDefaultText];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
    cell.textLabel.text = name;
    cell.detailTextLabel.text = text;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_contentLabelHeight>44) {
        return _contentLabelHeight;
    }else{
        return 44;
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
