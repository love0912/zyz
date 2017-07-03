//
//  VC_ServiceCenter.h
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_ServiceCenter : VC_Base
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height;
- (IBAction)btn_callPhone_press:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_vsersionTophoneHeight;
@property (weak, nonatomic) IBOutlet UILabel *lb_Version;

@end
