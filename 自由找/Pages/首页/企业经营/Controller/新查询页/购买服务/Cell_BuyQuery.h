//
//  Cell_BuyQuery.h
//  zyz
//
//  Created by 郭界 on 17/1/11.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyQueryDomain.h"

@interface Cell_BuyQuery : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_serviceName;
@property (weak, nonatomic) IBOutlet UILabel *lb_serviceDesc;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic) BuyQueryDomain *buyQueryDomain;
@end
