//
//  VC_RegisterJob.h
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_RegisterJob.h"


typedef void(^NewRegisterJobResult)(NSMutableArray *resultArrayInfo);

@interface VC_RegisterJob : VC_Base<UITableViewDelegate, UITableViewDataSource>

/**
 //1 --- 注册类人员设置
 //2 --- 职称类人员设置
 //4 --- 现场管理人员设置
 */
@property (nonatomic, assign) NSInteger titleType;

- (IBAction)btn_add_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arr_registerJobInfo;

@property (strong, nonatomic) NewRegisterJobResult qualityResult;

@end
