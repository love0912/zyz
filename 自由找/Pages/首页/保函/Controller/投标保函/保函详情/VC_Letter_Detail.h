//
//  VC_Letter_Detail.h
//  自由找
//
//  Created by 郭界 on 16/10/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_Evaluate.h"

@interface VC_Letter_Detail : VC_Base<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, EvaluateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_openLetter_pressed:(id)sender;

@end
