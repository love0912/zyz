//
//  Cell_CustomerDetail.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_CustomerDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;

- (void)configureCellWithDic:(NSDictionary *)dic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_value_right;
@property (weak, nonatomic) IBOutlet UIButton *btn_call;
- (IBAction)btn_call_pressed:(id)sender;
@end
