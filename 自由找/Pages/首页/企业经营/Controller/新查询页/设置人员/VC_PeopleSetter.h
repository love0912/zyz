//
//  VC_PeopleSetter.h
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^NewMemberResult)(NSMutableDictionary *resultDicInfo);

@interface VC_PeopleSetter : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_finish;
- (IBAction)btn_finish_pressed:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dic_MemberInfo;

@property (strong, nonatomic) NewMemberResult memberResult;

@property (strong, nonatomic) NSDictionary *regionDic;
@end
