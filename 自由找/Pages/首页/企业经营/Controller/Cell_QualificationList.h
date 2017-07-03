//
//  Cell_QualificationList.h
//  自由找
//
//  Created by xiaoqi on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QualificaDomian.h"
@interface Cell_QualificationList : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_companyName;
@property (weak, nonatomic) IBOutlet UIButton *btn_certification;
@property (weak, nonatomic) IBOutlet UILabel *lb_credit1;
@property (weak, nonatomic) IBOutlet UILabel *lb_credit2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_companytoTop;
@property (weak, nonatomic) IBOutlet UILabel *lb_credit3;
@property (weak, nonatomic) IBOutlet UILabel *lb_credit4;
@property (weak, nonatomic) IBOutlet UILabel *lb_credit5;
@property (strong, nonatomic) QualificaListDomian *bidList;
@end
