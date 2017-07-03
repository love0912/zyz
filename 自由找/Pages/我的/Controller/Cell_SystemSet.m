//
//  Cell_SystemSet.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_SystemSet.h"

@implementation Cell_SystemSet

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSystemArray:(NSArray *)systemArray{
  
}
-(void)systemIndex:(NSInteger)systemindex andsystemtitle:(NSString *)systemTilte{
    self.lb_systemName.text=systemTilte;
}
@end
