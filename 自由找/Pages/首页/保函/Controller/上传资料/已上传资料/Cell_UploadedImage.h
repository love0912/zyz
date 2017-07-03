//
//  Cell_UploadedImage.h
//  zyz
//
//  Created by 郭界 on 16/11/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@protocol UploadedImageDelegate <NSObject>

- (void)deleteImageWithImageUrl:(NSString *)imageUrl;

@end

@interface Cell_UploadedImage : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)btn_delete_pressed:(id)sender;

@property (strong, nonatomic) NSString *imageUrl;

@property (assign, nonatomic) id<UploadedImageDelegate> delegate;

@end
