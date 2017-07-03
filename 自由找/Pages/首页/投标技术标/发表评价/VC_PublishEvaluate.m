//
//  VC_PublishEvaluate.m
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PublishEvaluate.h"
#import "JRateView.h"
#import "ProductService.h"

@interface VC_PublishEvaluate ()
{
    NSArray *_arr_reason;
    //上一次选中的评分
    CGFloat _preScore;
    ProductService *_productService;
    NSMutableArray *_resonArr;
    
    NSMutableArray *_arr_selectReasonValue;
    
    NSInteger _productType;
    
}
@end

@implementation VC_PublishEvaluate

- (void)initData {
    _arr_reason = @[];
    _preScore = 3.0f;
    _productService = [ProductService sharedService];

    _resonArr=[NSMutableArray array];
    _arr_selectReasonValue = [NSMutableArray arrayWithCapacity:0];
    _productType = [[self.parameters objectForKey:kPageType] integerValue];
}

- (void)layoutUI {
    [_v_star layoutIfNeeded];
    JRateView *rateView = [JRateView rateScoreWithFrame:_v_star.bounds paddingX:5 Score:0 isAnimation:YES allowIncompleteStar:YES rateScore:^(CGFloat score) {
        int intScore = floorf(score);
        CGFloat decimalScore = score - intScore;
        _lb_int.text = [NSString stringWithFormat:@"%d", intScore];
        NSString *decimalString = [NSString stringWithFormat:@"%.1f", decimalScore];
        _lb_decimal.text = [NSString stringWithFormat:@".%@", [decimalString componentsSeparatedByString:@"."].lastObject];
        if (score < 3.0f) {
            [_productService getCommentListToResult:^(NSInteger code, NSArray<KeyValueDomain *> *reasons) {
                if (code == 1) {
                    _arr_reason = [NSMutableArray arrayWithArray:reasons];
                    [_tableView reloadData];
                }
            }];
        } else {
            _arr_reason = @[];
        }
//        if ((_preScore > 3 && score < 3) || (_preScore < 3 && score > 3)) {
//            [_tableView reloadData];
//        }
        _preScore = score;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    rateView.isTap = YES;
    [_v_star addSubview:rateView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"发表评价";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_reason.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyValueDomain *reason = [_arr_reason objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell_Reason";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text =reason.Value;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason"]];
    for (int j = 0; j < _resonArr.count; j ++) {
        NSString *checkkeyString = _resonArr[j];
        if ([checkkeyString isEqualToString:reason.Key]) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Order_Reason_Sel"]];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyValueDomain *reason = [_arr_reason objectAtIndex:indexPath.row];
    if (![_resonArr containsObject:reason.Key]) {
        [_resonArr addObject:reason.Key];
        [_arr_selectReasonValue addObject:reason.Value];
    }else{
        [_resonArr removeObject:reason.Key];
        [_arr_selectReasonValue removeObject:reason.Value];
    }
    [self reloadIndexPath:indexPath];
    
}
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_arr_reason.count == 0) {
        return 1;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_arr_reason.count == 0) {
        return 1;
    }
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_arr_reason.count == 0) {
        return @"";
    }
    return @"选择原因";
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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_anonymous_pressed:(id)sender {
    self.btn_anonymous.selected = !self.btn_anonymous.selected;
}
- (IBAction)btn_commit_evaluation_press:(id)sender {
    if (_textView.text ==nil) {
        _textView.text=@"";
    }
    NSMutableString *reasonValueMutableString = [NSMutableString string];
    for (NSString *tmpString in _arr_selectReasonValue) {
        [reasonValueMutableString appendString:tmpString];
        [reasonValueMutableString appendString:@","];
    }
    [reasonValueMutableString appendString:_textView.text];
    
    NSString *isAnonymous;
    if (self.btn_anonymous.selected==YES) {
        isAnonymous=@"1";
    }else{
        isAnonymous=@"0";
    }
    NSString *resonString;
    if (_resonArr ==nil || _resonArr.count==0) {
        resonString=@"";
    }else{
        resonString=[_resonArr componentsJoinedByString:@","];
    }
    if (_preScore == 0.00) {
        [ProgressHUD showInfo:@"请输入评分" withSucc:NO withDismissDelay:2];
    }else{
        if (_preScore < 3.0f && _resonArr.count==0) {
            [ProgressHUD showInfo:@"请选择您的理由" withSucc:NO withDismissDelay:2];
        }else{
            if (_productType == 3) {
                [_productService evaluateProductWithProductID:self.parameters[kPageDataDic] productType:3 score:[NSString stringWithFormat:@"%f",_preScore] reason:resonString  content:reasonValueMutableString isAnonymous:isAnonymous result:^(NSInteger code) {
                    if (code==1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterDetail" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VC_PublishEvaluate" object:nil];
                        [ProgressHUD showInfo:@"评价成功" withSucc:YES withDismissDelay:2];
                        [self goBack];
                    }
                }];
            } else {
                [_productService evaluateProductWithProductID:self.parameters[kPageDataDic] score:[NSString stringWithFormat:@"%f",_preScore] reason:resonString  content:reasonValueMutableString isAnonymous:isAnonymous result:^(NSInteger code) {
                    if (code==1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OrderDetail_Refresh object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VC_PublishEvaluate" object:nil];
                        [ProgressHUD showInfo:@"评价成功" withSucc:YES withDismissDelay:2];
                        [self goBack];
                    }
                    
                }];
            }

        }
        
    
    }
}

@end
