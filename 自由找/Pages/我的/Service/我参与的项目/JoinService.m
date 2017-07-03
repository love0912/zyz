//
//  JoinService.m
//  自由找
//
//  Created by guojie on 16/6/23.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JoinService.h"

@implementation JoinService

- (void)queryOurIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<BidListDomain *> *bidList, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_USER_PUBLISH parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray array];
            for (NSDictionary *tmpDic in tmpArray) {
                BidListDomain *bid = [BidListDomain domainWithObject:tmpDic];
                [bidList addObject:bid];
            }
            result(bidList, 1);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

- (void)queryAttentionUserListWithParameters:(NSDictionary *)parameters result:(void (^)(AttentionUserList *userList, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_USER_ATTENTIONUSER parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            AttentionUserList *userList = [AttentionUserList domainWithObject:responseObject[kResponseDatas]];
            result(userList, code);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

- (void)modifyAttentionUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_CHECKMARK parameters:parameters success:^(id responseObject, NSInteger code) {
        //标记成功
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)backAttentionUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_CHECKBACK parameters:parameters success:^(id responseObject, NSInteger code) {
        //退回成功
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)delIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_PUBLISHDELETE parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)modifyIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_PUBLISHEDITE parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)queryAttentionBidListWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<AttentionBidDomain *> *bidList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ATTENTIONLIST parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                AttentionBidDomain *bid = [AttentionBidDomain domainWithObject:tmpDic];
                [bidList addObject:bid];
            }
            result(bidList, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)backAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ATTENTIONCANCEL parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)delAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ATTENTIONDELETE parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)finishAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ATTENTIONCOMPLETE parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

/**
 *  标记沟通完成
 *
 *  @param attentionID 关注ID
 *  @param result      <#result description#>
 */
- (void)communicateAttentionID:(NSString *)attentionID result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_COMUNICATEDATTENTION parameters:@{kBidAttentionID: attentionID} success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)exportAttentionUserWithProjectID:(NSString *)projectID result:(void (^)(NSArray<ExpCompanyDomain *> *attentionUser , NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ENROLLEXPORT parameters:@{kBidProjectID: projectID} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *attentionUsers = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ExpCompanyDomain *domain = [ExpCompanyDomain domainWithObject:tmpDic];
                [attentionUsers addObject:domain];
            }
            result(attentionUsers, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)exportAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<ExpBidDomain *> *bids , NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_PROJECTEXPORT parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bids = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ExpBidDomain *domain = [ExpBidDomain domainWithObject:tmpDic];
                [bids addObject:domain];
            }
            result(bids, 1);
        } else {
            result(nil, code);
        }
       
    } fail:^{
        result(nil, 0);
    }];
}

- (void)asseseAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ASSESSBID parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

/**
 *  评价报名用户
 *
 *  @param parameters AttentionId,
 *  @param result     Rate
 */
- (void)asseseAttentionUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_ATTENTIONUSER_SCORE parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

@end
