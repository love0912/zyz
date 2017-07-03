//
//  Cell_MyOrder.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_MyOrder.h"
#import "BaseConstants.h"
@implementation Cell_MyOrder

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5_OR_LESS) {
        _btn_seeMoney.titleLabel.font=[UIFont systemFontOfSize:12.0];
        _btn_seeaddenum.titleLabel.font=[UIFont systemFontOfSize:12.0];
        _layout_btnWidth.constant=80.0;

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)btn_phoneLabel_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickPhoneResult:)]) {
        PublisherDomain *phone=_myorder.Publisher;
        [_delegate clickPhoneResult:phone.Contact1];
    }
}

- (IBAction)btn_phone_press:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickPhoneResult:)]) {
        PublisherDomain *phone=_myorder.Publisher;
        [_delegate clickPhoneResult:phone.Contact1];
    }
}

- (IBAction)btn_chat_press:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickChatResult:)]) {
        PublisherDomain *phone=_myorder.Publisher;
        [_delegate clickChatResult:phone.Contact2];
    }
}
- (IBAction)btn_seeaddendum_press:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickAddendumResult:)]) {
        [_delegate clickAddendumResult:_myorder.SerialNo];
    }
}

- (IBAction)btn_seeMoney_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(clickMoneyResult:)]) {
        [_delegate clickMoneyResult:_walletRecord];
    }
}
-(void)setMyorder:(OurProjectOrderDomain *)myorder{
    _myorder=myorder;
    _lb_projectName.text=myorder.ProjectTitle;
    [_projectType setTitle:myorder.ProjectType.Value forState:UIControlStateNormal];
    _lb_time.text=[NSString stringWithFormat:@"交稿时间:%@",myorder.DeliveryDt];
    if ([myorder.IsNewMsg isEqualToString:@"1"]) {
        _iv_chatRed.hidden=NO;
    }else if([myorder.IsNewMsg isEqualToString:@"0"]){
        _iv_chatRed.hidden=YES;
    }
    if ([myorder.IsNewAdditional isEqualToString:@"1"]) {
        _iv_addendumRed.hidden=NO;
    }else if([myorder.IsNewAdditional isEqualToString:@"0"]){
        _iv_addendumRed.hidden=YES;
    }
    _walletRecord=myorder.WalletRecord;
    _iv_moneyRed.hidden=YES;
     _btn_seeMoney.hidden=YES;
    if(_walletRecord!=nil&&_walletRecord.RecordType !=nil){
        _lb_time.text = @"已完成";
        if ([_walletRecord.RecordType isEqualToString:@"3"]) {
            [_btn_seeMoney setTitle:@"查看扣款" forState:UIControlStateNormal];
            _btn_seeMoney.hidden=NO;
        }else if([_walletRecord.RecordType isEqualToString:@"5"]){
            [_btn_seeMoney setTitle:@"查看收款" forState:UIControlStateNormal];
            _btn_seeMoney.hidden=NO;
        }

    }
    
    NSString *productCount = @"技术标";
    if (myorder.ProductType != nil &&[myorder.ProductType isEqualToString:@"2"]) {
        productCount = @"预算";
    }
    productCount = [NSString stringWithFormat:@"%@ x %@", productCount, myorder.Quantity == nil ? @"" : myorder.Quantity];
    _lb_productTypeCount.text = productCount;
}
@end
