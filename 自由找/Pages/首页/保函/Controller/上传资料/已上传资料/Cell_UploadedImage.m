//
//  Cell_UploadedImage.m
//  zyz
//
//  Created by 郭界 on 16/11/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "Cell_UploadedImage.h"

@implementation Cell_UploadedImage

- (IBAction)btn_delete_pressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(deleteImageWithImageUrl:)]) {
        [_delegate deleteImageWithImageUrl:_imageUrl];
    }
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
@end
