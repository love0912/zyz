//
//  MessageService.h
//  自由找
//
//  Created by xiaoqi on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "MessageDomain.h"
@interface MessageService : BaseService
- (void)requestMessages:(NSDictionary *)paramDic success:(void (^)(NSArray <MessageDomain* >*messagedomain, NSInteger code))result;

/**
 *  设置消息已读
 *
 *  @param ID     消息ID    0 已读全部消息
 *  @param result <#result description#>
 */
- (void)setMessageReadedByID:(NSInteger)ID success:(void (^)(NSInteger code))result;

/**
 *  删除消息
 *
 *  @param ID     消息ID  0 删除全部消息
 *  @param result <#result description#>
 */
- (void)deleteMessageByID:(NSInteger)ID success:(void (^)(NSInteger code))result;
@end
