//
//  Cell_PerformanceDetail.h
//  zyz
//
//  Created by 郭界 on 17/1/19.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_PerformanceDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;

@property (strong, nonatomic) NSDictionary *dataDic;
@end
