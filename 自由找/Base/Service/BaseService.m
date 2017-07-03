//
//  BaseService.m
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "BaseService.h"
#import "ResponseHelper.h"
#define ORIGINAL_MAX_WIDTH 720
#define kAvaterName @"avater"

@implementation BaseService

+(instancetype)sharedService {
    return [[self alloc] init];
}

- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [self customSecurityPolicy];
    NSString *sessionkey = (NSString *)[CommonUtil objectForUserDefaultsKey:kUserSessionKey];
    if (sessionkey != nil) {
        [manager.requestSerializer setValue:sessionkey forHTTPHeaderField:kUserSessionKey];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:kUserSessionKey];
    }
    return manager;
}

- (AFHTTPSessionManager *)sessionManager_2 {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [self customSecurityPolicy];
    NSString *sessionkey = (NSString *)[CommonUtil objectForUserDefaultsKey:kUserSessionKey];
    if (sessionkey != nil) {
        [manager.requestSerializer setValue:sessionkey forHTTPHeaderField:kUserSessionKey];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:kUserSessionKey];
    }
    return manager;
}

- (void)httpRequestWithUrl:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    [self httpRequestWithType:HTTP_POST hud:YES parameters:nil url:urlStr success:success fail:fail];
}

- (void)httpRequestWithType:(NSString *)type url:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    [self httpRequestWithType:type hud:YES parameters:nil url:urlStr success:success fail:fail];
}

- (void)httpRequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    [self httpRequestWithType:HTTP_POST hud:YES parameters:parameters url:urlStr success:success fail:fail];
}

- (void)backgroundRequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    [self httpRequestWithType:HTTP_POST hud:NO parameters:parameters url:urlStr success:success fail:fail];
}

- (void)httpRequestWithType:(NSString *)type hud:(BOOL)show parameters:(id)parameters url:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail {
    if (show) {
        [ProgressHUD showProgressHUDWithInfo:@""];
    }
    NSString *url = [HOST stringByAppendingString:urlStr];
    AFHTTPSessionManager *manager = [self sessionManager];
    if (type == nil || [type equals:@""]) {
        type = HTTP_POST;
    }
    if ([type equals:HTTP_POST]) {
        [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self httpSuccessObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self httpError:error fail:fail];
        }];
        
    }  else if ([type equals:HTTP_GET]) {
        [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self httpSuccessObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self httpError:error fail:fail];
        }];
    } else {
        [ProgressHUD hideProgressHUD];
        [ProgressHUD showInfo:@"提交方式只能为GET或者POST！" withSucc:NO withDismissDelay:4];
    }
}

/**
 *  http提交2 ---   错误信息同时返回，临时使用，后续修改
 *
 *  @param type       <#type description#>
 *  @param show       <#show description#>
 *  @param parameters <#parameters description#>
 *  @param urlStr     <#urlStr description#>
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)http2RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail {
    [ProgressHUD showProgressHUDWithInfo:@""];
    NSString *url = [HOST_2 stringByAppendingString:urlStr];
    AFHTTPSessionManager *manager = [self sessionManager_2];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self httpSuccessObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self httpError:error fail:fail];
    }];
};

/**
 *  后台提交提交2-不显示HUD---   新版本功能使用的接口  -- 技术标、预算、钱包等
 *
 *  @param urlStr     <#urlStr description#>
 *  @param parameters parameters description
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)background2RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    NSString *url = [HOST_2 stringByAppendingString:urlStr];
    AFHTTPSessionManager *manager = [self sessionManager_2];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self httpSuccessObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self httpError:error fail:fail];
    }];
}

/**
 基本处理类别
 
 @param baseUrlString HOST+端口号
 @param actionName    接口名
 @param parameters    <#parameters description#>
 @param success       <#success description#>
 @param fail          <#fail description#>
 */
- (void)httpBaseUrlString:(NSString *)baseUrlString actionString:(NSString *)actionName showHUD:(BOOL)show parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    if (show) {
        [ProgressHUD showProgressHUDWithInfo:@""];
    }
    NSString *url = [baseUrlString stringByAppendingString:actionName];
    AFHTTPSessionManager *manager = [self sessionManager_2];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self httpSuccessObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self httpError:error fail:fail];
    }];
}

- (void)http3RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail {
    [self httpBaseUrlString:HOST_3 actionString:urlStr showHUD:YES parameters:parameters success:success fail:fail];
};

/**
 *  后台提交提交3-不显示HUD---   新版本功能使用的接口  -- 技术标、预算、钱包等
 *
 *  @param urlStr     <#urlStr description#>
 *  @param parameters parameters description
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)background3RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    [self httpBaseUrlString:HOST_3 actionString:urlStr showHUD:NO parameters:parameters success:success fail:fail];
}

- (void)httpSuccessObject:(id)object success:(void (^)(id responseObject, NSInteger code))success {
    [ProgressHUD hideProgressHUD];
    if (success) {
        //        NSString *dataString = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
        NSInteger code = [[object objectForKey:kResponseCode] integerValue];
        if (code != 1) {
            //处理错误信息
            [ResponseHelper handleResponseErrorData:object];
        }
        success(object, code);
    }
}

- (void)httpError:(NSError *)error fail:(void (^)(id errorObject))fail {
    [ProgressHUD hideProgressHUD];
//    NSLog(@"%@", [error.userInfo objectForKey:@"NSLocalizedDescription"]);
    NSString *errorInfo = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if (errorInfo != nil) {
        [ProgressHUD showInfo:errorInfo withSucc:NO withDismissDelay:2];
    }
    fail(error);
}

- (void)getHtmlStringWithUrl:(NSString *)urlStr success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    [ProgressHUD showProgressHUDWithInfo:@""];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            success(dataString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self httpError:error fail:fail];
    }];
    
}

- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image type:(NSInteger)type success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail {
    NSString *url = [NSString stringWithFormat:@"%@%@/%ld", HOST, urlStr, type];
     [ProgressHUD showProgressHUDWithInfo:@"上传中"];
    //图片压缩
    UIImage *newImage = [self imageByScalingToMaxSize:image];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.securityPolicy = [self customSecurityPolicy];
    NSString *sessionkey = (NSString *)[CommonUtil objectForUserDefaultsKey:kUserSessionKey];
    if (sessionkey != nil) {
        [manager.requestSerializer setValue:sessionkey forHTTPHeaderField:kUserSessionKey];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:kUserSessionKey];
    }
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     //设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    
    [manager POST:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(newImage) name:@"ImgParameter" fileName:kAvaterName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self httpSuccessObject:responseObject success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self httpError:error fail:fail];
    }];
}
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)showResponseMsg:(NSDictionary *)responseObject {
    
}

- (void)showResponseMsg:(NSDictionary *)responseObject delay:(double)delay {
    
}

+ (BOOL)rightResponse:(NSDictionary *)response {
    if ([[response objectForKey:kResponseCode] integerValue] == 1) {
        return YES;
    }
    return NO;
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ziyouzhao" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    return securityPolicy;
}

- (BOOL)rightResponse:(NSDictionary *)response {
    return YES;
}

- (void)getCodeWithPhone:(NSString *)phone type:(NSString *)type result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{kCodePhone: phone, kCodeType: type};
    [self httpRequestWithUrl:ACTION_COMMON_GET_CODE parameters:paramDic success:^(id responseObject, NSInteger code) {
//        NSString *code = [[responseObject objectForKey:kResponseDatas] objectForKey:kCodeCode];
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)getRegionToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_GET_REGION success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_region = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_region addObject:domain];
            }
            result(arr_region, code);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)getProjectTypeToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_GET_PROJECTTYPE success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_type addObject:domain];
            }
            result(arr_type, code);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)getQualitificationWithType:(int )type result:(void (^)(NSArray *qualityList, NSInteger code))result {
    NSDictionary *paramDic = @{kCommonType: @(type)};
    [self httpRequestWithUrl:ACTION_COMMON_GET_QUALIFICATION parameters:paramDic success:^(id responseObject, NSInteger code) {
//        NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//        NSMutableArray *arr_quality = [NSMutableArray arrayWithCapacity:tmpArray.count];
//        for (NSDictionary *tmpDic in tmpArray) {
//            QualityDomain *quality = [QualityDomain domainWithObject:tmpDic];
//            [arr_quality addObject:quality];
//        }
        result([responseObject objectForKey:kResponseDatas], code);
    } fail:^{
        result(nil, 0);
    }];
}

- (void)checkUpdateWithVersion:(NSInteger)version ToResult:(void (^)(AppInfoDomain *appInfo, NSInteger code))result {
    NSDictionary *paramDic = @{kCommonVersionNo: @(version), kCommonMachineType: @0};
    [self backgroundRequestWithUrl:ACTION_COMMON_CHECK_UPDATE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            AppInfoDomain *appInfo = [AppInfoDomain domainWithObject:[responseObject objectForKey:kResponseDatas]];
            result(appInfo, code);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

-(void)feedBackWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_COMITTE_ADVISE parameters:parameters success:^(id responseObject, NSInteger code) {
        //提交成功，反馈完成
        result(code);
    } fail:^{
        result(0);
    }];
    
}

/**
 *  获取banner图片
 *
 *  @param result <#result description#>
 */
- (void)getBannerToResult:(void (^)(NSArray *bannerList, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_COMMON_BANNER parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(responseObject[kResponseDatas], code);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

/**
 *  获取评价原因
 *
 *  @param type    1 发布   2 报名
 *  @param result <#result description#>
 */
- (void)getAssesReasonWithType:(NSInteger)type result:(void (^)(NSArray<KeyValueDomain *> *info, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_GET_REASION parameters:@{kCommonType: @(type)} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_reason = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_reason addObject:domain];
            }
            result(arr_reason, code);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

/**
 *  获取消息未读数
 *
 *  @param result <#result description#>
 */
- (void)getMessageCountWithResult:(void (^)(NSInteger count, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_COMMON_GET_MSG_COUNT parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSInteger count = [[[responseObject objectForKey:kResponseDatas] objectForKey:@"Unum"] integerValue];
            result(count, code);
        } else {
            result(0, code);
        }
    } fail:^{
        result(0, 0);
    }];
}

/**
 *  获取我的发布新增报名未读数
 *
 *  @param result <#result description#>
 */
- (void)getMinePublishCountWithResult:(void (^)(NSInteger count, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_COMMON_GET_MINE_COUNT parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSInteger count = [[[responseObject objectForKey:kResponseDatas] objectForKey:@"Total"] integerValue];
            result(count, code);
        } else {
            result(0, code);
        }
    } fail:^{
        result(0, 0);
    }];
}

/**
 *  二维码扫描登录
 *
 *  @param scanCode <#scanCode description#>
 */
- (void)loginWithScanCode:(NSString *)scanCode result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_GET_MINE_COUNT parameters:@{@"Param1": scanCode}  success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  统计首页感兴趣和不感兴趣
 *
 *  @param type   1 技术  2 预算
 *  @param data    0 没兴趣  1 有兴趣
 *  @param result <#result description#>
 */
- (void)countHomeDataWithInterestType:(NSInteger)type isInterest:(NSInteger)data result:(void (^)(NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_HOME_COUNT parameters:@{@"InterestType": @(type), @"IsInterest": @(data)} success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

/**
 *  统计 -- 查阅统计
 *
 *  @param type     <#type description#>
 *  @param recordID <#recordID description#>
 */
- (void)countViewsWithType:(NSInteger)type recordID:(NSString *)recordID {
    NSDictionary *paramDic = @{@"Type":@(type), @"RecordID": recordID};
    [self backgroundRequestWithUrl:ACTION_COUNT_VIEW parameters:paramDic success:^(id responseObject, NSInteger code) {
    } fail:^{
    }];
}

/**
 *  统计 -- 拨打电话
 *
 *  @param type      <#type description#>
 *  @param recordID  <#recordID description#>
 *  @param direction <#direction description#>
 *  @param phone     <#phone description#>
 */
- (void)countCallWithType:(NSInteger)type recordID:(NSString *)recordID direction:(NSInteger)direction phone:(NSString *)phone {
    NSDictionary *paramDic = @{@"Type":@(type), @"RecordID": recordID, @"Direction": @(direction), @"Phone": phone};
    [self backgroundRequestWithUrl:ACTION_COUNT_CALL parameters:paramDic success:^(id responseObject, NSInteger code) {
        NSLog(@"成功");
    } fail:^{
        NSLog(@"失败");
    }];
    
//    [self http2RequestWithUrl:ACTION_COUNT_CALL parameters:paramDic success:^(id responseObject) {
//        ;
//    } fail:^(id errorObject) {
//        
//    }];
}


@end
