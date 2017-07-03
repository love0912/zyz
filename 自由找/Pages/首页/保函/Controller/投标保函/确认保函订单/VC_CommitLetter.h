//
//  VC_CommitLetter.h
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_CommitLetter : VC_Base
@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_street;

@property (weak, nonatomic) IBOutlet UIButton *btn_agree;

- (IBAction)btn_agree_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice_bottom;
- (IBAction)btn_choiceAddress_pressed:(id)sender;
- (IBAction)btn_buy_procotol_pressed:(id)sender;
- (IBAction)btn_commit_pressed:(id)sender;
@end
