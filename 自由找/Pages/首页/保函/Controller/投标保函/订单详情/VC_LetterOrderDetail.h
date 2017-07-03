//
//  VC_LetterOrderDetail.h
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_LetterOrderDetail : VC_Base

@property (weak, nonatomic) IBOutlet UILabel *lb_orderNo;
@property (weak, nonatomic) IBOutlet UIButton *btn_status;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_priceTag;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_contactName;
@property (weak, nonatomic) IBOutlet UILabel *lb_contactPhone;
@property (weak, nonatomic) IBOutlet UILabel *lb_returnReason;
@property (weak, nonatomic) IBOutlet UILabel *lb_trackingName;
@property (weak, nonatomic) IBOutlet UILabel *lb_trackingNo;
@property (weak, nonatomic) IBOutlet UIButton *btn_evaluate;
@property (weak, nonatomic) IBOutlet UIButton *btn_toUpload;

@property (weak, nonatomic) IBOutlet UIView *v_return_back;
@property (weak, nonatomic) IBOutlet UIView *v_notPay_back;
@property (weak, nonatomic) IBOutlet UIView *v_normal_back;
@property (weak, nonatomic) IBOutlet UIView *v_normak_back_menu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbOrderNo_right;
@property (weak, nonatomic) IBOutlet UILabel *lb_remark;
@property (weak, nonatomic) IBOutlet UILabel *lb_projectName;
@property (weak, nonatomic) IBOutlet UILabel *lb_letterMoney;

- (IBAction)btn_call_pressed:(id)sender;
- (IBAction)btn_toUpload_pressed:(id)sender;
- (IBAction)btn_returnDelete_pressed:(id)sender;
- (IBAction)btn_cancel_pressed:(id)sender;
- (IBAction)btn_toPay_pressed:(id)sender;
- (IBAction)btn_finishDelete_pressed:(id)sender;
- (IBAction)btn_evaluate_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollContent_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollContent_width;
@end
