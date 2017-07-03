//
//  Cell_Letter_Perform.h
//  自由找
//
//  Created by 郭界 on 16/9/29.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterPerformDomain.h"

@interface Cell_Letter_Perform : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_createDate;
@property (weak, nonatomic) IBOutlet UILabel *lb_expireDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_money_width;

@property (strong, nonatomic) LetterPerformDomain *letterPerform;

@end
