//
//  VC_SendMsg.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import <MessageUI/MessageUI.h>

@interface VC_SendMsg : VC_Base<UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;

@property (strong, nonatomic) NSString *projectId;

@end
