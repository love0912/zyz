//
//  VC_NewBidLetterBuy.m
//  zyz
//
//  Created by 郭界 on 16/12/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_NewBidLetterBuy.h"
#import "LetterOrderDomain.h"
#import "BidLetterDomain.h"
#import "LetterPriceDomain.h"
#import "LetterService.h"
#import "LetterAddressService.h"
#import <UIImageView+WebCache.h>
#import "VC_TextField.h"
#import "BSModalDatePickerView.h"
#import "PayService.h"
#import "LPTradeView.h"
#import "LetterOrderDetailDomain.h"

#define CellSectionTitle @"CellSectionTitle"

@interface VC_NewBidLetterBuy ()
{
    //0 -- 购买, 1 -- 代付款订单，不允许输入
    NSInteger _type;
    
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    NSInteger _count;
    NSInteger _letterType;
    NSInteger _exchangeType;
    BidLetterDomain *_bidLetter;
    LetterService *_letterService;
    LetterAddressService *_letterAddressService;
    LetterPriceDomain *_letterPrice;
    LetterAddressDomain *_letterAddress;
    NSArray *_arr_price;
    CGFloat _totalPrice;
    
    
    NSString *_password;
    Boolean _isNotification;
    NSInteger _payCount;
    NSTimer *_payTimer;
    Boolean _isContinuePay;
    NSString *_orderID;
    NSString *_PayFee;
    PayService *_payService;
    
    //是否是手机端支付
    BOOL _isPhonePay;
    //是否生成了订单
    BOOL _isCreatedOrder;
    
    LetterOrderDetailDomain *_letterDetail;
}
@end

@implementation VC_NewBidLetterBuy

- (void)initData {
    _arr_input = @[
                   @{kCellEditType: CellSectionTitle, kCellName: @"需要保函的招标项目信息"},
                   @{kCellKey: @"ProjectOwner", kCellEditType: EditType_TextField, kCellName: @"招标人", kCellDefaultText: @"请输入招标人单位名称"},
                   @{kCellKey: @"ProjectCompany", kCellEditType: EditType_TextField, kCellName: @"投标企业", kCellDefaultText: @"请输入投标企业名称"},
                   @{kCellKey: @"ProjectTitle", kCellEditType: EditType_TextField, kCellName: @"项目名称", kCellDefaultText: @"请输入项目名称"},
                   @{kCellKey: @"MaterialDt", kCellEditType: EditType_DatePicker, kCellName: @"平台提交\n保函时间", kCellDefaultText: @"您需要自由找最迟提交保函时间"}
                   ];
    
    _count = 1;
    
    _letterType = 0;
    _exchangeType = 0;
    
    _bidLetter = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"BidLetter"];
    _letterAddress = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"LetterAddress"];
    //查询阶梯价格
    [self getPriceList];
    
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:0];
    
    _isNotification = NO;
    
    _isCreatedOrder = NO;
    
}

- (void)layoutUI {
    [self reloadAddress];
    
    _lb_letterName.text = _bidLetter.Name;
    [_iv_logo sd_setImageWithURL:[NSURL URLWithString:[_bidLetter.LogoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_iv_background sd_setImageWithURL:[NSURL URLWithString:[_bidLetter.LogoBackgroundUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"bidLetterBackground"]];
    NSString *bankCity = [NSString stringWithFormat:@"%@", _bidLetter.SubBank];
    _lb_bankCity.text = bankCity;
    
    _lb_custom_tips.text = [NSString stringWithFormat:@"我们首先将您上传的保函格式提交到%@审核，如果审核不通过，在保证费用不变的情况下", _bidLetter.Bank];
    
    if ([_bidLetter.PayMode isEqualToString:@"1"]) {
        _lb_priceTag.text = @"费率";
        double textfloat = [_bidLetter.PayParameter floatValue] * 100;
        _lb_price.text = [NSString stringWithFormat:@"%@%%起", [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%lf", textfloat]]];
        
    } else {
        _lb_priceTag.text = @"价格";
        _lb_price.text = [self getBasePrice];
        _lb_expression.hidden = YES;
    }
    _lb_totalPrice.text = @"￥0元";
    
    UITapGestureRecognizer *moneyInputTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputMoney)];
    [_v_inputBack addGestureRecognizer:moneyInputTap];
    
    [self setCount:_count];
    [self setLetterWithType:_letterType];
    [self setExchangeBankWithType:_exchangeType];
    
    if (IS_IPHONE_5_OR_LESS) {
        UIFont *font = [UIFont systemFontOfSize:12];
        _lb_choiceLetterType.font = _lb_setCount.font = _lb_exchangeBank.font = _lb_totalPrice.font = font;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress:) name:@"Notification_Change_Address" object:nil];
    
    
    _btn_agree.selected = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"确认订单";
    _payService = [PayService sharedService];
    _letterService = [LetterService sharedService];
    _letterAddressService = [LetterAddressService sharedService];

    
    _type = [[self.parameters objectForKey:@"StatusType"] integerValue];
    if (_type == 1) {
        _letterDetail = [self.parameters objectForKey:kPageDataDic];
        [self layoutNotPayView];
        
    } else {
        [self initData];
        [self layoutUI];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPayOrder) name:Notification_RePay_BidLetter object:nil];
}

- (NSString *)notNil:(NSString *)orNilString {
    if (orNilString == nil) {
        return @"";
    }
    return orNilString;
}

- (void)layoutNotPayView {
    _btn_payToPc.hidden = NO;
    _layout_total_right.constant = 10;
    
    
    _lb_userName.text = [self notNil:_letterDetail.AddressInfo[@"Recipient"]];
    _lb_phone.text = [self notNil:_letterDetail.AddressInfo[@"Phone"]];
    _lb_street.text = [self notNil:_letterDetail.AddressInfo[@"Street"]];
    _btn_addressChoice.enabled = NO;
    _lb_letterName.text = [self notNil:_letterDetail.ProductName];
    _lb_bankCity.text = _letterDetail.SubBank;
    
    if ([_letterDetail.PayMode isEqualToString:@"1"]) {
        _lb_priceTag.text = @"费率";
        CGFloat price = _letterDetail.PayParameter.floatValue * 100;
        NSString *test = [NSString stringWithFormat:@"%f", price];
        NSString *value = [CommonUtil removeFloatAllZero:test];
        _lb_price.text = [NSString stringWithFormat:@"%@%%", value];
    } else {
        _lb_priceTag.text = @"价格";
        _lb_price.text = [NSString stringWithFormat:@"%@元", [CommonUtil removeFloatAllZero:_letterDetail.PayParameter]];
        _lb_expression.hidden = YES;
    }
    _btn_viewPriceDetail.hidden = YES;
    _tf_money.text = [NSString stringWithFormat:@"%lf", _letterDetail.PerAmount.doubleValue / 10000];
    _tf_money.enabled = NO;
    _tf_count.text = _letterDetail.Quantity;
    _tf_count.enabled = NO;
    _btn_addCount.enabled = NO;
    _btn_subCount.enabled = NO;
    
    NSInteger letterType = _letterDetail.IsChangeBank.integerValue;
    _v_changeBank_back.hidden = YES;
    CGSize size = self.v_top.frame.size;
    if (letterType == 0) {
        [_btn_letterType_normal setImage:[UIImage imageNamed:@"Order_Reason_Sel"] forState:UIControlStateDisabled];
        size.height = 468;
    } else {
        [_btn_letterType_custom setImage:[UIImage imageNamed:@"Order_Reason_Sel"] forState:UIControlStateDisabled];
        size.height = 552;
        _v_changeBank_back.hidden = NO;
    }
    self.v_top.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setTableHeaderView:self.v_top];// 关键是这句话
    _btn_letterType_custom.enabled = NO;
    _btn_letterType_normal.enabled = NO;
    NSInteger bankType = _letterDetail.BaoHanStyle.integerValue;
    if (bankType == 0) {
        [_btn_exchange_yes setImage:[UIImage imageNamed:@"Order_Reason_Sel"] forState:UIControlStateDisabled];
    } else {
        [_btn_exchange_no setImage:[UIImage imageNamed:@"Order_Reason_Sel"] forState:UIControlStateDisabled];
    }
    _btn_exchange_yes.enabled = NO;
    _btn_exchange_no.enabled = NO;
    _arr_input = @[
                   @{kCellEditType: CellSectionTitle, kCellName: @"需要保函的招标项目信息"},
                   @{kCellKey: @"ProjectOwner", kCellEditType: EditType_TextField, kCellName: @"招标人", kCellDefaultText: [self notNil:_letterDetail.ProjectOwner]},
                   @{kCellKey: @"ProjectCompany", kCellEditType: EditType_TextField, kCellName: @"投标企业", kCellDefaultText: [self notNil:_letterDetail.ProjectCompany]},
                   @{kCellKey: @"ProjectTitle", kCellEditType: EditType_TextField, kCellName: @"项目名称", kCellDefaultText: [self notNil:_letterDetail.ProjectTitle]},
                   @{kCellKey: @"MaterialDt", kCellEditType: EditType_DatePicker, kCellName: @"平台提交\n保函时间", kCellDefaultText: [self notNil:_letterDetail.MaterialDt]}
                   ];
    _tf_remark.text = [self notNil:_letterDetail.Remark];
    _tf_remark.enabled = NO;
    
    _lb_totalPrice.text = [NSString stringWithFormat:@"￥%@元", [CommonUtil removeFloatAllZero:_letterDetail.PayFee]];
    _PayFee = _letterDetail.PayFee;
    
    [_btn_agree setImage:[UIImage imageNamed:@"Order_Reason_Sel"] forState:UIControlStateDisabled];
    _btn_agree.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = YES;
}

#pragma mark - 

- (void)changeAddress:(NSNotification *)notification {
    _letterAddress = notification.object;
    [self reloadAddress];
}

/**
 加载地址
 */
- (void)reloadAddress {
    _lb_userName.text = _letterAddress.Recipient;
    _lb_phone.text = _letterAddress.Phone;
    _lb_street.text = _letterAddress.Street;
}

- (void)getPriceList {
    [_letterService getLetterPriceListByID:_bidLetter.SerialNo result:^(NSInteger code, NSArray<LetterPriceDomain *> *list) {
        if (code == 1) {
            _arr_price = [NSArray arrayWithArray:list];
        }
    }];
}

/**
 最基本价格
 
 @return <#return value description#>
 */
- (NSString *)getBasePrice {
    return [NSString stringWithFormat:@"￥%@元起开", [CommonUtil removeFloatAllZero:_bidLetter.PayParameter]];
}

- (void)calcTotalPrice {
    if ([_tf_money.text.trimWhitesSpace isEmptyString] || _tf_money.text.trimWhitesSpace.floatValue == 0.0f) {
        if ([_bidLetter.PayMode isEqualToString:@"2"]) {
            _lb_price.text = [self getBasePrice];
        }
        return;
    }
    
    if ([_bidLetter.PayMode isEqualToString:@"1"]) {
        long double totalPriceFloat = _tf_money.text.floatValue * 10000 * _letterPrice.SegmentFee.floatValue;
        if (totalPriceFloat < _bidLetter.SafePayParameter.floatValue) {
            _totalPrice = (long double)(_bidLetter.SafePayParameter.floatValue * _tf_count.text.floatValue);
            NSString *tmpTotalPrice = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%.2Lf", (long double)(_bidLetter.SafePayParameter.floatValue * _tf_count.text.floatValue)]];
            _lb_totalPrice.text = [NSString stringWithFormat:@"￥%@元", tmpTotalPrice];
            NSString *title = [NSString stringWithFormat:@"您保函的保底价格为%@元/份", _bidLetter.SafePayParameter];
            [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                
            }];
        } else {
            _lb_totalPrice.text = [NSString stringWithFormat:@"￥%@元",[CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%.2Lf", totalPriceFloat * _tf_count.text.floatValue]]];
            _totalPrice = totalPriceFloat * _tf_count.text.floatValue;
        }
        
        _lb_price.text = [NSString stringWithFormat:@"%@%%",[CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%Lf", (long double)_letterPrice.SegmentFee.floatValue*100]]];
    } else {
        _lb_price.text = [NSString stringWithFormat:@"￥%@元",[CommonUtil removeFloatAllZero:_letterPrice.SegmentFee]];
        
        long double totalPricefloat = [_letterPrice.SegmentFee floatValue] * _tf_count.text.floatValue;
        _lb_totalPrice.text = [NSString stringWithFormat:@"￥%@元",[CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%.2Lf", totalPricefloat]]];
        
        _totalPrice = totalPricefloat;
    }
}

- (void)inputMoney {
    
    if (![_tf_money isFirstResponder]) {
        [self.view endEditing:YES];
        [_tf_money becomeFirstResponder];
    }
}

- (void)setCount:(NSInteger)count {
    NSString *countString = [NSString stringWithFormat:@"%ld", (long)count];
    //    [_btn_count setTitle:countString forState:UIControlStateDisabled];
    _tf_count.text = countString;
    
    ////    CGFloat price = [_product.DiscountPrice floatValue];
    //    CGFloat totalPrice = price * _count;
    //    NSString *total = [NSString stringWithFormat:@"%.0f元", totalPrice];
    //    _lb_total.text = total;
}

- (void)setLetterWithType:(NSInteger)type {
    if (type == 0) {
        _btn_letterType_normal.selected = YES;
        _btn_letterType_custom.selected = NO;
        [self hiddenExchangeBankView];
    } else {
        _btn_letterType_normal.selected = NO;
        _btn_letterType_custom.selected = YES;
        [self showExchangeBankView];
    }
}

- (void)setExchangeBankWithType:(NSInteger)type {
    if (type == 0) {
        _btn_exchange_yes.selected = YES;
        _btn_exchange_no.selected = NO;
    } else {
        _btn_exchange_yes.selected = NO;
        _btn_exchange_no.selected = YES;
    }
}

/**
 隐藏下面自定义更换银行的view
 */
- (void)hiddenExchangeBankView {
    _v_changeBank_back.hidden = YES;
    CGSize size = self.v_top.frame.size;
    size.height = 468;
    self.v_top.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView beginUpdates];
    [_tableView setTableHeaderView:self.v_top];// 关键是这句话
    [_tableView endUpdates];
}

/**
 显示下面自定义更换银行的view
 */
- (void)showExchangeBankView {
    _v_changeBank_back.hidden = NO;
    CGSize size = self.v_top.frame.size;
    size.height = 552;
    self.v_top.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setTableHeaderView:self.v_top];// 关键是这句话
}

- (void)getPriceListWithPrice:(CGFloat)price {
    [_letterService getLetterPriceListByID:_bidLetter.SerialNo result:^(NSInteger code, NSArray<LetterPriceDomain *> *list) {
        if (code == 1) {
            _arr_price = [NSArray arrayWithArray:list];
            
            [self inputedWithPrice:price];
            
        } else {
            [ProgressHUD showInfo:@"获取价格保函金额失败，请稍后再试" withSucc:NO withDismissDelay:2];
        }
    }];
}

- (void)inputedWithPrice:(CGFloat)price {
    __block VC_NewBidLetterBuy *weakSelf = self;
    __block BOOL isRightPrice = NO;
    
    if ([_bidLetter.PayMode isEqualToString:@"2"]) {
        
    }
    [_arr_price enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LetterPriceDomain *letterPrice = (LetterPriceDomain *)obj;
        CGFloat min = [letterPrice.Segment[@"Min"] floatValue];
        CGFloat max = [letterPrice.Segment[@"Max"] floatValue];
        if (price >= min && price < max) {
            *stop = YES;
            isRightPrice = YES;
            _letterPrice = letterPrice;
            NSString *title;
            if ([_bidLetter.PayMode isEqualToString:@"1"]) {
                title = [NSString stringWithFormat:@"您输入的保函金额是在%@, 费率是%@%%", letterPrice.SegmentTitle, [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%Lf", (long double)letterPrice.SegmentFee.floatValue*100]]];
                
            } else {
                title = [NSString stringWithFormat:@"您输入的保函金额是在%@, 价格是%@元/份", letterPrice.SegmentTitle, [CommonUtil removeFloatAllZero:letterPrice.SegmentFee]];
            }
            [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                
            }];
        }
    }];
    if (isRightPrice) {
        [weakSelf calcTotalPrice];
    } else {
        _tf_money.text = @"";
        NSString *title = @"您输入的保函金额超过了该产品的保函金额区间，请选择按费率方式计算价格的产品或联系客服";
        if ([_bidLetter.PayMode isEqualToString:@"1"]) {
            title = @"您输入的保函金额超过了该产品的保函金额区间，请联系客服";
        }
        [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
    }
}

- (BOOL)checkPriceInput {
    if (_tf_money.text.trimWhitesSpace.length > 0) {
        return YES;
    }
    [ProgressHUD showInfo:@"请输入保函金额" withSucc:NO withDismissDelay:2];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Section";
    static NSString *CellID2 = @"Cell_Normal";
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *editType = tmpDic[kCellEditType];
    if ([editType isEqualToString:CellSectionTitle]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        cell.textLabel.text = tmpDic[kCellName];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        cell.textLabel.text = tmpDic[kCellName];
        if ([EditType_TextField isEqualToString:editType] || [EditType_DatePicker isEqualToString:editType] ) {
            if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
                text = _dic_data[key];
                detailTextColor = [UIColor colorWithHex:@"666666"];
            }
        }
        cell.detailTextLabel.text = text;
        cell.detailTextLabel.textColor = detailTextColor;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([editType isEqualToString:CellSectionTitle])
        return 40;
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        return;
    }
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_DatePicker isEqualToString:editType]) {
        [self deadLineWithDic:tmpDic indexPath:indexPath];
    }
}

#pragma mark - textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    if (_tf_money == textField) {
        CGFloat price = _tf_money.text.floatValue * 10000;
        if (_arr_price == nil) {
            [self getPriceListWithPrice:price];
        } else {
            if (!_tf_money.text.isEmptyString && ![_tf_money.text isEqualToString:@"0"]) {
               [self inputedWithPrice:price];
            }
        }
    } else if (_tf_count == textField ) {
        if ([_tf_count.text.trimWhitesSpace isEqualToString:@"0"]) {
            _tf_count.text = @"1";
            _count = 1;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_tf_count == textField || _tf_money == textField) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        if (futureString.length > 0) {
            unichar single = [futureString characterAtIndex:0];
            if(single == '.') {
                [ProgressHUD showInfo:@"第一个不能输入小数点" withSucc:NO withDismissDelay:2];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        if (futureString.length == 2) {
            unichar single = [futureString characterAtIndex:0];
            unichar second = [futureString characterAtIndex:1];
            if(single == '0' && second == '0') {
                [textField.text stringByReplacingCharactersInRange:range withString:@"0"];
                return NO;
            }
            if (single == '0' && second != '0' && second != '.') {
                textField.text = [NSString stringWithFormat:@"%c", second];
                return NO;
            }
        }
        NSArray *array = [futureString componentsSeparatedByString:@"."];
        if (array.count > 2) {
            return NO;
        }
        
        NSInteger flag=0;
        const NSInteger limited = 4;  //小数点  限制输入两位
        for (int i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    [ProgressHUD showInfo:@"只能输入4位小数" withSucc:NO withDismissDelay:2];
                    return NO;
                }
                break;
            }
            flag++;
        }
    }
    return YES;
}

- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
    vc.type = INPUT_TYPE_NORMAL;
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text.trimWhitesSpace isEmptyString]) {
        vc.text = text.trimWhitesSpace;
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)deadLineWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:[NSDate date]];
    datePicker.mode = UIDatePickerModeDate;
    NSString *selectDate = _dic_data[key];
    if (selectDate != nil && ![selectDate isEmptyString]) {
        datePicker.selectedDate = [CommonUtil dateFromString:_dic_data[dic[kCellKey]]];
    }
    [datePicker presentInWindowWithBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            NSTimeInterval time = [datePicker.selectedDate timeIntervalSinceNow];
            if (time < -80000) {
                [ProgressHUD showInfo:@"不能小于当前日期" withSucc:NO withDismissDelay:2];
                return;
            }
            [_dic_data setObject:[CommonUtil stringFromDate:datePicker.selectedDate] forKey:dic[kCellKey]];
            [self reloadIndexPath:indexPath];
        }
    }];
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)btn_choiceAddress_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_LetterAddressList" storyboard:Storyboard_Main parent:self];
}

- (IBAction)btn_viewPriceDetail_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_LetterPriceDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:_bidLetter.SerialNo, @"JX_Title":_bidLetter.Name, kPageType: _bidLetter.PayMode} parent:self];
}
- (IBAction)btn_subCountPressed:(id)sender {
    if ([self checkPriceInput]) {
        if (_count > 1) {
            [self setCount:--_count];
        }
        [self calcTotalPrice];
    }
}
- (IBAction)btn_addCount_pressed:(id)sender {
    if ([self checkPriceInput]) {
        [self setCount:++_count];
        [self calcTotalPrice];
    }
}
- (IBAction)btn_letterType_normal_pressed:(id)sender {
    _letterType = 0;
    [self setLetterWithType:_letterType];
}
- (IBAction)btn_letterType_custom_pressed:(id)sender {
    _letterType = 1;
    [self setLetterWithType:_letterType];
}
- (IBAction)btn_exchange_yes_pressed:(id)sender {
    _exchangeType = 0;
    [self setExchangeBankWithType:-_exchangeType];
}
- (IBAction)btn_exchange_no_pressed:(id)sender {
    _exchangeType = 1;
    [self setExchangeBankWithType:-_exchangeType];
}
- (IBAction)btn_payPhone_pressed:(id)sender {
    if (_type == 1) {
        _isCreatedOrder = YES;
        
        _orderID = _letterDetail.OrderNo;
        [self payOrderByID:_orderID];
        return;
    }
    if (_isCreatedOrder) {
        [self payOrderByID:_orderID];
    } else {
        if ([self checkInput]) {
            _isPhonePay = YES;
            [self submitOrder];
        }
    }
}

- (IBAction)btn_payToPc_pressed:(id)sender {
//    if ([self checkInput]) {
//        _isPhonePay = NO;
//    }
    //取消订单
    [JAlertHelper jSheetWithTitle:@"订单还未支付，是否删除?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self deleteOrder];
        }
    }];
    
}

- (void)deleteOrder {
    [_letterService deleteBidLetterOrderByID:_letterDetail.OrderNo result:^(NSInteger code) {
        if (code == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
            [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:1];
            [self goBack];
        }
    }];
}

- (BOOL)checkInput {
    if (_tf_money.text.trimWhitesSpace.floatValue <= 0) {
        [ProgressHUD showInfo:@"请输入保函金额" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_tf_count.text.trimWhitesSpace.floatValue == 0.f) {
        [ProgressHUD showInfo:@"请输入数量" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"ProjectOwner"] == nil || [_dic_data[@"ProjectOwner"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入招标人单位名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"ProjectCompany"] == nil || [_dic_data[@"ProjectCompany"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入投标企业" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"ProjectTitle"] == nil || [_dic_data[@"ProjectTitle"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入项目名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"MaterialDt"] == nil || [_dic_data[@"MaterialDt"] isEmptyString]) {
        [ProgressHUD showInfo:@"请选择提交时间" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (!_btn_agree.selected) {
        [ProgressHUD showInfo:@"请同意购买协议" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

- (void)submitOrder {
    LetterOrderDomain *letterOrder = [[LetterOrderDomain alloc] init];
    letterOrder.SerialNo = _bidLetter.SerialNo;
    letterOrder.PerAmount = [NSString stringWithFormat:@"%lf", _tf_money.text.doubleValue * 10000];
    letterOrder.Quantity = _tf_count.text;
    letterOrder.PayParameter = _letterPrice.SegmentFee;
    letterOrder.PayFee = [[_lb_totalPrice.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] stringByReplacingOccurrencesOfString:@"元" withString:@""];
    _PayFee = letterOrder.PayFee;
    //    letterOrder.PayFee = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%lf", _totalPrice]];
    letterOrder.BaoHanStyle = [NSString stringWithFormat:@"%ld", _letterType];
    if (_letterType == 0) {
        letterOrder.IsChangeBank = @"0";
    } else {
        letterOrder.IsChangeBank = [NSString stringWithFormat:@"%ld", _exchangeType];
    }
    
    if ([_bidLetter.PayMode isEqualToString:@"2"]) {
        letterOrder.SegmentId = _letterPrice.SegmentId;
    }
    letterOrder.PayMode = _bidLetter.PayMode;
    letterOrder.PayParameter = _letterPrice.SegmentFee;
    letterOrder.Remark = _tf_remark.text;
    letterOrder.ProjectOwner = _dic_data[@"ProjectOwner"];
    letterOrder.ProjectCompany = _dic_data[@"ProjectCompany"];
    letterOrder.ProjectTitle = _dic_data[@"ProjectTitle"];
    letterOrder.MaterialDt = _dic_data[@"MaterialDt"];
    letterOrder.AddressInfoOId = _letterAddress.OId;
    __block VC_NewBidLetterBuy *weakSelf = self;
    [_letterService addLetterOrder:letterOrder result:^(NSInteger code, NSString *orderNo) {
        if (code == 1) {
//            weakSelf.btn_payPhone.enabled = NO;
//            weakSelf.btn_payToPc.enabled = NO;
            _isCreatedOrder = YES;
            
            _orderID = orderNo;
            [weakSelf payOrderByID:orderNo];
        }
    }];
}

- (void)payOrder {
    [self payOrderByID:_orderID];
}

- (void)payOrderByID:(NSString *)orderId {
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code != 1) {
            return;
        }
        if (wallet.Balance == nil) {
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
        } else {
            if (_password == nil) {
//                [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _PayFee] password:^(NSString *password) {
//                    
//                    _password = password;
//                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:password repeats:NO];
//                }];
                [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _PayFee] moneyTag:@"金额" password:^(NSString *password) {
                    _password = password;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:password repeats:NO];
                } cancel:^(BOOL cancel) {
                    if (cancel) {
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(cancelInputPassword:) userInfo:nil repeats:NO];
                    }
                }];
            } else {
                [self payWithPassword:_password];
            }
            
        }
    }];
}

- (void)payWithPasswordByTimer:(NSTimer *)timer {
    NSString *password = timer.userInfo;
    [self payWithPassword:password];
    
}

- (void)cancelInputPassword:(NSTimer *)timer {
    [JAlertHelper jAlertWithTitle:@"您还没有支付成功,要离开吗？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
        } else {
            [self payOrder];
        }
    }];
}

- (void)notificationPayOrder {
    _isNotification = YES;
    _payCount = 0;
    _payTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(addPayCount) userInfo:nil repeats:YES];
    [self payOrder];
}

- (void)addPayCount {
    _payCount++;
    if (_payCount % 5 == 0) {
        [self payWithPassword:_password];
    }
    
    if (_payCount > 30) {
        _isNotification = NO;
        _payCount = 0;
        [ProgressHUD hideProgressHUD];
        [ProgressHUD showInfo:@"请稍后再试" withSucc:NO withDismissDelay:2];
        [_payTimer invalidate];
    }
}

- (void)payWithPassword:(NSString *)password {
    [_letterService payLetterOrderByOrderNo:_orderID payFee:_PayFee addressNo:_letterAddress.OId payPwd:password result:^(NSInteger code) {

        
        
        if (code == 1) {
            if (_isNotification) {
                [_payTimer invalidate];
            }
            
            [CountUtil countBidLetterBuySuccess];
            
            if (_type == 0) {
                //支付成功, 上传资料
                LetterOrderDetailDomain *letterDetail = [[LetterOrderDetailDomain alloc] init];
                letterDetail.OrderNo = _orderID;
                letterDetail.ProjectOwner = _dic_data[@"ProjectOwner"];
                letterDetail.ProjectCompany = _dic_data[@"ProjectCompany"];
                letterDetail.ProjectTitle = _dic_data[@"ProjectTitle"];
                letterDetail.MaterialDt = _dic_data[@"MaterialDt"];
                //            [PageJumpHelper pushToVCID:@"VC_BidLetterProjectInfo" storyboard:Storyboard_Main parameters:@{kPageDataDic:letterDetail, kPageType:@1} parent:self];
                [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageDataDic: letterDetail, kPageType: @(1)} parent:self];
            } else {
                [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageDataDic: _letterDetail, kPageType: @(4)} parent:self];
            }
            
            
            
        }else if (code==301){//充值
            if (_isNotification) {
                [ProgressHUD showProgressHUDWithInfo:@""];
                return;
            }
            [JAlertHelper jAlertWithTitle:@"余额不足，是否前去充值？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSString *price = _PayFee;
                    [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parameters:@{kPageDataDic: price, kPageReturnType: @1} parent:self];
                }
            }];
            
        }else if (code==302){//未开通
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
            
        } else {
            _password = nil;
        }
    }];
}

- (void)backPressed {
    if (_type == 1) {
        [self goBack];
        return;
    }
    if (_isCreatedOrder) {
        [JAlertHelper jAlertWithTitle:@"您还没有支付成功,要离开吗？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
            }
        }];
    } else {
        [JAlertHelper jAlertWithTitle:@"您还没有成功下单，是否离开？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self goBack];
            }
        }];
    }
}
- (IBAction)btn_agree_pressed:(id)sender {
    _btn_agree.selected = !_btn_agree.selected;
}

- (IBAction)btn_buy_procotol_pressed:(id)sender {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv8.html";
    [CommonUtil jxWebViewShowInController:self loadUrl:urlString backTips:nil];
}
@end
