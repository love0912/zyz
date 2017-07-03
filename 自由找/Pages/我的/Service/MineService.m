
//  MineService.m
//  自由找
//
//  Created by guojie on 16/6/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "MineService.h"
#import "CommonUtil.h"

@implementation MineService

- (void)registUserWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_REGIST parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSString *sessionKey = responseObject[kResponseDatas][kUserSessionKey];
            [CommonUtil saveObject:sessionKey forUserDefaultsKey:kUserSessionKey];
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas][KRegistUserInfo]];
            result(user, 1);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

- (void)loginWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_LOGIN parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSString *sessionKey = responseObject[kResponseDatas][kUserSessionKey];
            [CommonUtil saveObject:sessionKey forUserDefaultsKey:kUserSessionKey];
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas][KRegistUserInfo]];
            result(user, 1);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

- (void)autoLoginToresult:(void (^)(UserDomain *user, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_USER_AUTO_LOGIN parameters:@{kLoginVersion: [CommonUtil shortVersion]} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
            result(user, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

/**
 *  修改用户资料
 *
 *  @param parameters <#parameters description#>
 *  @param result     返回用户对象
 */
- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_MODIFY parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
            result(user, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)resetPasswordWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_RESET_PASSWORD parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)logoutToResult:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_LOGOUT success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            [CommonUtil removeUserDomain];
            [CommonUtil removeObjectforUserDefaultsKey:kUserSessionKey];
            //退出成功
            result(1);
        } else {
            result(code);
        }
    } fail:^{
        result(0);
    }];
}

- (void)bindCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_BINDCOMPANY parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            SiteDomain *site = [SiteDomain domainWithObject:responseObject[kResponseDatas]];
            UserDomain *user = [CommonUtil getUserDomain];
            NSMutableArray *userSites = [NSMutableArray arrayWithArray:user.Sites];
            [userSites addObject:site];
            user.Sites = [userSites copy];
            [CommonUtil saveUserDomian:user];
            //绑定成功
            result(1);
        } else {
            result(code);
        }
    } fail:^{
        result(0);
    }];
}

- (void)unbindCompanyToResult:(void (^)(NSInteger code))result {
    UserDomain *user = [CommonUtil getUserDomain];
    if (user.Sites != nil && user.Sites.count > 0) {
        SiteDomain *site = user.Sites.firstObject;
        NSDictionary *paramDic = @{kCompanyID: site.CompanyId, kBidRegionCode: site.Location.Key, kUserID: user.UserId};
        [self httpRequestWithUrl:ACTION_USER_UNBINDCOMPANY parameters:paramDic success:^(id responseObject, NSInteger code) {
            if (code == 1) {
                user.Sites = @[];
                [CommonUtil saveUserDomian:user];
                //解绑成功
                result(1);
            } else {
                result(code);
            }
        } fail:^{
            result(0);
        }];
    }
    
}

- (void)addNewCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMPANY_ADD parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            [CommonUtil removeUserDomain];
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
            [CommonUtil saveUserDomian:user];
            //添加成功，绑定完成
            result(1);
        } else {
            result(code);
        }
    } fail:^{
        result(0);
    }];
}

- (void)modifyCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMPANY_MODIFY parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            SiteDomain *site = [SiteDomain domainWithObject:responseObject[kResponseDatas]];
            UserDomain *user = [CommonUtil getUserDomain];
            user.Sites = @[site];
            [CommonUtil saveUserDomian:user];
            //修改成功，绑定完成
            result(1);
        } else {
            result(code);
        }
    } fail:^{
        result(0);
    }];
}

/**
 *  获取我的积分明细
 *
 *  @param type   1/2 获取/消费
 *  @param result <#result description#>
 */
- (void)queryScoreWithType:(NSInteger)type page:(NSInteger)page result:(void (^)(NSString *total, NSArray<ScoreDomain *> *arr_score, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_MINE_SCORE parameters:@{kCommonType: @(type), kPage: @(page)} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSDictionary *responseDic = responseObject[kResponseDatas];
            NSString *total = responseDic[@"ScoreTotal"];
            NSArray *tmpArray = [responseDic objectForKey:@"ScoreList"];
            NSMutableArray *arr_score = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ScoreDomain *score = [ScoreDomain domainWithObject:tmpDic];
                [arr_score addObject:score];
            }
            result(total, arr_score, 1);
        } else {
            result(nil, nil, code);
        }
    } fail:^{
        result(nil, nil, 0);
    }];
}

@end
