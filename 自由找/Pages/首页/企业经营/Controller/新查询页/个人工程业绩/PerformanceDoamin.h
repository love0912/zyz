//
//  PerformanceDoamin.h
//  zyz
//
//  Created by 郭界 on 17/1/6.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface PerformanceDoamin : BaseDomain

/**
 项目编号
 */
@property (strong, nonatomic) NSString *ProjectNo;
/**
 项目名称
 */
@property (strong, nonatomic) NSString *ProjectName;
/**
 项目分类
 */
@property (strong, nonatomic) NSString *ProjectCategory;
/**
 项目用途
 */
@property (strong, nonatomic) NSString *ProjectApplication;
/**
 建设规模
 */
@property (strong, nonatomic) NSString *ProjectSize;
/**
 中标金额
 */
@property (strong, nonatomic) NSString *WinningAmount;
/**
 中标日期
 */
@property (strong, nonatomic) NSString *WinningDt;
/**
 竣工日期
 */
@property (strong, nonatomic) NSString *ProjectDeliverDt;
/**
 建造师
 */
@property (strong, nonatomic) NSString *BuildEngineer;
/**
 技术负责人
 */
@property (strong, nonatomic) NSString *TechLeader;

/**
 建设单位
 */
@property (strong, nonatomic) NSString *BuilderCompany;

/**
 中标单位
 */
@property (strong, nonatomic) NSString *WinningCompany;


@end
