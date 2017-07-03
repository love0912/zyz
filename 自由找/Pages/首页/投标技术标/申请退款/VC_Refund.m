//
//  VC_Refund.m
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Refund.h"
#import "ProductService.h"

@interface VC_Refund ()
{
    ProductService *_productService;
    OrderInfoDomain *_orderInfo;
    NSMutableArray *_arr_refundReason;
//    NSString *_refundReasonKey;
//    NSDictionary *_reasonDic;
    NSMutableArray *_resonArr;
}
@end

@implementation VC_Refund

- (void)initData {
    _productService = [ProductService sharedService];
    _orderInfo = [self.parameters objectForKey:kPageDataDic];
//    _refundReasonKey = @"";
    _resonArr=[NSMutableArray array];
}

- (void)layoutUI {
    [self hideTableViewHeader:self.tableView];
    [self getRefundReason];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"申请退款";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)getRefundReason {
    [_productService getRefundReasonToResult:^(NSInteger code, NSArray<KeyValueDomain *> *reasons) {
        if (code == 1) {
            _arr_refundReason = [NSMutableArray arrayWithArray:reasons];
            [_tableView reloadData];
        } else {
//            [ProgressHUD showInfo:@"获取退款原因失败" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
//    _arr_refundReason = [NSMutableArray arrayWithCapacity:3];
//    for (int i = 0; i < 3; i++) {
//        KeyValueDomain *reason = [[KeyValueDomain alloc] init];
//        reason.Key = [NSString stringWithFormat:@"t_%d", i];
//        reason.Value = [NSString stringWithFormat:@"原因_%d", i+1];
//        [_arr_refundReason addObject:reason];
//    }
//    [_tableView reloadData];
    
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_refundReason.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Reason";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    KeyValueDomain *reason = [_arr_refundReason objectAtIndex:indexPath.row];
//    if ([_refundReasonKey isEqualToString:reason.Key]) {
//        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason_Sel"]];
//    } else {
//        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason"]];
//    }
    cell.textLabel.text = reason.Value;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason"]];
    for (int j = 0; j < _resonArr.count; j ++) {
        NSString *checkkeyString = _resonArr[j];
        if ([checkkeyString isEqualToString:reason.Key]) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason_Sel"]];
        }
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"退款原因";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyValueDomain *reason = [_arr_refundReason objectAtIndex:indexPath.row];
    if (![_resonArr containsObject:reason.Key]) {
        [_resonArr addObject:reason.Key];
    }else{
        [_resonArr removeObject:reason.Key];
    }
    [self reloadIndexPath:indexPath];
}
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - textview
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _lb_tv_tips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text.trimWhitesSpace isEmptyString]) {
        _lb_tv_tips.hidden = NO;
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

- (IBAction)btn_commit_pressed:(id)sender {
    if (_resonArr.count==0) {
        [ProgressHUD showInfo:@"请选择退款原因" withSucc:NO withDismissDelay:2];
        return;
    }
    [_productService refundOrderByID:_orderInfo.SerialNo reason:[_resonArr componentsJoinedByString:@","] description:_textView.text result:^(NSInteger code) {
        if (code == 1) {
            [ProgressHUD showInfo:@"提交申请成功，请耐心等待客服处理!" withSucc:NO withDismissDelay:3];
            [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
        }
    }];
}

- (void)back {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OrderDetail_Refresh object:nil];
    [self goBack];
}
@end
