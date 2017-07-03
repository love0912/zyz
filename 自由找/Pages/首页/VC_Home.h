//
//  VC_Home.h
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Home : VC_Base<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img1_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img2_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img2_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img2_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img3_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img3_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img3_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img3_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img4_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img4_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img4_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_img4_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_baohan_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_baohan_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_baohan_left;

@property (weak, nonatomic) IBOutlet UIView *v_banner;

@property (weak, nonatomic) IBOutlet UILabel *lb_baohan;
@property (weak, nonatomic) IBOutlet UILabel *lb_1;
@property (weak, nonatomic) IBOutlet UILabel *lb_2;
@property (weak, nonatomic) IBOutlet UILabel *lb_3;
@property (weak, nonatomic) IBOutlet UILabel *lb_4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_yuanpan_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_yuanpan_bottom;

@property (weak, nonatomic) IBOutlet UIImageView *iv_yuanpan;
- (IBAction)btn_bid_pressed:(id)sender;
- (IBAction)btn_search_pressed:(id)sender;
- (IBAction)btn_jishu_pressed:(id)sender;
- (IBAction)btn_yusuan_pressed:(id)sender;
- (IBAction)btn_bank_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iv_avater;
@end
