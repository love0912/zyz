//
//  MessageDomain.h
//  自由找
//
//  Created by xiaoqi on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface MessageDomain : BaseDomain<NSCoding>

@property (assign, nonatomic) NSInteger Id;

@property (assign, nonatomic) NSInteger SenderId;

@property (strong, nonatomic) NSString *SenderName;

@property (assign, nonatomic) NSInteger ReceiverId;

@property (strong, nonatomic) NSString *Content;

@property (strong, nonatomic) NSString *State;

@property (strong, nonatomic) NSString *InsertTime;

@property (strong, nonatomic) NSString *MessageType;

@property (strong, nonatomic) NSString *RelevancyId;

@property (strong, nonatomic) NSString *RelevancyType;

@property (strong, nonatomic) NSString *HeadImg;

@end
