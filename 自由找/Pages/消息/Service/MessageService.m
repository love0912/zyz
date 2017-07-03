//
//  MessageService.m
//  自由找
//
//  Created by xiaoqi on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "MessageService.h"

@implementation MessageService
- (void)requestMessages:(NSDictionary *)paramDic success:(void (^)(NSArray <MessageDomain* >*messagedomain, NSInteger code))result {
   
    [self httpRequestWithUrl:ACTION_Get_Messages parameters:paramDic  success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                MessageDomain *bid = [MessageDomain domainWithObject:tmpDic];
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
- (void)setMessageReadedByID:(NSInteger)ID success:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_SET_MESSAGE_READED parameters:@{@"Id": @(ID)} success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}
- (void)deleteMessageByID:(NSInteger)ID success:(void (^)(NSInteger code))result{
    [self httpRequestWithUrl:ACTION_SET_MESSAGE_Delete parameters:@{@"Id": @(ID)} success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}
@end
