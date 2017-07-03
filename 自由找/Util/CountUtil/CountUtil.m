//
//  CountUtil.m
//  zyz
//
//  Created by 郭界 on 16/11/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "CountUtil.h"

@implementation CountUtil

#pragma mark - 资质查询
/**
 统计点击搜索资质按钮
 */
+ (void)countSearchCompany {
    [MobClick event:@"Search_Company" attributes:@{@"Phone": [CountUtil phoneToUser]}];
}

/**
 点击去查看
 */
+ (void)countSearchToView {
    [MobClick event:@"Search_ToView" attributes:@{@"Phone": [CountUtil phoneToUser]}];
}


/**
 查看企业详情
 */
+ (void)countSearchViewDetail {
    [MobClick event:@"Search_ViewDetail" attributes:@{@"Phone": [CountUtil phoneToUser]}];
}


/**
 点击拨打电话按钮
 */
+ (void)countSearchViewDetailCall {
    [MobClick event:@"Search_ViewDetail_Call" attributes:@{@"Phone": [CountUtil phoneToUser]}];
}

+ (NSString *)phoneToUser {
    NSString *phone = @"";
    if ([CommonUtil isLogin]) {
        phone = [CommonUtil getUserDomain].Phone;
    }
    return phone;
}

#pragma mark - 投标技术标
/**
 查看技术标详情
 */
+ (void)countTechDetail {
    [CountUtil countPhoneWithEventID:@"Tech_ViewDetail"];
}

/**
 技术标去下单
 */
+ (void)countTechToOrder {
    [CountUtil countPhoneWithEventID:@"Tech_ToOrder"];
}

/**
 技术标提交订单
 */
+ (void)countTechSubmit {
    [CountUtil countPhoneWithEventID:@"Tech_Submit"];
}

/**
 技术标切换区域
 */
+ (void)countTechExchangeRegion {
    [CountUtil countPhoneWithEventID:@"Tech_exchangeRegion"];
}

/**
 技术标购买成功
 */
+ (void)countTechBuySuccess {
    [CountUtil countPhoneWithEventID:@"Tech_BuySuccess"];
}


/**
 技术标 订单详情
 */
+ (void)countTechOrderDetail {
    [CountUtil countPhoneWithEventID:@"Tech_OrderDetail"];
}

/**
 技术标查看制作人员
 */
+ (void)countTechViewProducer {
    [CountUtil countPhoneWithEventID:@"Tech_ViewProducer"];
}

/**
 技术标 去下载
 */
+ (void)countTechDownload {
    [CountUtil countPhoneWithEventID:@"Tech_Download"];
}

#pragma mark - 投标预算
/**
 查看预算详情
 */
+ (void)countBudgeDetail {
    [CountUtil countPhoneWithEventID:@"Budge_ViewDetail"];
}

/**
 预算去下单
 */
+ (void)countBudgeToOrder {
    [CountUtil countPhoneWithEventID:@"Budge_ToOrder"];
}

/**
 预算提交订单
 */
+ (void)countBudgeSubmit {
    [CountUtil countPhoneWithEventID:@"Budge_Submit"];
}

/**
 预算切换区域
 */
+ (void)countBudgeExchangeRegion {
    [CountUtil countPhoneWithEventID:@"Budge_exchangeRegion"];
}

/**
 预算购买成功
 */
+ (void)countBudgeBuySuccess {
    [CountUtil countPhoneWithEventID:@"Budge_BuySuccess"];
}


/**
 预算 查看订单详情
 */
+ (void)countBudgeOrderDetail {
    [CountUtil countPhoneWithEventID:@"Budge_OrderDetail"];
}

/**
 预算查看制作人员
 */
+ (void)countBudgeViewProducer {
    [CountUtil countPhoneWithEventID:@"Budge_ViewProduce"];
}

/**
 预算 去下载
 */
+ (void)countBudgeDownload {
    [CountUtil countPhoneWithEventID:@"Budge_Download"];
}

#pragma mark - 投标保函

/**
 投标保函 -- 详情
 */
+ (void)countBidLetterDetail {
    [CountUtil countPhoneWithEventID:@"BidLetter_Detail"];
}

/**
 投标保函 -- 我要开保函
 */
+ (void)countBidLetterOpen {
    [CountUtil countPhoneWithEventID:@"BidLetter_Open"];
}

/**
 投标保函 -- 提交订单
 */
+ (void)countBidLetterSubmit {
    [CountUtil countPhoneWithEventID:@"BidLetter_Submit"];
}

/**
 投标保函 -- 填写地址
 */
+ (void)countBidLetterCreateAddress {
    [CountUtil countPhoneWithEventID:@"BidLetter_CreateAddress"];
}

/**
 投标保函 -- 购买成功
 */
+ (void)countBidLetterBuySuccess {
    [CountUtil countPhoneWithEventID:@"BidLetter_BuySuccess"];
}

/**
 投标保函 -- 填写项目信息
 */
+ (void)countBidLetterProjectInfo {
    [CountUtil countPhoneWithEventID:@"BidLetter_ProjectInfo"];
}

/**
 投标保函 -- 上传资料
 */
+ (void)countBidLetterUpload {
    [CountUtil countPhoneWithEventID:@"BidLetter_UploadImage"];
}


+ (void)countPhoneWithEventID:(NSString *)eventId {
    [MobClick event:eventId attributes:@{@"Phone": [CountUtil phoneToUser]}];
}
@end
