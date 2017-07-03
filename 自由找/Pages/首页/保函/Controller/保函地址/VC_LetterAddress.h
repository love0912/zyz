//
//  VC_LetterAddress.h
//  自由找
//
//  Created by 郭界 on 16/10/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_LetterAddress : VC_Base

@property (nonatomic,strong) NSArray *selections; //!< 选择的三个下标
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_addressTips;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextView *tv_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
- (IBAction)btn_save_pressed:(id)sender;
- (IBAction)btn_delete_pressed:(id)sender;
@end
