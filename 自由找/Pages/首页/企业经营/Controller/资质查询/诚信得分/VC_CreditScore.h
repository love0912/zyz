//
//  VC_CreditScore.h
//  自由找
//
//  Created by xiaoqi on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_CreditScore.h"
#import "VC_CreditScoreTwo.h"
@protocol VC_CreditScoreDelegate<NSObject>
-(void)selectScore:(NSString *)selectscore;
typedef void(^Credit2Result)(NSArray *);
@end

@interface VC_CreditScore : VC_Base
@property (nonatomic, strong) NSMutableArray *arr_Input;;
@property (nonatomic, strong) Credit2Result credit2Result;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<VC_CreditScoreDelegate> delegate;

/**
 *  1 -- 更正信息
 * 
 */
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic)NSArray *selectArray;
@end
