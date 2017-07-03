//
//  Cell_MyCollection.h
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectOrderDomain.h"
@interface Cell_MyCollection : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_projectname;
@property (weak, nonatomic) IBOutlet UIButton *btn_projectType;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (strong, nonatomic) ProjectOrderDomain *mycollection;
@end
