//
//  VC_GoodField.h
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
typedef void(^GoodFiledChoiceBlock)(NSMutableArray *selectArr);
@interface VC_GoodField : VC_Base
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GoodFiledChoiceBlock filedchoiceBlock;
@property (nonatomic, strong)NSMutableArray *allArray;
@property (nonatomic, strong)NSMutableArray *selectArray;
@end
