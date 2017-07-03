//
//  VC_CProject_Detail.h
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Project.h"
#import <MessageUI/MessageUI.h>

@interface VC_CProject_Detail : VC_Base<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Project *project;

- (IBAction)btn_edit_pressed:(id)sender;

- (IBAction)btn_delete_pressed:(id)sender;

- (void)phone;

- (void)message;

@end
