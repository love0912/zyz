//
//  VC_UploadCompany.m
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_UploadCompany.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+BackgroundColor.h"
#import "InCompanyService.h"
@interface VC_UploadCompany (){
    UIImagePickerController *_imagePickerController;
    BaseService *_baseService;
    UIImage *_image;
    InCompanyService *_inCompanyService;
    //从资质查询详情页进来编辑
    NSInteger _type;
}

@end

@implementation VC_UploadCompany

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"上传企业信息";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    
    _type = [[self.parameters objectForKey:kPageType] integerValue];

}
-(void)loadData{
    _baseService=[BaseService sharedService];
    _inCompanyService=[InCompanyService sharedService];
}
-(void)layoutUI{
    if (IS_IPHONE_4_OR_LESS) {
        _layout_viewheight.constant=300;
    }
    _IV_CompanyInformation.contentMode=UIViewContentModeScaleAspectFit;
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];
}
-(void)rightItem_press{
    if(_image !=nil){
        [_baseService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:_image type:2 success:^(id responseObject, NSInteger code) {
            if (code != 1) {
                return ;
            }
            [ProgressHUD hideProgressHUD];
            NSDictionary *dic=@{@"ImgUrl":responseObject[@"datas"]};
            if (_type == 1) {
                
                [self updateFromCompanyDetailWithImageUrl:responseObject[@"datas"]];
                
            } else {
                [_inCompanyService userCalimWithParameters:dic result:^(NSUInteger code) {
                    if (code != 1) {
                        return;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Deatil_DATA" object:nil];
                    [ProgressHUD showInfo:@"上传成功，请等待审核" withSucc:NO withDismissDelay:2];
                    [self goBack];
                }];
            }
            
        } fail:^{
            [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
            
        }];

    }else{
        [ProgressHUD showInfo:@"请上传图片" withSucc:NO withDismissDelay:2];

    }
}

- (void)updateFromCompanyDetailWithImageUrl:(NSString *)imageUrl {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [paramDic setObject:imageUrl forKey:@"ImgUrl"];
    [_inCompanyService updateFromCompanyWithParameters:paramDic result:^(NSUInteger code) {
        if (code != 1) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Deatil_DATA" object:nil];
        [ProgressHUD showInfo:@"上传成功，请等待审核" withSucc:NO withDismissDelay:2];
        NSArray *vcs = self.navigationController.viewControllers;
        UIViewController *vc = [vcs objectAtIndex:vcs.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
    }];
}

- (void)showImagePickerView {
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
    UIImage *img_select = info[UIImagePickerControllerOriginalImage];
    _IV_CompanyInformation.image=img_select;
    _btn_upload.layer.masksToBounds=YES;
    _btn_upload.layer.cornerRadius=5.0;
    [_btn_upload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_upload setBackgroundColor:[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.3]];
    _image=img_select;
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
- (IBAction)btn_upload_press:(id)sender {
    [self showImagePickerView];
}
@end
