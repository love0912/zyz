//
//  BidDomain.h
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"
@class TxtImgDomain;

@interface BidDomain : BaseDomain

@property (strong, nonatomic) NSString *ProjectId;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *ProjectAlias;

@property (strong, nonatomic) KeyValueDomain *Region;

@property (strong, nonatomic) KeyValueDomain *ProjectType;

@property (strong, nonatomic) KeyValueDomain *CompanyType;

/**
 *  1 满足人一个 0同时具备
 */
@property (assign, nonatomic) NSInteger IsMatchAny;

@property (strong, nonatomic) NSMutableArray<KeyValueDomain *> *AptitudesRequired;

@property (strong, nonatomic) NSString *Others;

@property (strong, nonatomic) TxtImgDomain *Performance;

@property (strong, nonatomic) TxtImgDomain *MemberRequired;

/**
 *  （int） 1 公开， 0 不公开
 */
@property (assign, nonatomic) NSInteger IsOpenPhone;

@property (strong, nonatomic) NSString *BiddingDate;

@property (strong, nonatomic) TxtImgDomain *Describe;

@end

@interface TxtImgDomain : BaseDomain

@property (strong, nonatomic) NSString *Word;

@property (strong, nonatomic) NSString *Img;

@end
