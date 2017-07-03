//
//  LetterAddressDomain.h
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface LetterAddressDomain : BaseDomain

/**
 地址唯一ID
 */
@property (strong, nonatomic) NSString *OId;

/**
 收件人
 */
@property (strong, nonatomic) NSString *Recipient;

/**
 电话
 */
@property (strong, nonatomic) NSString *Phone;

/**
 选择的地址，以逗号隔开，便于查找索引. "重庆市,江北区,人和镇"
 */
@property (strong, nonatomic) NSString *District;

/**
 详细地址
 */
@property (strong, nonatomic) NSString *Street;

/**
 邮编
 */
@property (strong, nonatomic) NSString *ZipCode;

/**
 “1” – 默认地址     “0”---不是默认地址
 */
@property (strong, nonatomic) NSString *IsDefault;

@end
