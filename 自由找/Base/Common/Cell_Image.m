//
//  Cell_Image.m
//  自由找
//
//  Created by guojie on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_Image.h"

@implementation Cell_Image

- (IBAction)btn_delete:(id)sender {
    if ([_delegate respondsToSelector:@selector(deleteImageWithRow:)]) {
        [_delegate deleteImageWithRow:_row];
    }
}

@end
