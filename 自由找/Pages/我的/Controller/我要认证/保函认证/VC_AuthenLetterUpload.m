//
//  VC_AuthenLetterUpload.m
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AuthenLetterUpload.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+BackgroundColor.h"
#import "AuthenLetterDomain.h"
#import "AuthenLetterService.h"


@interface VC_AuthenLetterUpload ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    AuthenLetterDomain *_authenLetter;
    UIImagePickerController *_imagePickerController;
    UIImage *_chooseImage;
    AuthenLetterService *_authenLetterService;
}
@end

@implementation VC_AuthenLetterUpload

- (void)initData {
    _authenLetter = [self.parameters objectForKey:kPageDataDic];
    _authenLetterService = [AuthenLetterService sharedService];
    
    if (![_authenLetter.ImgUrl isEmptyString]) {
        [_iv_upload sd_setImageWithURL:[NSURL URLWithString:_authenLetter.ImgUrl] placeholderImage:[UIImage imageNamed:@"LetterAuthenUpload"]];
    }
    if ([_authenLetter.AuthStatus isEqualToString:@"1"]) {
        [_btn_commit setTitle:@"正在审核中" forState:UIControlStateDisabled];
        _btn_commit.enabled = NO;
    }
}

- (void)layoutUI {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"上传照片";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_selectPicture_pressed:(id)sender {
    if (_authenLetter.AuthStatus != nil && [_authenLetter.AuthStatus isEqualToString:@"1"]) {
        [ProgressHUD showInfo:@"正在审核中，不能修改" withSucc:NO withDismissDelay:2];
        return;
    }
    
    //选择图片
    [JAlertHelper jSheetWithTitle:@"请选择" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"从相册中选择" OtherButtonsArray:@[@"拍照"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //从相册中选择
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self openSelectImageView];
        } else if (buttonIndex == 2) {
            //拍照
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self openSelectImageView];
        }
    }];
}

- (void)openSelectImageView {
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - imagepickerview
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_imagePickerController dismissViewControllerAnimated:NO completion:nil];
    _chooseImage = info[UIImagePickerControllerOriginalImage];
    _iv_upload.image = _chooseImage;
    [self uploadImage:_chooseImage];
}

- (void)uploadImage:(UIImage *)image {
    [ProgressHUD showProgressHUDWithInfo:@"上传中"];
    [_authenLetterService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:image  type:2 success:^(id responseObject, NSInteger code) {
        if (code != 1) {
            [self uploadImage:_chooseImage];
            return;
        }
        _authenLetter.ImgUrl = responseObject[kResponseDatas];
    } fail:^{
        [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
    }];
}

- (IBAction)btn_commit_pressed:(id)sender {
    if (_authenLetter.AuthStatus != nil && [_authenLetter.AuthStatus isEqualToString:@"1"]) {
        [ProgressHUD showInfo:@"正在审核中，不能修改" withSucc:NO withDismissDelay:2];
        return;
    }
    if (_authenLetter.ImgUrl != nil && _authenLetter.ImgUrl.trimWhitesSpace.length > 0) {
        [_authenLetterService authenLetterWithDomain:_authenLetter result:^(NSInteger code) {
            if (code == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterAuth" object:nil];
                [JAlertHelper jAlertWithTitle:@"申请认证成功，审核通过后，您会收到推送信息提示!" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    NSArray *vcs = self.navigationController.viewControllers;
                    UIViewController *popVC = [vcs objectAtIndex:vcs.count - 3];
                    [self.navigationController popToViewController:popVC animated:YES];
                }];
            }
            
        }];
    }
}
@end
