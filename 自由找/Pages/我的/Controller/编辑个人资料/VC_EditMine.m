//
//  VC_EditMine.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_EditMine.h"
#import "Cell_Avater.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+BackgroundColor.h"
#import "VC_TextField.h"
#import "MineService.h"
#import "JPUSHService.h"

#define kCellLogout @"Logout"
@interface VC_EditMine ()
{
    NSArray *_arr_input;
    UserDomain *_user;
    UIImagePickerController *_imagePickerController;
    MineService *_mineService;
}
@end

@implementation VC_EditMine

- (void)initData {
    _arr_input = @[
                   @[
                       @{kCellKey: kRegistAvater, kCellName: @"头像"},
                       @{kCellKey: kRegistUserName, kCellName: @"姓名", kCellDefaultText: @"修改姓名"},
                       @{kCellKey: kRegistPassword, kCellName: @"修改密码"}
                       ],
                   @[
                       @{kCellKey: kCellLogout, kCellName: @"退出登录"}
                       ]
                   ];
    _user = [CommonUtil getUserDomain];
    _mineService = [MineService sharedService];
}

- (void)layoutUI {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 1)];
    self.tableView.tableHeaderView = v;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"编辑资料";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_input.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_input objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AvaterCellIdentifier = @"Cell_Avater";
    static NSString *NameCellIdentifier = @"Cell_Name";
    NSDictionary *tmpDic = [[_arr_input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    if ([kRegistAvater isEqualToString:key]) {
        Cell_Avater *cell = [tableView dequeueReusableCellWithIdentifier:AvaterCellIdentifier];
        [cell.imgv_avater sd_setImageWithURL:[NSURL URLWithString:_user.HeadImg] placeholderImage:[UIImage imageNamed:@"default_avater"]];
        return cell;
    } else if ([kCellLogout isEqualToString:key]) {
        static NSString *logoutCellIdentifier = @"logoutCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutCellIdentifier];

        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutCellIdentifier];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithHex:@"ff3a3a"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = tmpDic[kCellName];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
        if ([kRegistUserName isEqualToString:key]) {
            cell.textLabel.text = tmpDic[kCellName];
            cell.detailTextLabel.text = _user.UserName;
        } else {
            cell.textLabel.text = tmpDic[kCellName];
            cell.detailTextLabel.text = @"";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [[_arr_input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    if ([kRegistAvater isEqualToString:key]) {
        return 75;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [[_arr_input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    if ([kRegistAvater isEqualToString:key]) {
        [self showImagePickerView];
    } else if ([kRegistUserName isEqualToString:key]) {
        [self editNameWithIndexPath:indexPath];
    } else if ([kRegistPassword isEqualToString:key]) {
        [PageJumpHelper pushToVCID:@"VC_ForgetPwd" storyboard:Storyboard_Mine parameters:@{kPageDataDic: _user.Phone} parent:self];
    } else if ([kCellLogout isEqualToString:key]) {
        [self logout];
    }
}

- (void)editNameWithIndexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [self getVC_TextField];
    vc.type = INPUT_TYPE_NORMAL;
    vc.maxCount = 5;
    NSString *text = _user.UserName;
    if (text != nil && ![text isEmptyString]) {
        vc.text = text;
    }
    vc.jTitle = @"请输入姓名";
    vc.placeholder = @"请输入姓名";
    vc.inputBlock = ^(NSString *text) {
        if (![text.trimWhitesSpace isEmptyString] && ![[text trimWhitesSpace] isEqualToString:_user.UserName]) {
            NSDictionary *paramDic = @{kRegistUserName: text};
            [self modifyWithDic:paramDic];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)modifyWithDic:(NSDictionary *)paramDic {
    [_mineService modifyUserInfoWithParameters:paramDic result:^(UserDomain *user, NSInteger code) {
        if (code == 1) {
            _user = user;
            [CommonUtil saveUserDomian:_user];
            [_tableView reloadData];
            [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationChangeHomeAvater" object:nil];
        }
    }];
}

- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
}

- (void)showImagePickerView {
    //选择图片
    [JAlertHelper jSheetWithTitle:@"请设置您的头像" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"恢复默认头像" OtherButtonsArray:@[@"从相册中选择", @"拍照"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSDictionary *paramDic = @{kUserHeadImg: @""};
            [self modifyWithDic:paramDic];
        } else if (buttonIndex == 2) {
            //从相册中选择
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self openSelectImageView];
        } else if (buttonIndex == 3) {
            //拍照
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self openSelectImageView];
        }
    }];
}

- (void)logout {
    [JAlertHelper jSheetWithTitle:@"确定退出？" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"退出" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
//            [_mineService logoutToResult:^(NSInteger code) {
//                if (code == 1) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT_CLEAR_MESSAGE" object:nil];
//                    [self unBindAlias:[CommonUtil getUserDomain]];
//                    [CommonUtil removeUserDomain];
//                    [CommonUtil removeObjectforUserDefaultsKey:kUserSessionKey];
//                    [CommonUtil setMsgCount:0];
//                    [CommonUtil setMineCount:0];
//                    [self goBack];
//                }
//            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT_CLEAR_MESSAGE" object:nil];
            
            [self unBindAlias:[CommonUtil getUserDomain]];
            [CommonUtil removeUserDomain];
            [CommonUtil removeObjectforUserDefaultsKey:kUserSessionKey];
            [CommonUtil setMsgCount:0];
            [CommonUtil setMineCount:0];
//            [self EMloginOut];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationChangeHomeAvater" object:nil];
            [self goBack];
        }
    }];
}
//-(void)EMloginOut{
//    __weak VC_EditMine *weakSelf = self;
//    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] logout:YES];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf hideHud];
//            if (error != nil) {
//                [weakSelf showHint:error.errorDescription];
//            }
//            else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            }
//        });
//    });
//
//}
- (void)unBindAlias:(UserDomain *)user {
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            NSLog(@"unbind success");
        }
    }];
}

- (void)openSelectImageView {
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - imagepickerview
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_imagePickerController dismissViewControllerAnimated:NO completion:nil];
    UIImage *img_select = info[UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:img_select];
    imageCropVC.view.backgroundColor = [UIColor whiteColor];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:NO completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    [_mineService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:croppedImage type:1 success:^(id responseObject, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [ProgressHUD hideProgressHUD];
        NSString *urlPath = responseObject[kResponseDatas];
        NSDictionary *paramDic = @{kUserHeadImg: urlPath};
        [self modifyWithDic:paramDic];
    } fail:^{
    }];
    
//    [ProgressHUD showProgressHUDWithInfo:@"头像上传中"];
//    _imgv_avater.image = croppedImage;
//    NSDictionary *paramDic = @{kUpload_Type: @"2", kUpload_UserId: _userDomain.userId, kUpload_Formate: @"png", kUpload_Mobletype: @"2"};
//    [_editService uploadImage:croppedImage parameters:paramDic success:^(id responseObject) {
//        if ([HttpUtil rightData:responseObject]) {
//            _userDomain.headImg = responseObject[kDatas][0][kImage_SPicUrl];
//            [CommonUtil saveUserDomian:_userDomain];
//        } else {
//        }
//        [HttpUtil showResponseMsg:responseObject];
//    } fail:^{
//        
//    }];
    
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
