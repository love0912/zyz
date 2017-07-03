//
//  Cell_Letter_Bid.h
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BidLetterDomain.h"


@interface Cell_Letter_Bid : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *v_back;
@property (weak, nonatomic) IBOutlet UILabel *lb_real_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_cansale;
@property (weak, nonatomic) IBOutlet UILabel *lb_ori_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bankLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_cansale_width;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc_1;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc_2;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc_3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbDesc2_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbDesc3_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbDesc1_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_lbCity_width;

@property (strong, nonatomic) BidLetterDomain *bidLetter;

@end
