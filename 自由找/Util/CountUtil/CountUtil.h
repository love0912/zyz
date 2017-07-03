//
//  CountUtil.h
//  zyz
//
//  Created by 郭界 on 16/11/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMMobClick/MobClick.h>
#import "CommonUtil.h"

@interface CountUtil : NSObject

#pragma mark - 资质查询
/**
 统计点击搜索资质按钮
 */
+ (void)countSearchCompany;

/**
 点击去查看
 */
+ (void)countSearchToView;

/**
 查看企业详情
 */
+ (void)countSearchViewDetail;

/**
 点击拨打电话按钮
 */
+ (void)countSearchViewDetailCall;

#pragma mark - 投标技术标
/**
 查看技术标详情
 */
+ (void)countTechDetail;

/**
 技术标去下单
 */
+ (void)countTechToOrder;

/**
 技术标提交订单
 */
+ (void)countTechSubmit;

/**
 技术标切换区域
 */
+ (void)countTechExchangeRegion;

/**
 技术标购买成功
 */
+ (void)countTechBuySuccess;

/**
 技术标 订单详情
 */
+ (void)countTechOrderDetail;

/**
 技术标查看制作人员
 */
+ (void)countTechViewProducer;

/**
 技术标 去下载
 */
+ (void)countTechDownload;

#pragma mark - 投标预算
/**
 查看预算详情
 */
+ (void)countBudgeDetail;

/**
 预算去下单
 */
+ (void)countBudgeToOrder;

/**
 预算提交订单
 */
+ (void)countBudgeSubmit;

/**
 预算切换区域
 */
+ (void)countBudgeExchangeRegion;

/**
 预算购买成功
 */
+ (void)countBudgeBuySuccess;

/**
 预算 查看订单详情
 */
+ (void)countBudgeOrderDetail;

/**
 预算查看制作人员
 */
+ (void)countBudgeViewProducer;

/**
 预算 去下载
 */
+ (void)countBudgeDownload;

#pragma mark - 投标保函

/**
 投标保函 -- 详情
 */
+ (void)countBidLetterDetail;

/**
 投标保函 -- 我要开保函
 */
+ (void)countBidLetterOpen;

/**
 投标保函 -- 提交订单
 */
+ (void)countBidLetterSubmit;

/**
 投标保函 -- 填写地址
 */
+ (void)countBidLetterCreateAddress;

/**
 投标保函 -- 购买成功
 */
+ (void)countBidLetterBuySuccess;

/**
 投标保函 -- 填写项目信息
 */
+ (void)countBidLetterProjectInfo;

/**
 投标保函 -- 上传资料
 */
+ (void)countBidLetterUpload;

@end
