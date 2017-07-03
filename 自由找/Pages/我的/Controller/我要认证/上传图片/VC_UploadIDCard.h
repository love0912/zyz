//
//  VC_UploadIDCard.h
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_UploadIDCard : VC_Base<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnToView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_IDPositive;
@property (weak, nonatomic) IBOutlet UIImageView *iv_IDPositiveDelete;
@property (weak, nonatomic) IBOutlet UIImageView *iv_IDReverse;
@property (weak, nonatomic) IBOutlet UIImageView *iv_IDReverseDelete;
@property (weak, nonatomic) IBOutlet UIImageView *iv_certificateDelete;
@property (weak, nonatomic) IBOutlet UIImageView *iv_certificate;
@property (weak, nonatomic) IBOutlet UIImageView *iv_sampleCertificate;

@end
