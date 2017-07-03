//
//  Cell_MyWallet.h
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_MyWallet : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_freezeMoney;
@property (weak, nonatomic) IBOutlet UILabel *lb_availableMoney;

- (void)configureWithFreeze:(NSString *)freeze avaliable:(NSString *)avalable;
@end
