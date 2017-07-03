//
//  Cell_Letter_Bid_New.h
//  zyz
//
//  Created by 郭界 on 16/11/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseConstants.h"
#import "BidLetterDomain.h"

//今日特价颜色
#define Color_Active @"0B82F1"
//有效期颜色
#define Color_Exprie @"666666"

@interface Cell_Letter_Bid_New : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_letterName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_letterName_width;
@property (weak, nonatomic) IBOutlet UILabel *lb_letterBank;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_letterBank_width;
@property (weak, nonatomic) IBOutlet UILabel *lb_priceWay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_priceWay_width;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_minPrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_active;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_recommend;

@property (strong, nonatomic) BidLetterDomain *bidLetter;
@end
