//
//  Cell_EvaluateList.h
//  自由找
//
//  Created by guojie on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateDomain.h"
#import "UIImageView+WebCache.h"

@interface Cell_EvaluateList : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_avater;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UIView *iv_star;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_scoreInt;
@property (weak, nonatomic) IBOutlet UILabel *lb_scoreFloat;

@property (strong, nonatomic) EvaluateDomain *evaluate;

- (void)configureWithEvaluate:(NSObject *)obj;

@end
