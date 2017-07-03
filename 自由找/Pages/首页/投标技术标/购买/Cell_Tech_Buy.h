//
//  Cell_Tech_Buy.h
//  自由找
//
//  Created by xiaoqi on 16/7/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ProductDomain.h"

@interface Cell_Tech_Buy : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_destail;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet UILabel *lb_discountPrice;
//@property (weak, nonatomic) IBOutlet UILabel *lb_originalPrice;
//@property (weak, nonatomic) IBOutlet UIButton *btn_knock;
@property (weak, nonatomic) IBOutlet UILabel *lb_monthSales;
@property (weak, nonatomic) IBOutlet UIView *v_back;
@property (weak, nonatomic) IBOutlet UILabel *lb_bizDesc;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bizDesc_width;
-(void)initView;

@property (strong, nonatomic) ProductDomain *product;

@end
