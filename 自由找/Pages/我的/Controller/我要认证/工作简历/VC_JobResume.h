//
//  VC_JobResume.h
//  自由找
//
//  Created by xiaoqi on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_JobTime.h"
typedef void(^JobResumeBlock)(NSDictionary *resultDic);
typedef void(^JobResumeDeleteBlock)(NSInteger result);
@interface VC_JobResume : VC_Base<Cell_JobTimeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JobResumeBlock jobResumeBlock;
@property (nonatomic, strong) JobResumeDeleteBlock jobResumeDeleteBlock;
/*
 *0-工作简历 1-项目简历
 */
@property (nonatomic, assign) NSInteger ResumeCategory;
/*
 *0-添加简历 1-修改简历
 */
@property (nonatomic, assign) NSInteger ResumeType;
@end
