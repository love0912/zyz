//
//  Cell_CProjectDetail.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VC_CProject_Detail.h"

@interface Cell_CProjectDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;
@property (weak, nonatomic) IBOutlet UIButton *btn_message;


- (IBAction)btn_phone_pressed:(id)sender;
- (IBAction)btn_message_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_value_right;

@property (weak, nonatomic) VC_CProject_Detail *delegate;

- (void)configureCellWithDic:(NSDictionary *)dic;
@end
