//
//  Cell_Image.h
//  自由找
//
//  Created by guojie on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellImageDelDelegate <NSObject>

- (void)deleteImageWithRow:(NSInteger) row;

@end

@interface Cell_Image : UICollectionViewCell

@property (weak, nonatomic) id<CellImageDelDelegate> delegate;

@property (assign, nonatomic) NSInteger row;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)btn_delete:(id)sender;
@end
