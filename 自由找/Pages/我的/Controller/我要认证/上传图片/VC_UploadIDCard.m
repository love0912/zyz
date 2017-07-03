//
//  VC_UploadIDCard.m
//  自由找
//
//  Created by xiaoqi on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_UploadIDCard.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+BackgroundColor.h"
#import "ProducerService.h"
#import "ProducerDomain.h"
@interface VC_UploadIDCard (){
    UIImagePickerController *_imagePickerController;
    UIImage *_imagePositive;
    UIImage *_imageReverse;
    UIImage *_imageCertificate;
    NSInteger _TapType;
    NSInteger _TapDeleteType;
    BaseService *_baseService;
    ProducerService *_producerService;
    NSMutableArray *_retrunImageUrl;
    ProducerDomain *_producerdomian;


    
}
- (IBAction)btn_submit_press:(id)sender;

@end

@implementation VC_UploadIDCard

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我要认证";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
}
-(void)backPressed{
        
        [JAlertHelper jAlertWithTitle:@"亲，直接返回会造成信息不完整，审核不通过，确定返回吗？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if(buttonIndex==1){
                 [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Upload_Cerification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
                [self goBack];
            }
        }];
}
-(void)initData{
    if (IS_IPHONE_5_OR_LESS) {
        _layout_btnToBottom.constant=10;
        _layout_btnToView.constant=10;
    }
    _baseService=[BaseService sharedService];
    _producerService=[ProducerService sharedService];
    _retrunImageUrl=[[NSMutableArray array]init];

}
-(void)layoutUI{
    if ([[self.parameters objectForKey:@"orderType"] isEqualToString:@"0"]) {//技术标
        _iv_sampleCertificate.image=[UIImage imageNamed:@"certification_certificate1"];
    }else{//预算
        _iv_sampleCertificate.image=[UIImage imageNamed:@"certification_certificate2"];
    }
    _producerdomian=[self.parameters objectForKey:@"producerdomian"];
    _iv_IDPositiveDelete.hidden=YES;
    _iv_IDReverseDelete.hidden=YES;
    _iv_certificateDelete.hidden=YES;
    if (_producerdomian !=nil && _producerdomian.IdentityFrontSideUrl !=nil && ![_producerdomian.IdentityFrontSideUrl isEmptyString] &&_producerdomian.IdentityBackSideUrl !=nil && ![_producerdomian.IdentityBackSideUrl isEmptyString]&&_producerdomian.CertificateUrl !=nil && ![_producerdomian.CertificateUrl isEmptyString]) {
        [_iv_IDPositive sd_setImageWithURL:[NSURL URLWithString:_producerdomian.IdentityFrontSideUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _imagePositive=image;
            _iv_IDPositiveDelete.hidden=NO;
        }];
        [_iv_IDReverse sd_setImageWithURL:[NSURL URLWithString:_producerdomian.IdentityBackSideUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _imageReverse=image;
             _iv_IDReverseDelete.hidden=NO;
        }];
        [_iv_certificate sd_setImageWithURL:[NSURL URLWithString:_producerdomian.CertificateUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _imageCertificate=image;
             _iv_certificateDelete.hidden=NO;
        }];
        
    }
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    [_imagePickerController.navigationController.navigationBar jj_setBackgroundColor:[UIColor colorWithHex:@"ff7b23"]];
    [_imagePickerController.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    _iv_IDPositive.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_IDPositive=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_IDPositive)];
    [_iv_IDPositive addGestureRecognizer:tap_IDPositive];
    _iv_IDPositiveDelete.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_IDPositiveDelete=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_IDPositiveDelete)];
    [_iv_IDPositiveDelete addGestureRecognizer:tap_IDPositiveDelete];

    _iv_IDReverse.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_IDReverse=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_IDReverse)];
    [_iv_IDReverse addGestureRecognizer:tap_IDReverse];
    _iv_IDReverseDelete.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_IDReverseDelete=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_IDReverseDelete)];
    [_iv_IDReverseDelete addGestureRecognizer:tap_IDReverseDelete];
    
    _iv_certificate.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_certificate=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_Certificate)];
    [_iv_certificate addGestureRecognizer:tap_certificate];
    _iv_certificateDelete.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap_certificateDelete=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_CertificateDelete)];
    [_iv_certificateDelete addGestureRecognizer:tap_certificateDelete];
    
}
-(void)tap_IDPositive{
    _TapType=0;
    [self showImagePickerView];

}
-(void)tap_IDPositiveDelete{
    _imagePositive=nil;
    _iv_IDPositive.image=[UIImage imageNamed:@"certification_add"];
    _iv_IDPositiveDelete.hidden=YES;
}
-(void)tap_IDReverse{
    _TapType=1;
    [self showImagePickerView];

}
-(void)tap_IDReverseDelete{
    _imageReverse=nil;
    _iv_IDReverse.image=[UIImage imageNamed:@"certification_add"];
    _iv_IDReverseDelete.hidden=YES;
}
-(void)tap_Certificate{
    _TapType=2;
    [self showImagePickerView];
    
}
-(void)tap_CertificateDelete{
    _imageCertificate=nil;
    _iv_certificate.image=[UIImage imageNamed:@"certification_add"];
    _iv_certificateDelete.hidden=YES;
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
    if (_TapType==0) {
        _iv_IDPositive.image=img_select;
        _imagePositive=img_select;
        _iv_IDPositiveDelete.hidden=NO;
    }else if(_TapType==2){
        _iv_certificate.image=img_select;
        _imageCertificate=img_select;
        _iv_certificateDelete.hidden=NO;
        
    }else{
        _iv_IDReverse.image=img_select;
        _imageReverse=img_select;
        _iv_IDReverseDelete.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btn_submit_press:(id)sender {
    if(_imageReverse !=nil && _imagePositive !=nil){
        [_retrunImageUrl removeAllObjects];
        [ProgressHUD showProgressHUDWithInfo:@"上传中"];
            [_baseService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:_imagePositive  type:2 success:^(id responseObject, NSInteger code) {
//                [ProgressHUD hideProgressHUD];
                [ProgressHUD showProgressHUDWithInfo:@"上传中"];
                if (code != 1) {
                    return ;
                }
                [_retrunImageUrl addObject:responseObject[@"datas"]];
                [_baseService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:_imageReverse  type:2 success:^(id responseObject, NSInteger code) {
//                    [ProgressHUD hideProgressHUD];
                    [ProgressHUD showProgressHUDWithInfo:@"上传中"];
                    if (code != 1) {
                        return ;
                    }
                    [_retrunImageUrl addObject:responseObject[@"datas"]];
                    
                    if (_imageCertificate != nil) {
                        [_baseService uploadImageWithUrl:ACTION_COMMON_UPLOAD_IMG image:_imageCertificate  type:2 success:^(id responseObject, NSInteger code) {
                            if (code != 1) {
                                return ;
                            }
                            [ProgressHUD hideProgressHUD];
                            [_retrunImageUrl addObject:responseObject[@"datas"]];
                            [_producerService  authProducerWithIDFronUrlString:[_retrunImageUrl objectAtIndex:0] IDBackUrlString:[_retrunImageUrl objectAtIndex:1] CertificateUrlString: [_retrunImageUrl objectAtIndex:2] result:^(NSInteger code) {
                                if (code != 1) {
                                    [ProgressHUD showInfo:@"提交失败" withSucc:NO withDismissDelay:2];
                                    return;
                                }
                                if([self.parameters[kPageType] integerValue]==1){
                                    //返回订单详情
                                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Bid_Cerification object:nil];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
                                }else{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
                                }
                                [ProgressHUD showInfo:@"上传成功" withSucc:YES withDismissDelay:2];
                                NSArray *tmpArray = self.navigationController.viewControllers;
                                UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 3];
                                [self.navigationController popToViewController:vc animated:YES];
                                
                            }];
                            
                        } fail:^{
                            [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
                            
                        }];
                    } else {
                        [_producerService  authProducerWithIDFronUrlString:[_retrunImageUrl objectAtIndex:0] IDBackUrlString:[_retrunImageUrl objectAtIndex:1] CertificateUrlString: @"" result:^(NSInteger code) {
                            if (code != 1) {
                                [ProgressHUD showInfo:@"提交失败" withSucc:NO withDismissDelay:2];
                                return;
                            }
                            if([self.parameters[kPageType] integerValue]==1){
                                //返回订单详情
                                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Bid_Cerification object:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
                            }else{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Certification_NOTIFICATION" object:nil];
                            }
                            [ProgressHUD showInfo:@"上传成功" withSucc:YES withDismissDelay:2];
                            NSArray *tmpArray = self.navigationController.viewControllers;
                            UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 3];
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }];
                    }
                } fail:^{
                    [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
                    
                }];
                
            } fail:^{
                [ProgressHUD showInfo:@"上传失败" withSucc:NO withDismissDelay:2];
                
            }];
        
    }else{
        [ProgressHUD showInfo:@"请上传手持身份证正反照和资格证书" withSucc:NO withDismissDelay:2];
    }
    
}

@end
