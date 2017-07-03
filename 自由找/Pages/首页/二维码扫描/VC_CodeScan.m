//
//  VC_CodeScan.m
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CodeScan.h"
#import <AVFoundation/AVFoundation.h>
#import "VC_ScanResult.h"
#import "Masonry.h"

@interface VC_CodeScan ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BaseService *_baseService;
}

@property (strong, nonatomic) UIView *boxView;

@property (strong, nonatomic) CALayer *scanLayer;

- (BOOL)startReading;
- (void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;

//展示的layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation VC_CodeScan

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"扫描二维码";
    _v_back.frame = self.view.bounds;
    [self zyzOringeNavigationBar];
    _baseService = [BaseService sharedService];
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        [JAlertHelper jAlertWithTitle:errorStr message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"去打开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self goBack];
            } else {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startReading];
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input    = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    //2.用captureDevice创建输入流
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    //4.1将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2 将媒体输出流添加到会话
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //6实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_v_back.bounds];
    
    
    
    CGRect scanRect = CGRectMake(_v_back.bounds.size.width * 0.2f, _v_back.bounds.size.height * 0.2f, _v_back.bounds.size.width - _v_back.bounds.size.width * 0.4f, _v_back.bounds.size.width - _v_back.bounds.size.width * 0.4f);
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, _v_back.bounds.size.width, _v_back.bounds.size.height) cornerRadius:0];
    
    //    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100,100,2.0*radius,2.0*radius) cornerRadius:radius];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:scanRect];
    
    [path appendPath:rectPath];
    
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    
    fillLayer.path = path.CGPath;
    
    fillLayer.fillRule =kCAFillRuleEvenOdd;
    
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    
    fillLayer.opacity =0.7;
    
    [_videoPreviewLayer addSublayer:fillLayer];
    
    //9.将图层添加到预览view的图层上
    [_v_back.layer addSublayer:_videoPreviewLayer];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.view.width - 40, 65)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"1.发布项目在电脑浏览器打开http://fb.ziyouzhao.com，并扫描页面中的二维码\n2.也可以作为二维码扫描工具使用";
//    [_v_back addSubview:label];
    
    //10.设置扫描框
    //    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    //    captureMetadataOutput.rectOfInterest = CGRectMake(0.2, 0.2, scanRect.size.width / _v_back.width, scanRect.size.height / _v_back.height);
    
    CGSize size = self.view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        captureMetadataOutput.rectOfInterest = CGRectMake((scanRect.origin.y + fixPadding)/fixHeight,
                                                          scanRect.origin.x/size.width,
                                                          scanRect.size.height/fixHeight,
                                                          scanRect.size.width/size.width);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        captureMetadataOutput.rectOfInterest = CGRectMake(scanRect.origin.y/size.height,
                                                          (scanRect.origin.x + fixPadding)/fixWidth,
                                                          scanRect.size.height/size.height,
                                                          scanRect.size.width/fixWidth);
    }
    
    
    
    //    CGRectMake((ScreenWidth-220)/2,60+64,220, 220)
    //    CGRectMake((124)/ScreenHigh,((ScreenWidth-220)/2)/ScreenWidth,220/ScreenHigh,220/ScreenWidth)
    //10.1扫描框
    _boxView = [[UIView alloc] initWithFrame:scanRect];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [_v_back addSubview:_boxView];
    
    //10.2扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        [self stopReading];
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *result = [metadataObj stringValue];
            [self verfityResult:result];
            
            
            
//            [ProgressHUD showProgressHUDWithInfo:@""];
//            NSDictionary *paramDic = @{@"Param1": result, @"Param2": [CommonUtil getUserDomain].UserId};
//            [HttpUtil postJSONWithUrl_1:NEW_SCAN_LOGIN_URL parameters:paramDic success:^(id responseObject) {
//                [ProgressHUD hideProgressHUD];
//                if ([HttpUtil rightData:responseObject]) {
//                    [self performSelectorOnMainThread:@selector(pushToResultViewController) withObject:nil waitUntilDone:NO];
//                } else {
//                    [ProgressHUD showInfo:@"验证失败，请稍后再试" withSucc:NO withDismissDelay:3];
//                    [self performSelector:@selector(reScan) withObject:nil afterDelay:3];
//                }
//            } fail:^{
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
        }
    }
}

- (void)verfityResult:(NSString *)result {
    NSString *loginCodeRegex = @"[a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){3}-[a-fA-F0-9]{12}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginCodeRegex];
    if ([emailPredicate evaluateWithObject:result]) {
        //登录
        [_baseService loginWithScanCode:result result:^(NSInteger code) {
            if (code == 1) {
                NSDictionary *paramDic = @{kPageType: @0};
                [self performSelectorOnMainThread:@selector(pushToResultViewController:) withObject:paramDic waitUntilDone:NO];
            } else {
                [JAlertHelper jAlertWithTitle:@"登录出现错误" message:nil cancleButtonTitle:@"退出" OtherButtonsArray:@[@"重新扫描"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self goBack];
                    } else {
                        [self reScan];
                    }
                }];
            }
        }];
        
    } else {
        if ([result hasPrefix:@"http"] || [result hasPrefix:@"www"]) {
            if ([result hasPrefix:@"www"]) {
                result = [NSString stringWithFormat:@"http://%@", result];
            }
            NSURL *url = [NSURL URLWithString:result];
            [[UIApplication sharedApplication] openURL:url];
            [self performSelectorOnMainThread:@selector(reScan) withObject:nil waitUntilDone:NO];
        } else {
            NSDictionary *paramDic = @{kPageDataDic: result, kPageType: @1};
            [self performSelectorOnMainThread:@selector(pushToResultViewController:) withObject:paramDic waitUntilDone:NO];
        }
    }
}

- (void)reScan {
    [self startReading];
}

- (void)pushToResultViewController:(NSDictionary *)paramDic {
    //展示出来
    [PageJumpHelper pushToVCID:@"VC_ScanResult" storyboard:Storyboard_Main parameters:paramDic parent:self];
}

- (void)moveScanLayer:(NSTimer *)timer {
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    } else {
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
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
