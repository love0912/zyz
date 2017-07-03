//
//  ActionDefine.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#ifndef ActionDefine_h
#define ActionDefine_h
/*
 *purelayout
 */
#define JLayoutView(V) [V newAutoLayoutView]

#define HTTP_POST @"POST"
#define HTTP_GET @"GET"
 
/**
 *  请求主机地址
 */
//#define HOST @"http://test.ziyouzhao.com:8021"
//#define HOST @"http://jk.ziyouzhao.com:8061"

//发布地址
#define HOST @"https://jk.ziyouzhao.com:8066"
//新版测试地址
//#define HOST @"http://www.ziyouzhao.com:8701"

//#define HOST_2 @"https://test.ziyouzhao.com:8082"
//#define HOST_2 @"https://jk.ziyouzhao.com:8083"
//#define HOST_2 @"http://192.168.31.39:8081"
#define HOST_2 @"https://jk.ziyouzhao.com:8086"

#define HOST_3 HOST_2
//#define HOST_3 @"https://jk.ziyouzhao.com:8083"

//#define HTML_BASE_HOST @"http://test.ziyouzhao.com"
#define HTML_BASE_HOST @"http://jk.ziyouzhao.com:8042"


//#define HOST @"http://192.168.31.133:8031"
//#define HOST @"http://192.168.31.184:8021"

/**
 *  用户注册
 */
#define ACTION_USER_REGIST @"/ZYZMkt.service/api/user/register"

/**
 *  用户登录
 */
#define ACTION_USER_LOGIN @"/ZYZMkt.service/api/user/login"

/**
 *  用户修改资料
 */
#define ACTION_USER_MODIFY @"/ZYZMkt.service/api/user/change"

/**
 *  自动登录验证
 */
#define ACTION_USER_AUTO_LOGIN @"/ZYZMkt.service/api/user/get"

/**
 *  重置密码
 */
#define ACTION_USER_RESET_PASSWORD @"/ZYZMkt.service/api/common/dic/resetpsw"

/**
 *  退出登录
 */
#define ACTION_USER_LOGOUT @"/ZYZMkt.service/api/user/logout"
/**
 *  消息
 */
#define ACTION_Get_Messages @"/ZYZMkt.service/api/common/dic/getmsg"
/**
 *  读消息
 */
#define ACTION_SET_MESSAGE_READED @"/ZYZMkt.service/api/common/dic/msgread"
/**
 *  删除消息
 */
#define ACTION_SET_MESSAGE_Delete @"/ZYZMkt.service/api/common/dic/delmsg"
/**
 *  绑定企业
 */
#define ACTION_USER_BINDCOMPANY @"/ZYZMkt.service/api/user/addcompany"

/**
 *  解除绑定企业
 */
#define ACTION_USER_UNBINDCOMPANY @"/ZYZMkt.service/api/user/removecompany"
/**
 *  认领企业
 */
#define ACTION_USER_Claim @"/ZYZMkt.service/api/user/claim"

/**
 *  认领企业 -- 从资质详情页跳转
 */
#define ACTION_USER_Claim_FromCompanyDetail @"/ZYZMkt.service/api/user/bindingclaim"
/**
 *   修改认领企业经营区域
 */
#define ACTION_USER_changecompanyregion @"/ZYZMkt.service/api/user/changecompanyregion"
/**
 *  没有查询到企业之后，添加新企业到数据库
 */
#define ACTION_COMPANY_ADD @"/ZYZMkt.service/api/entuser/entregister"

/**
 *  修改企业信息
 */
#define ACTION_COMPANY_MODIFY @"/ZYZMkt.service/api/entuser/Update"

/**
 *  我的积分明细
 */
#define ACTION_MINE_SCORE @"/ZYZMkt.service/api/user/scorelist"

/**
 *  查询企业
 */
#define ACTION_COMPANY_QUERY @"/ZYZMkt.service/api/enterprises/searchbyname"

/**
 *  企业展示
 */
#define ACTION_COMPANY_SHOW @"/ZYZMkt.service/api/enterprises/all"
/**
 *  诚信得分
 */
#define ACTION_COMMON_CREDIT @"/ZYZMkt.service/api/common/dic/creditsetting"
/**
 *  获取诚信得分分类
 */
#define ACTION_COMMON_CREDIT_TYPE @"/ZYZMkt.service/api/common/dic/creditsetting"

/**
 *  企业展示－最近注册
 */
#define ACTION_COMPANY_REGIST @"/ZYZMkt.service/api/enterprises/lastest"

/**
 *  发布招投标项目
 */
#define ACTION_BID_ADD @"/ZYZMkt.service/api/bidding/publish"

/**
 *  查询招投标项目--列表
 */
#define ACTION_BID_LIST @"/ZYZMkt.service/api/bidding/publishlist"

/**
 *  查询招投标项目--单个列表数据
 */
#define ACTION_BID_LIST_BYID @"/ZYZMkt.service/api/bidding/projectenrollinfo"

/**
 *  查询招投标项目--明细
 */
#define ACTION_BID_DETAIL @"/ZYZMkt.service/api/bidding/detail"

/**
 *  查询招投标项目--查看符合我项目的企业
 */

#define ACTION_BID_VIEW_BIDCOMPANY @"/ZYZMkt.service/api/bidding/getcompanyforproject"

/**
 *  关注招投标项目
 */
#define ACTION_BID_ATTENTION @"/ZYZMkt.service/api/bidding/attention"

/**
 *  我的发布,招投标项目
 */
#define ACTION_USER_PUBLISH @"/ZYZMkt.service/api/analysis/publishlist"

/**
 *  我的发布--删除发布
 */
#define ACTION_USER_PUBLISHDELETE @"/ZYZMkt.service/api/analysis/publishdelete"

/**
 *  我的发布--发布完成
 */
#define ACTION_USER_PUBLISHCOMPLETE @"/ZYZMkt.service/api/analysis/publishcomplete"

/**
 *  我的发布--修改发布
 */
#define ACTION_USER_PUBLISHEDITE @"/ZYZMkt.service/api/analysis/publishedite"

/**
 *  关注用户列表
 */
#define ACTION_USER_ATTENTIONUSER @"/ZYZMkt.service/api/analysis/check"

/**
 *  关注用户列表 --  评分
 */
#define ACTION_USER_ATTENTIONUSER_SCORE @"/ZYZMkt.service/api/analysis/publishrank"

/**
 *  查看用户列表—标记 （动作）
 */
#define ACTION_USER_CHECKMARK @"/ZYZMkt.service/api/analysis/mark"

/**
 *  查看用户列表—退回 （动作）
 */
#define ACTION_USER_CHECKBACK @"/ZYZMkt.service/api/analysis/attentionback"

/**
 *  我的关注
 */
#define ACTION_USER_ATTENTIONLIST @"/ZYZMkt.service/api/analysis/attentionlist"

/**
 *  我的关注--撤回
 */
#define ACTION_USER_ATTENTIONCANCEL @"/ZYZMkt.service/api/analysis/attentionrcancel"

/**
 *  我的关注--删除
 */
#define ACTION_USER_ATTENTIONDELETE @"/ZYZMkt.service/api/analysis/attentiondelete"

/**
 *  我的关注--完成
 */
#define ACTION_USER_ATTENTIONCOMPLETE @"/ZYZMkt.service/api/analysis/attentioncomplete"

/**
 *  我的关注--沟通完成
 */
#define ACTION_USER_COMUNICATEDATTENTION @"/ZYZMkt.service/api/analysis/attentionmark"

/**
 *  我的关注 -- 评分
 */
#define ACTION_USER_ASSESSBID @"/ZYZMkt.service/api/analysis/applyrank"

/**
 *  我的 ---  导出报名用户
 */
#define ACTION_USER_ENROLLEXPORT @"/ZYZMkt.service/api/analysis/enrollexport"

/**
 *  我的 ---  导出我报名的项目
 */
#define ACTION_USER_PROJECTEXPORT @"/ZYZMkt.service/api/analysis/projectexport"

/**
 *  用户信息—检查账号是否可用
 */
#define ACTION_USER_ACCOUNTCHECK @"/ZYZMkt.service/api/user/accountcheck"

/**
 *  企业用户注册和资料编辑
 *  用户身份获取方式
 */
#define ACTION_COMPANY_USERIDENTITY @"/ZYZMkt.service/api/user/defaultidentity"

/**
 *  用户信息—企业用户注册
 */
#define ACTION_COMPANY_USERREGISYT @"/ZYZMkt.service/api/user/enterpriseregister"

/**
 *  获取经营人员信息
 */
#define ACTION_USER_MANAGERSINFO @"/ZYZMkt.service/api/user/managersinfo"

/**
 *  我的客户--新增
 */
#define ACTION_CUSTOMER_ADD @"/ZYZMkt.service/api/user/addcustomer"

/**
 *  我的客户-查看列表
 */
#define ACTION_CUSTOMER_LIST @"/ZYZMkt.service/api/user/customerlist"

/**
 *  我的客户-查看详情（编辑时原始值）
 */
#define ACTION_CUSTOMER_DETAILS @"/ZYZMkt.service/api/user/customerdetails"

/**
 *  我的客户-编辑
 */
#define ACTION_CUSTOMER_EDIT @"/ZYZMkt.service/api/user/customeredit"

/**
 *  我的客户-删除合作企业
 */
#define ACTION_CUSTOMER_DELETE @"/ZYZMkt.service/api/user/customerdelete"

/**
 *  我的客户--编辑--删除(增项)资质
 */
#define ACTION_CUSTOMEREDIT_QUALIFICATIONDELETE @"/ZYZMkt.service/api/user/qualificationdelete"

/**
 *  我的客户--编辑--新增资质
 */
#define ACTION_CUSTOMEREDIT_QUALIFICATIONDADD @"/ZYZMkt.service/api/user/qualificationadd"

/**
 *  项目合作-发布项目
 */
#define ACTION_PROJECT_PUBLISH @"/ZYZMkt.service/api/cooperation/publish"

/**
 *  项目合作-获取指定项目
 */
#define ACTION_PROJECT_GET @"/ZYZMkt.service/api/cooperation/get"

/**
 *  项目合作-删除指定项目
 */
#define ACTION_PROJECT_DELETE @"/ZYZMkt.service/api/cooperation/remove"

/**
 *  项目合作-获取全部项目
 */
#define ACTION_PROJECT_LIST @"/ZYZMkt.service/api/cooperation/getall"

/**
 *  项目合作- 修改指定项目
 */
#define ACTION_PROJECT_EDIT @"/ZYZMkt.service/api/cooperation/edit"

/**
 *  公共 -- 获取验证码
 */
#define ACTION_COMMON_GET_CODE @"/ZYZMkt.service/api/common/dic/phonevercode"

/**
 *  公共 -- 获取区域
 */
#define ACTION_COMMON_GET_REGION @"/ZYZMkt.service/api/common/dic/region"

/**
 *  查询 -- 获取区域带简称
 */
#define ACTION_COMMON_GET_REGION_Alias @"/ZYZMkt.service/api/common/dic/regionalias"

/**
 *  查询 -- 获取工程类别
 */
#define ACTION_NEWQUERY_GET_PROJECT_TYPE @"/ZYZMkt.service/api/common/dic/enterprises/projectcategory"

/**
 *  查询 -- 获取工程用途
 */
#define ACTION_NEWQUERY_GET_PROJECT_APPLICATION @"/ZYZMkt.service/api/common/dic/enterprises/projectapplication"

/**
 *  查询 -- 获取单位
 */
#define ACTINO_NEWQUERY_GET_UNIT @"/ZYZMkt.service/api/common/dic/unitlist"

/**
 *  查询 -- 获取人员类型
 */
#define ACTINO_NEWQUERY_GET_MEMBER_TYPE @"/ZYZMkt.service/api/common/dic/enterprises/techcategory"

/**
 *  查询 -- 获取人员类型数量
 */
#define ACTINO_NEWQUERY_GET_MEMBER_TYPE_COUNT @"/ZYZMkt.service/api/common/dic/enterprises/techcategoryqty"

/**
 *  查询 -- 业绩查询
 */
#define ACTION_NEWQUERY_GET_PERFORMLIST @"/ZYZMkt.service/api/enterprises/performancequery"

/**
 *  查询 -- 资质查询-查询公司
 */
#define ACTION_NEWQUERY_GET_COMPANY @"/ZYZMkt.service/api/enterprises/query"

/**
 *  查询服务 -- 获取查询服务列表
 */
#define ACTION_NEWQUERY_GET_QUERYSERVICE_LIST @"/ZYZMkt.service/api/enterprises/query/servicefeelist"

/**
 *  查询服务 -- 购买查询服务
 */
#define ACTION_BUY_QUERYSERVICE @"/ZYZMkt.service/api/enterprises/query/servicefee/charge"

/**
 *  查询服务 -- 获取人员区域类别
 */
#define ACTION_GET_MEMBER_REGION @"/ZYZMkt.service/api/common/dic/enterprises/membercategory"

/**
 *  公共 -- 获取项目类别
 */
#define ACTION_COMMON_GET_PROJECTTYPE @"/ZYZMkt.service/api/common/dic/projecttype"

/**
 *  公共 -- 获取资质类型
 */
#define ACTION_COMMON_GET_QUALIFICATION @"/ZYZMkt.service/api/common/dic/qualificationtype"

/**
 *  公共 -- 检查版本更新
 */
#define ACTION_COMMON_CHECK_UPDATE @"/ZYZMkt.service/api/common/dic/getversioninfo"
/**
 *  公共 -- 意见和建议
 */
#define ACTION_COMMON_COMITTE_ADVISE @"/ZYZMkt.service/api/common/dic/advise"
/**
 *  公共 -- 上传图片
 */
#define ACTION_COMMON_UPLOAD_IMG @"/ZYZMkt.service/api/utility/imgupload"
/**
 *  公共 -- banner图片
 */
#define ACTION_COMMON_BANNER @"/ZYZMkt.service/api/common/dic/banner"

/**
 *  公共 -- 获取评分的原因
 */
#define ACTION_COMMON_GET_REASION @"/ZYZMkt.service/api/common/dic/getranksetting"

/**
 *  公共 -- 获取未读消息数
 */
#define ACTION_COMMON_GET_MSG_COUNT @"/ZYZMkt.service/api/common/dic/unreadmsg"

/**
 *  公共 -- 获取我的发布新增未查看报名数
 */
#define ACTION_COMMON_GET_MINE_COUNT @"/ZYZMkt.service/api/analysis/signupUnread"

/**
 *  公共 -- 获取帮助列表
 */
#define ACTION_COMMON_HELP @"/ZYZMkt.service/api/common/dic/gethelp"


/**
 *  公共 -- 扫描登录
 */
#define ACTION_SCAN_LOGIN @"/ZYZMkt.service/api/utility/code"

/**
 *  首页 -- 统计是否感兴趣
 */
#define ACTION_HOME_COUNT @"/ZYZMkt.service/api/common/dic/userinterest"

/**
 * 查阅统计
 */
#define ACTION_COUNT_VIEW @"/ZYZMkt.service/api/statistics/view"

/**
 * 电话拨打统计
 */
#define ACTION_COUNT_CALL @"/ZYZMkt.service/api/statistics/call"


#pragma mark - 技术标，预算

/**
 *  产品（包）列表
 */
#define ACTION_PRODUCT_GETLIST @"/zyzoutsourcing.service/api/purchase/productlist"

/**
 *  选择产品 -- 先选择区域
 */
#define ACTION_PRODUCT_REGION @"/zyzoutsourcing.service/api/region/all"
/**
 *  接单 -- 项目类别
 */
#define ACTION_ProjectCategory @"/zyzoutsourcing.service/api/salesorder/ProjectCategory"
/**
 *  产品 -- 创建订单
 */
#define ACTION_PRODUCT_CREATE_ORDER @"/zyzoutsourcing.service/api/purchase/createpo"

/**
 *  产品 -- 获取我的订单
 */
#define ACTION_PRODUCT_GET_OURSELF_ORDER @"/zyzoutsourcing.service/api/purchase/polist"

/**
 *  产品 -- 获取我的订单新接口，包括保函信息
 */
#define ACTION_PRODUCT_GET_OURSELF_ORDER_NEW @"/zyzoutsourcing.service/api/tbbh/myorders"

/**
 *  产品 -- 获取订单详情
 */
#define ACTION_PRODUCT_ORDER_DETAIL @"/zyzoutsourcing.service/api/purchase/podetail"

/**
 *  产品 -- 查看制作人员
 */
#define ACTION_PRODUCT_VIEW_PRODUCER @"/zyzoutsourcing.service/api/purchase/podetail/makerlist"

/**
 *  产品 -- 取消订单
 */
#define ACTION_PRODUCT_CANCEL_ORDER @"/zyzoutsourcing.service/api/purchase/cancel"

/**
 *  产品 -- 支付订单
 */
#define ACTION_PRODUCT_ORDER_PAY @"/zyzoutsourcing.service/api/purchase/pay"

/**
 *  产品 -- 订单退款
 */
#define ACTION_PRODUCT_ORDER_REFUND @"/zyzoutsourcing.service/api/purchase/requestrefund"

/**
 *  产品 -- 获取退款原因
 */
#define ACTION_PRODUCT_ORDER_REFUNDREASON @"/zyzoutsourcing.service/api/purchase/requestrefund/reason"

/**
 *  产品 -- 评价
 */
#define ACTION_PRODUCT_ORDER_Comment @"/zyzoutsourcing.service/api/purchase/comment/reason"
/**
 *  产品 -- 查看退款结果
 */
#define ACTION_PRODUCT_ORDER_REFUNDRESULT @"/zyzoutsourcing.service/api/purchase/refundresult"

/**
 *  产品 -- 评价产品
 */
#define ACTION_PRODUCT_EVALUATE @"/zyzoutsourcing.service/api/comment/pocomment"

/**
 *  产品 -- 查看产品详情，包含（一个评价，评价总数，可接单人数）
 */
#define ACTION_PRODUCT_GET_DETAILS @"/zyzoutsourcing.service/api/comment/viewpocomment/summary"

/**
 *  产品 -- 获取产品评价
 */
#define ACTION_PRODUCT_GET_EVALUATE @"/zyzoutsourcing.service/api/comment/viewpocomment"


/**
 *  钱包 -- 创建钱包
 */
#define ACTION_PAY_CREATE_WALLET @"/zyzoutsourcing.service/api/wallet/create"

/**
 *  钱包 -- 修改支付密码
 */
#define ACTION_PAY_WALLET_MODIFYPASSWORD @"/zyzoutsourcing.service/api/wallet/modify"

/**
 *  钱包 -- 获取验证码
 */
#define ACTION_PAY_WALLET_GET_IDENTIFYCODE @"/zyzoutsourcing.service/api/wallet/IdentifyCode"

/**
 *  钱包 -- 概况
 */
#define ACTION_PAY_WALLET_INFO @"/zyzoutsourcing.service/api/wallet/info"

/**
 *  钱包 -- 收支明细
 */
#define ACTION_PAY_INOUT_DETAIL @"/zyzoutsourcing.service/api/wallet/detail"

/**
 *  钱包 -- 优惠券
 */
#define ACTION_PAY_WALLET_COUPON @"/zyzoutsourcing.service/api/wallet/couponlist"

/**
 *  钱包 -- 充值 -- 请求支付参数
 */
#define ACTION_PAY_REQUEST_PAYINFO @"/zyzoutsourcing.service/api/wallet/inpourrequest"

/**
 *  钱包 -- 充值 -- 检查交易是否成功
 */
#define ACTION_PAY_CHECK_TRADE_SUCCESS @"/zyzoutsourcing.service/api/wallet/inpourcreate"

/**
 *  钱包 -- 提现
 */
#define ACTION_PAY_OUTPOUR @"/zyzoutsourcing.service/api/wallet/outpour"

/**
 *  钱包 -- 提现前手机验证
 */
#define ACTION_PAY_OUTPOUR_VETIFY @"/zyzoutsourcing.service/api/wallet/cashcheck"

/**
 *  钱包 -- 提现 --  银行列表
 */
#define ACTION_PAY_OUTPOUR_BANKLIST @"/zyzoutsourcing.service/api/wallet/banklist"


/**
 *  制作人员 -- 创建认证信息
 */
#define ACTION_PRODUCER_CREATE_AUTH_INFO @"/zyzoutsourcing.service/api/user/create"
/**
 *  制作人员 -- 修改认证信息
 */
#define ACTION_PRODUCER_UPDATE_AUTH_INFO @"/zyzoutsourcing.service/api/user/editprofile"
/**
 *  制作人员 -- 查看详情
 */
#define ACTION_PRODUCER_GET_DETAIL @"/zyzoutsourcing.service/api/user/profile"

/**
 *  制作人员 -- 认证
 */
#define ACTION_PRODUCER_AUTH @"/zyzoutsourcing.service/api/user/auth"
/**
 *  制作人员 -- 擅长领域
 */
#define ACTION_PRODUCER_FoodFiled @"/zyzoutsourcing.service/api/user/expertcategory"


/**
 *  接单 -- 接单列表
 */
#define ACTION_PROJECT_ORDER_GETLIST @"/zyzoutsourcing.service/api/salesorder/list"

/**
 *  接单 -- 申请接单
 */
#define ACTION_PROJECT_ORDER_APPLY @"/zyzoutsourcing.service/api/salesorder/applyorder"

/**
 *  接单 -- 查询接单类别
 */
#define ACTION_PROJECT_ORDER_GetType @"/zyzoutsourcing.service/api/salesorder/productlevel"

///**
// *  接单 -- 申请接单
// */
//#define ACTION_PROJECT_ORDER_APPLY @"/zyzoutsourcing.service/api/salesorder/applyorder"

/**
 *  接单 -- 确认订单
 */
#define ACTION_PROJECT_ORDER_CONFIRM @"/zyzoutsourcing.service/api/salesorder/confirmorder"

/**
 *  接单 -- 我的接单
 */
#define ACTION_PROJECT_ORDER_GET_OURS @"/zyzoutsourcing.service/api/salesorder/mylist"

/**
 *  接单 -- 查看补遗
 */
#define ACTION_PROJECT_ORDER_GET_SUPPLEMENT @"/zyzoutsourcing.service/api/salesorder/additional"

/**
 *  接单 -- 我的收藏
 */
#define ACTION_PROJECT_ORDER_GET_OUR_COLLECTION @"/zyzoutsourcing.service/api/salesorder/myfavorite"

/**
 *  接单 -- 我的收藏
 */
#define ACTION_PROJECT_ORDER_GET_OUR_COLLECTION_NEW @"/zyzoutsourcing.service/api/lybh/myfavorite"
/**
 *  接单 -- 删除收藏
 */
#define ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION @"/zyzoutsourcing.service/api/salesorder/removefavorite"

/**
 *  接单 -- 删除收藏新
 */
#define ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION_NEW @"/zyzoutsourcing.service/api/lybh/removemyfavorite"

/**
 *  接单 -- 收藏
 */
#define ACTION_PROJECT_ORDER_COLLECTION @"/zyzoutsourcing.service/api/salesorder/createfavorite"


#pragma mark - 保函
/**
 *  保函 -- 保函认证
 */
#define ACTION_AUTHERLETTER_AUTHEN @"/zyzoutsourcing.service/api/user/createbaohanauth"
/**
 *  保函 -- 查看保函认证
 */
#define ACTION_VIEW_AUTHENLETTER @"/zyzoutsourcing.service/api/user/viewbaohanauth"

/**
 *  保函 -- 查看履约保函
 */
#define ACTION_GET_LETTERPERFORM_LIST @"/zyzoutsourcing.service/api/lybh/view"

/**
 *  保函 -- 发布履约保函
 */
#define ACTION_CREATE_LETTERPERORM @"/zyzoutsourcing.service/api/lybh/create"

/**
 *  保函 -- 编辑履约保函
 */
#define ACTION_LETTERFORM_EIDT @"/zyzoutsourcing.service/api/lybh/edit"

/**
 *  保函 -- 删除履约保函
 */
#define ACTION_LETTERFORM_DELETE @"/zyzoutsourcing.service/api/lybh/remove"

/**
 *  保函 -- 完成履约保函
 */
#define ACTION_LETTERFORM_FINISH @"/zyzoutsourcing.service/api/lybh/complete"

/**
 *  保函 -- 我的的发布--包括履约保函，招投标
 */
#define ACTION_LETTERPERFORM_GET_OURPUBLISH @"/zyzoutsourcing.service/api/lybh/myview"

/**
 *  保函 -- 收藏履约保函
 */
#define ACTION_LETTERPERFORM_COLLECTION @"/zyzoutsourcing.service/api/lybh/createmyfavorite"

/**
 *  保函 -- 获取投标保函类别
 */
#define ACTION_BIDLETTER_TYPE @"/zyzoutsourcing.service/api/tbbh/category"

/**
 *  保函 -- 获取担保公司类别
 */
#define ACTION_GET_LETTERCOMPANY_TYPE @"/zyzoutsourcing.service/api/dbgs/bizcategory"

/**
 *  保函 -- 获取银行分类
 */
#define ACTION_BANK_TYPE @"/zyzoutsourcing.service/api/bank/category"

/**
 *  保函 -- 找担保公司
 */
#define ACTION_GET_LETTERCOMPANY_LIST @"/zyzoutsourcing.service/api/dbgs/list"

/**
 *  保函 -- 投标保函列表
 */
#define ACTION_BIDLETTER_GETLIST @"/zyzoutsourcing.service/api/tbbh/productlist"

/**
 *  保函 -- 投标保函价格列表
 */
#define ACTION_BIDLETTER_PRICE_GETLIST @"/zyzoutsourcing.service/api/tbbh/segmentprice"

/**
 *  保函 -- 提交订单
 */
#define ACTION_BIDLETTERORDER_SUBMIT @"/zyzoutsourcing.service/api/tbbh/submit"

/**
 *  保函 -- 支付订单
 */
#define ACTION_BIDLETTERORDER_PAY @"/zyzoutsourcing.service/api/tbbh/pay"

/**
 *  保函 -- 获取订单详情
 */
#define ACTION_BIDLETTERORDER_GETDETAIL @"/zyzoutsourcing.service/api/tbbh/podetail"

/**
 *  保函 -- 删除投标保函订单
 */
#define ACTION_BIDLETTERORDER_DELETE @"/zyzoutsourcing.service/api/tbbh/remove"

/**
 *  保函 -- 上传保函资料
 */
#define ACTION_BIDLETTERORDER_UPLOAD @"/zyzoutsourcing.service/api/tbbh/uploadmaterial"

/**
 *  保函 -- 获取我的地址
 */
#define ACTION_LETTERADDRESS_GETLIST @"/zyzoutsourcing.service/api/address/querymyaddress"

/**
 *  保函 -- 添加地址
 */
#define ACTION_LETTERADDRESS_ADD @"/zyzoutsourcing.service/api/address/create"

/**
 *  保函 -- 修改地址
 */
#define ACTION_LETTERADDRESS_EDIT @"/zyzoutsourcing.service/api/address/edit"

/**
 *  保函 -- 删除地址
 */
#define ACTION_LETTERADDRESS_DELETE @"/zyzoutsourcing.service/api/address/remove"

/**
 *  保函 -- 设置默认地址
 */
#define ACTION_LETTERADDRESS_SETDEFAULT @"/zyzoutsourcing.service/api/address/setbedefault"


#pragma mark - 新增
//帮助列表
#define API_GET_HELP_LIST @"/ZYZMkt.service/api/common/dic/helperlist"

#endif /* ActionDefine_h */
