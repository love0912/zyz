//
//  VC_ConfirmLetter.m
//  自由找
//
//  Created by 郭界 on 16/10/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ConfirmLetter.h"
#import "LetterOrderDomain.h"
#import "BidLetterDomain.h"
#import "LetterPriceDomain.h"
#import "LetterService.h"
#import "LetterAddressService.h"
#import <UIImageView+WebCache.h>

@interface VC_ConfirmLetter ()
{
    NSInteger _count;
    NSInteger _letterType;
    NSInteger _exchangeType;
    BidLetterDomain *_bidLetter;
    LetterService *_letterService;
    LetterAddressService *_letterAddressService;
    LetterPriceDomain *_letterPrice;
    NSArray *_arr_price;
    CGFloat _totalPrice;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moneyTag_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_last_LetterChoice_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_choiceLetterType;
@property (weak, nonatomic) IBOutlet UILabel *lb_setCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_exchangeBank;
@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;
@end

@implementation VC_ConfirmLetter

- (void)initData {
    
    _count = 1;
    
    _letterType = 0;
    _exchangeType = 0;
    
    _letterService = [LetterService sharedService];
    _letterAddressService = [LetterAddressService sharedService];
    
    _bidLetter = [self.parameters objectForKey:kPageDataDic];
    //查询阶梯价格
    [self getPriceList];
//    if ([_bidLetter.PayMode isEqualToString:@"2"]) {
//        //查询阶梯价格
//        [self getPriceList];
//    } else {
//        _btn_viewPriceDetail.hidden = YES;
//    }

}

- (void)layoutUI {
    _lb_name.text = _bidLetter.Name;
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
    
    
    _layout_scrollback_widht.constant = SCREEN_WIDTH;
    
    _layout_scrollback_height.constant = 560;
    if (IS_IPHONE_5_OR_LESS) {
        _layout_moneyTag_top.constant = 10;
        _layout_last_LetterChoice_left.constant = 2;
        UIFont *font = [UIFont systemFontOfSize:12];
        _lb_choiceLetterType.font = _lb_setCount.font = _lb_exchangeBank.font = _lb_totalPrice.font = font;
        
        _layout_scrollback_height.constant = 500;
    }
    
//    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 560)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"确认订单";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)getPriceList {
    [_letterService getLetterPriceListByID:_bidLetter.SerialNo result:^(NSInteger code, NSArray<LetterPriceDomain *> *list) {
        if (code == 1) {
            _arr_price = [NSArray arrayWithArray:list];
        }
    }];
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
//    _lb_custom_tips.hidden = YES;
//    _v_exchangeBank.hidden = YES;
    _v_changeBank_back.hidden = YES;
    _layout_remark_top.constant = 1;
}

/**
 显示下面自定义更换银行的view
 */
- (void)showExchangeBankView {
//    _lb_custom_tips.hidden = NO;
//    _v_exchangeBank.hidden = NO;
    _v_changeBank_back.hidden = NO;
    _layout_remark_top.constant = _v_changeBank_back.height;
}

#pragma mark - textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    if (_tf_money == textField) {
//        if ([_bidLetter.PayMode isEqualToString:@"2"]) {
//            CGFloat price = _tf_money.text.floatValue * 10000;
//            if (_arr_price == nil) {
//                [self getPriceListWithPrice:price];
//            } else {
//                [self inputedWithPrice:price];
//            }
//            
//        } else {
//            [self calcTotalPrice];
//        }
        CGFloat price = _tf_money.text.floatValue * 10000;
        if (_arr_price == nil) {
            [self getPriceListWithPrice:price];
        } else {
            [self inputedWithPrice:price];
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
    
    return YES;
}

- (void)inputedWithPrice:(CGFloat)price {
    __block VC_ConfirmLetter *weakSelf = self;
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)inputMoney {
    
    if (![_tf_money isFirstResponder]) {
        [self.view endEditing:YES];
        [_tf_money becomeFirstResponder];
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

- (BOOL)checkPriceInput {
    if (_tf_money.text.trimWhitesSpace.length > 0) {
        return YES;
    }
    [ProgressHUD showInfo:@"请输入保函金额" withSucc:NO withDismissDelay:2];
    return NO;
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
            _lb_totalPrice.text = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%.2Lf", (long double)(_bidLetter.SafePayParameter.floatValue * _tf_count.text.floatValue)]];
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

- (IBAction)btn_commitLetter_pressed:(id)sender {
    if (_tf_money.text.trimWhitesSpace.floatValue <= 0) {
        [ProgressHUD showInfo:@"请输入保函金额" withSucc:NO withDismissDelay:2];
        return;
    }
    if (_tf_count.text.trimWhitesSpace.floatValue == 0.f) {
        [ProgressHUD showInfo:@"请输入数量" withSucc:NO withDismissDelay:2];
        return;
    }
    [_letterAddressService getOurDefaultAddressToResult:^(NSInteger code, LetterAddressDomain *letterAddress) {
        if (code == 1) {
            if (letterAddress == nil) {
                [PageJumpHelper pushToVCID:@"VC_LetterAddress" storyboard:Storyboard_Main parameters:@{kPageType: @0} parent:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitNotification:) name:@"Notification_Submit_Letter_Order" object:nil];
            } else {
                [self submitOrder];
            }
        }
    }];
}

- (void)submitNotification:(NSNotification *)notification {
    [self submitOrder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)submitOrder {
    [CountUtil countBidLetterSubmit];
    
    LetterOrderDomain *letterOrder = [[LetterOrderDomain alloc] init];
    letterOrder.SerialNo = _bidLetter.SerialNo;
    letterOrder.PerAmount = [NSString stringWithFormat:@"%lf", _tf_money.text.doubleValue * 10000];
    letterOrder.Quantity = _tf_count.text;
    letterOrder.PayParameter = _letterPrice.SegmentFee;
    letterOrder.PayFee = [[_lb_totalPrice.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] stringByReplacingOccurrencesOfString:@"元" withString:@""];
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
    __block VC_ConfirmLetter *weakSelf = self;
    [_letterService addLetterOrder:letterOrder result:^(NSInteger code, NSString *orderNo) {
        if (code == 1) {
            [weakSelf getDefaultAddressToJumpWithOrderID:orderNo];
        }
    }];
}

- (void)getDefaultAddressToJumpWithOrderID:(NSString *)orderID {
    [_letterAddressService getOurDefaultAddressToResult:^(NSInteger code, LetterAddressDomain *letterAddress) {
        NSString *payFee = [[_lb_totalPrice.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] stringByReplacingOccurrencesOfString:@"元" withString:@""];
//        NSString *payFee = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%lf", _totalPrice]];
        [PageJumpHelper pushToVCID:@"VC_CommitLetter" storyboard:Storyboard_Main parameters:@{kPageType:@1, kPageDataDic: letterAddress, @"Order_ID": orderID, @"Pay_Fee": payFee} parent:self];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)btn_viewPriceDetail_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_LetterPriceDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:_bidLetter.SerialNo, @"JX_Title":_bidLetter.Name, kPageType: _bidLetter.PayMode} parent:self];
}



@end
