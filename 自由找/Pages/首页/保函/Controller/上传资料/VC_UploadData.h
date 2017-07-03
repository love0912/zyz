//
//  VC_UploadData.h
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_UploadData : VC_Base

@property (weak, nonatomic) IBOutlet UILabel *lb_tips;
- (IBAction)btn_upload_pressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *v_collection_back;
@end
