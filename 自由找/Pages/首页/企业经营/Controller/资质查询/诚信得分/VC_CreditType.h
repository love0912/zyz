//
//  VC_CreditType.h
//  自由找
//
//  Created by guojie on 16/7/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^CreditResult)(NSDictionary *resultDic);

@interface VC_CreditType : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *dic_data;

@property (strong, nonatomic) NSString *regionCode;

/**
 *  0 -- 资质查询, 1 -- 企业添加编辑
 */
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) CreditResult resultDictionary;

@end
