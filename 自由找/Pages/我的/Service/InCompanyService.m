//
//  InCompanyService.m
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "InCompanyService.h"

@implementation InCompanyService
-(void)inCompanywithParamters:(NSDictionary *)parameters result:(void (^)(NSArray<InCompanyDomain *> *user, NSInteger code))result{
    [self httpRequestWithUrl:ACTION_COMPANY_QUERY parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                InCompanyDomain *bid = [InCompanyDomain domainWithObject:tmpDic];
                [bidList addObject:bid];
            }
            result(bidList, 1);
        } else {
            result(nil, 1);
        }
    } fail:^{
        result(nil, 1);
    }];
}
- (NSArray *)searchWithKey:(NSString *)key InMessageArray:(NSArray *)messages {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.content CONTAINS %@", key];
    
    return [messages filteredArrayUsingPredicate:pred];
    
}
-(void)userCalimWithParameters:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result{
  [self httpRequestWithUrl:ACTION_USER_Claim parameters:parameters success:^(id responseObject, NSInteger code) {
      if (code == 1) {
          [CommonUtil removeUserDomain];
          UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
          [CommonUtil saveUserDomian:user];
          result(1);
      } else {
          result(code);
      }
      
   } fail:^{
    result(0);
   }];
}

//认领企业，从资质查询页详情过来
- (void)updateFromCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result {
    [self httpRequestWithUrl:ACTION_USER_Claim_FromCompanyDetail parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            [CommonUtil removeUserDomain];
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
            [CommonUtil saveUserDomian:user];
            result(1);
        } else {
            result(code);
        }
        
    } fail:^{
        result(0);
    }];
}

-(void)userchangecompanyregion:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result{
    [self httpRequestWithUrl:ACTION_USER_changecompanyregion parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            [CommonUtil removeUserDomain];
            UserDomain *user = [UserDomain domainWithObject:responseObject[kResponseDatas]];
            [CommonUtil saveUserDomian:user];
            result(1);
        } else {
            result(0);
        }
    } fail:^{
        result(0);
    }];
}
@end
