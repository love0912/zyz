//
//  VC_UploadCompany.h
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
@interface VC_UploadCompany : VC_Base<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *IV_CompanyInformation;
- (IBAction)btn_upload_press:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewheight;
@property (weak, nonatomic) IBOutlet UIButton *btn_upload;
@end
