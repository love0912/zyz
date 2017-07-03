//
//  Cell_JobTime.h
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Cell_JobTimeDelegate <NSObject>

- (void)tapResult:(NSInteger)result indexPath:(NSIndexPath *)indexPath;
@end

@interface Cell_JobTime : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_startTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_endTime;
@property (weak, nonatomic) id<Cell_JobTimeDelegate> delegate;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end
