//
//  Cell_Message.h
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_Message : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IV_messageHead;
@property (weak, nonatomic) IBOutlet UILabel *lb_messageName;
@property (weak, nonatomic) IBOutlet UILabel *lb_messageDate;
@property (weak, nonatomic) IBOutlet UILabel *lb_messageDetail;

@end
