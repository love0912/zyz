//
//  VC_OrderReview.h
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import <TTTAttributedLabel.h>

@interface VC_OrderReview : VC_Base<TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgv_product;
@property (weak, nonatomic) IBOutlet UILabel *lb_orderName;
@property (weak, nonatomic) IBOutlet UILabel *lb_moneyTag;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_serviceTag;
@property (weak, nonatomic) IBOutlet UIButton *btn_pei;
@property (weak, nonatomic) IBOutlet UILabel *lb_message;
@property (weak, nonatomic) IBOutlet UILabel *lb_contact;
@property (weak, nonatomic) IBOutlet UILabel *lb_total;
@property (weak, nonatomic) IBOutlet UIButton *btn_count;
@property (weak, nonatomic) IBOutlet UITextField *tf_count;

@property (weak, nonatomic) IBOutlet UILabel *lb_email_name;

@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_tv_tips;
@property (weak, nonatomic) IBOutlet UITextField *tf_contact;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lb_contact_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lb_money_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tip1_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tip2_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tip3_top;
- (IBAction)btn_OrderSubmit_pressed:(id)sender;
- (IBAction)btn_sub_pressed:(id)sender;
- (IBAction)btn_add_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_wenxinTip;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lb_wenxinTip_1;
@end
