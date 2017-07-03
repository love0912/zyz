//
//  Cell_SystemSet.h
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_SystemSet : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_systemName;
@property (weak, nonatomic) IBOutlet UILabel *lb_systemVersion;
-(void)systemIndex:(NSInteger)systemindex andsystemtitle:(NSString *)systemTilte;
@end
