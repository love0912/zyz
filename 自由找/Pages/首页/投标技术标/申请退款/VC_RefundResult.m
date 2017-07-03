//
//  VC_RefundResult.m
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_RefundResult.h"
#import "ProductService.h"

@interface VC_RefundResult ()
{
    ProductService *_productService;
    OrderRefundDomain *_orderRefund;
    NSMutableArray *_arr_menu;
    NSMutableArray *_arr_refundReason;
    NSMutableString *resonString;
    CGFloat _contentLabelHeight;
}
@end

@implementation VC_RefundResult
- (void)initData {
    resonString=[NSMutableString stringWithFormat:@""];
    _productService = [ProductService sharedService];
    NSString *orderID = [self.parameters objectForKey:kPageDataDic];
    [_productService getRefundReasonToResult:^(NSInteger code, NSArray<KeyValueDomain *> *reasons) {
        if (code == 1) {
            _arr_refundReason = [NSMutableArray arrayWithArray:reasons];
            [_productService getRefundResultWithID:orderID result:^(NSInteger code, OrderRefundDomain *refundResult) {
                if (code == 1) {
                    _arr_menu = [NSMutableArray array];
                    _orderRefund=refundResult;
                    [_arr_menu addObject:@{kCellName:@"退款项目", kCellDefaultText: refundResult.ProjectName}];
                    [_arr_menu addObject:@{kCellName:@"退款时间", kCellDefaultText: (refundResult.RequestDt == nil ? @"" : refundResult.RequestDt)}];
                    [_arr_menu addObject:@{kCellName:@"退款原因", kCellDefaultText: [self getResonString]}];
                    if ([refundResult.Status isEqualToString:@"2"]) {
                        [_arr_menu addObject:@{kCellName:@"退款说明", kCellDefaultText: (refundResult.Feedback == nil ? @"" : refundResult.Feedback)}];
                    }
                    [self layoutHeaderByStatus:refundResult.Status];
                    
                }
            }];
        }
        
    }];
}
-(NSString *)getResonString{
    if (_orderRefund.Reason !=nil && ![_orderRefund.Reason isEmptyString]) {
        NSString *engineeringString=_orderRefund.Reason;
        NSArray *keyArray = [engineeringString componentsSeparatedByString:@","];
        for (KeyValueDomain *keyValue in _arr_refundReason) {
            for (NSString *keyStirng in keyArray) {
                if ([keyStirng isEqualToString:keyValue.Key]) {
                    [resonString appendString:[NSString stringWithFormat:@"%@\n",keyValue.Value]];
                }
            }
        }
    }
    return resonString;

}
- (void)layoutHeaderByStatus:(NSString *)status {
    [_tableView reloadData];
    NSString *imageName = @"";
    NSString *tips = @"";
    if ([status isEqualToString:@"1"]) {
        imageName = @"Order_Refund_Doing";
        tips = @"客服正在处理中...";
    } else if ([status isEqualToString:@"2"]) {
        imageName = @"Order_Refund_Fail";
        tips = @"退款失败";
    } else {
        imageName = @"Order_Refund_Success";
        tips = @"退款成功";
    }
    _imgv_tag.image = [UIImage imageNamed:imageName];
    _lb_tips.text = tips;
}

- (void)layoutUI {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"退款结果";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_RefundResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.numberOfLines=0;
    CGSize textSize = [tmpDic[kCellDefaultText] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    _contentLabelHeight = textSize.height + 10>20?textSize.height + 10:20;
    cell.detailTextLabel.text = tmpDic[kCellDefaultText];
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
