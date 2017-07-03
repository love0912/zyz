//
//  VC_FeedBack.h
//  自由找
//
//  Created by xiaoqi on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_FeedBack : VC_Base<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
- (IBAction)btn_commit_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tv_height;
@property (weak, nonatomic) IBOutlet UILabel *lb_tvLength;

@end
