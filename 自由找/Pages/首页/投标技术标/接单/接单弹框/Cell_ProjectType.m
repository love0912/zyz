//
//  Cell_ProjectType.m
//  testtest
//
//  Created by xiaoqi on 16/8/11.
//  Copyright © 2016年 李娟. All rights reserved.
//

#import "Cell_ProjectType.h"
#import "BaseConstants.h"
@implementation Cell_ProjectType

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor=[UIColor grayColor];
    if (IS_IPHONE_5_OR_LESS) {
        self.btn_type.titleLabel.font=[UIFont systemFontOfSize:14.0];
    }
}

- (IBAction)btn_type:(id)sender {
}
@end
