//
//  YijiPayLib.h
//  YijiPayLib
//
//  Created by Luochun on 15/8/25.
//  Copyright (c) 2015年 SpringLo. All rights reserved.
//


/**
 *易手富版本号
 */
FOUNDATION_EXTERN NSString* const YijiPaySDKVerison;

/****************启动参数定义 **************/


/**
 *  合作商户账户ID，由商户向易极付申请，必需参数
 */
extern NSString* const kYjParamPartnerID;

/**
 *  签名key, 由商户向易极付申请, 必需参数
 */
extern NSString* const kYjParamSignKey;


/**
 *  订单号，由易极付后台生成，支付必需参数
 */
extern NSString* const kYjParamTradeOrderID;



/**
 *  会员ID号，由商户平台创建的ID，银行卡管理必需参数
 */
extern NSString* const kYjParamUserID;


/**
 *  绑卡或支付信息 格式:卡号#姓名#身份证#手机号码   非必传参数
 *  (如果没有卡号，则“#姓名#身份证#手机号码”)
 *  (如果没有姓名和身份证号，则“卡号###手机号码”)
 *  (如果没有手机号码和卡号，则“#姓名#身份证#”)
*/
extern NSString* const kYjUserExtraInfo;


/**
 *  返回状态码 "200":成功，"201":交易中，"300":取消，"400":失败，"401":数据异常（校验失败、参数错误等）
 */
extern NSString* const kYjResultStatus;

/**
 *  返回信息或提示，可用于显示
 */
extern NSString* const kYjResultMessage;


/**
 *  支付回调
 */
@protocol YJEPayDelegate <NSObject>
@required
/**
 *  易极付支付结果回调
 *  @result result 结果信息
 */
- (void)YJEPayResult:(NSDictionary *)result;

@end


@interface YijiPayLib : NSObject



/**
 *  @brief 支付接口
 *  @param params 调用参数
 *  @param viewController 切入回调的UIViewController，支付返回时会回到此界面
 *  @param delegate 交易成功与否会调用此代理的接口
 
 * @return 返回
 * YES 调用插件成功
 * NO  调用插件失败
 */
+ (BOOL)startPay:(NSDictionary *)params viewController:(UIViewController *)viewController delegate:(id<YJEPayDelegate>)delegate;

/**
 *  银行卡管理
 *
 *  @param params 必传参数
 *
 *  @return YES：成功
 */
+ (BOOL)bindCardWithParams:(NSDictionary *)params;
@end
