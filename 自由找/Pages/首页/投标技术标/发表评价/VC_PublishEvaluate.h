//
//  VC_PublishEvaluate.h
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_PublishEvaluate : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *v_star;
@property (weak, nonatomic) IBOutlet UILabel *lb_tv_tips;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lb_int;
@property (weak, nonatomic) IBOutlet UILabel *lb_decimal;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_commit_evaluation_press:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_anonymous;
- (IBAction)btn_anonymous_pressed:(id)sender;
@end
