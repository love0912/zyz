//
//  VC_ConfirmLetter.h
//  自由找
//
//  Created by 郭界 on 16/10/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ConfirmLetter : VC_Base

@property (weak, nonatomic) IBOutlet UIView *v_inputBack;
@property (weak, nonatomic) IBOutlet UITextField *tf_money;
- (IBAction)btn_subCountPressed:(id)sender;
- (IBAction)btn_addCount_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf_count;
@property (weak, nonatomic) IBOutlet UIButton *btn_letterType_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_letterType_custom;
@property (weak, nonatomic) IBOutlet UILabel *lb_custom_tips;
@property (weak, nonatomic) IBOutlet UIView *v_exchangeBank;
- (IBAction)btn_letterType_normal_pressed:(id)sender;
- (IBAction)btn_letterType_custom_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_exchange_yes;
@property (weak, nonatomic) IBOutlet UIButton *btn_exchange_no;
- (IBAction)btn_exchange_yes_pressed:(id)sender;
- (IBAction)btn_exchange_no_pressed:(id)sender;
- (IBAction)btn_commitLetter_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UILabel *lb_bankCity;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_priceTag;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UIButton *btn_viewPriceDetail;
- (IBAction)btn_viewPriceDetail_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tf_remark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_remark_top;
@property (weak, nonatomic) IBOutlet UIView *v_changeBank_back;
@property (weak, nonatomic) IBOutlet UIView *v_scroll_container;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollback_widht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollback_height;
@property (weak, nonatomic) IBOutlet UILabel *lb_expression;

@end
