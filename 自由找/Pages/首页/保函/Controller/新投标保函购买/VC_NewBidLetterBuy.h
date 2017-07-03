//
//  VC_NewBidLetterBuy.h
//  zyz
//
//  Created by 郭界 on 16/12/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_NewBidLetterBuy : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_top;

#pragma mark - 收货地址
@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_street;
- (IBAction)btn_choiceAddress_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_addressChoice;

#pragma mark - 保函信息
@property (weak, nonatomic) IBOutlet UILabel *lb_letterName;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;
@property (weak, nonatomic) IBOutlet UILabel *lb_bankCity;
@property (weak, nonatomic) IBOutlet UILabel *lb_priceTag;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UIButton *btn_viewPriceDetail;
- (IBAction)btn_viewPriceDetail_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_expression;
#pragma mark - 输入信息
@property (weak, nonatomic) IBOutlet UIView *v_inputBack;
@property (weak, nonatomic) IBOutlet UITextField *tf_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_setCount;
- (IBAction)btn_subCountPressed:(id)sender;
- (IBAction)btn_addCount_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_addCount;
@property (weak, nonatomic) IBOutlet UIButton *btn_subCount;
@property (weak, nonatomic) IBOutlet UITextField *tf_count;
@property (weak, nonatomic) IBOutlet UILabel *lb_choiceLetterType;
@property (weak, nonatomic) IBOutlet UIButton *btn_letterType_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_letterType_custom;
- (IBAction)btn_letterType_normal_pressed:(id)sender;
- (IBAction)btn_letterType_custom_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *v_changeBank_back;
@property (weak, nonatomic) IBOutlet UILabel *lb_custom_tips;
@property (weak, nonatomic) IBOutlet UILabel *lb_exchangeBank;
@property (weak, nonatomic) IBOutlet UIButton *btn_exchange_yes;
@property (weak, nonatomic) IBOutlet UIButton *btn_exchange_no;
- (IBAction)btn_exchange_yes_pressed:(id)sender;
- (IBAction)btn_exchange_no_pressed:(id)sender;
#pragma mark - 备注
@property (weak, nonatomic) IBOutlet UITextField *tf_remark;
@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;
- (IBAction)btn_payPhone_pressed:(id)sender;
- (IBAction)btn_payToPc_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_payPhone;
@property (weak, nonatomic) IBOutlet UIButton *btn_payToPc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_total_right;

@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
- (IBAction)btn_agree_pressed:(id)sender;
- (IBAction)btn_buy_procotol_pressed:(id)sender;
@end
