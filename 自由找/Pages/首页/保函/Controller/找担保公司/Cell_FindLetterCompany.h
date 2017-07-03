//
//  Cell_FindLetterCompany.h
//  zyz
//
//  Created by 郭界 on 17/1/9.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterCompanyDomain.h"

@interface Cell_FindLetterCompany : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *v_back;
@property (weak, nonatomic) IBOutlet UILabel *lb_region;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_company;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_region_width;

@property (strong, nonatomic) LetterCompanyDomain *company;

@end
