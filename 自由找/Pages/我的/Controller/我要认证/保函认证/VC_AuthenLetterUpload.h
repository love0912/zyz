//
//  VC_AuthenLetterUpload.h
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_AuthenLetterUpload : VC_Base

@property (weak, nonatomic) IBOutlet UIImageView *iv_upload;
- (IBAction)btn_selectPicture_pressed:(id)sender;
- (IBAction)btn_commit_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@end
