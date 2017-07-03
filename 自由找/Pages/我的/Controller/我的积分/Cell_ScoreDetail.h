//
//  Cell_ScoreDetail.h
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreDomain.h"

@interface Cell_ScoreDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_score;

@property (strong, nonatomic) ScoreDomain *score;

/**
 *  1 -- 获取, 2 -- 消费
 */
@property (assign, nonatomic) NSInteger type;

@end
