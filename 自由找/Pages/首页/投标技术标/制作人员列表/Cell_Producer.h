//
//  Cell_Producer.h
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProducerDomain.h"

@interface Cell_Producer : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_avater;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;

@property (strong, nonatomic) ProducerDomain *producer;

@end
