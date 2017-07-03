//
//  VC_UploadedImage.h
//  zyz
//
//  Created by 郭界 on 16/11/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_UploadedImage : VC_Base

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)btn_toUpload_pressed:(id)sender;
@end
