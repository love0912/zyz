//
//  VC_EditMine.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "RSKImageCropViewController.h"

@interface VC_EditMine : VC_Base<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
