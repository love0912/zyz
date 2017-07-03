//
//  VC_CreditResult.h
//  自由找
//
//  Created by guojie on 16/7/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

typedef void(^CreditResultChoice)(NSDictionary *resultDic);

@interface VC_CreditResult : VC_Base<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)setInputArray:(NSArray *)inputArray selectKey:(NSString *)selectKey;

@property (strong, nonatomic) CreditResultChoice creditChoice;


@end
