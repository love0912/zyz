//
//  KeyDefine.h
//  自由找
//
//  Created by guojie on 16/6/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#ifndef KeyDefine_h
#define KeyDefine_h

#define kUserSessionKey @"SessionKey"
#define kLastLoginPhone @"LastLoginPhone"
#define kUserID @"UserID"

#define kResponseCode @"code"
#define kResponseMsg @"msg"
#define kResponseDatas @"datas"
#define kPage @"Page"//默认 1

#pragma mark - uitableview 数据
#define kCellImage @"CellImage"
#define kCellName @"CellName"
#define kCellKey @"CellKey"
#define kCellDefaultText @"CellDefaultText"
#define kCellEditType @"CellEditType"
#define EditType_Text @"EditType_Text"
#define EditType_TextField @"EditType_TextField"
#define EditType_DatePicker @"EditType_DatePicker"
#define EditType_TextImage @"EditType_TextImage"
#define EditType_RegionChoice @"EditType_RegionChoice"
#define EditType_GoodFieldChoice @"EditType_GoodFieldChoice"
#define EditType_RegionCompanyTypeChoice @"EditType_RegionCompanyTypeChoice"
#define EditType_CompanyName @"EditType_CompanyName"
//不需要执行操作，占位
#define EditType_None @"EditType_None"
//资质选择
#define EditType_APChoice @"EditType_APChoice"

//诚信选择
#define EditType_CSChoice @"EditType_CSChoice"
//注册地
#define EditType_RegisterAdress @"EditType_RegisterAdress"

#define EditType_ProjectType @"EditType_ProjectType"

#define EditType_KeyValueChoice @"EditType_KeyValueChoice"

#pragma mark - 用户注册注册
#define KRegistUserInfo @"User"
#define kRegistAccount @"Account"
#define kRegistAvater @"Avater"
#define kRegistUserName @"UserName"
#define kRegistPassword @"Password"
#define kRegistInviteCode @"InviteCode"
#define kRegistIdentifyCode @"IdentifyCode"
#define kRegistSites @"Sites"
#define kRegistContact @"Contact"
#define kRegistLocation @"Location"
#define kRegistSetting @"Setting"
#define kRegistDevice @"Device"
#define kSiteEnterprise @"Enterprise"
#define kCompanyAptitudes @"CompanyAptitudes"
#define kContainAptitudes @"ContainAptitudes"
#define kLoginAccount @"Account"
#define kLoginPassword @"Password"
#define kLoginDevice @"Device"
#define kLoginVersion @"Version"
#define kResetPhone @"Phone"
#define kUserHeadImg @"UserHeadImg"

#pragma mark - 消息
#define kMessage_SenderId @"SenderId"
#define kMessage_ReceiverId @"ReceiverId"
#define kMessage_State @"State" 
#define kCondition @"condition"


#pragma mark - 意见与建议
#define kEmail @"Email"
#define kContent @"Content"

#pragma mark - 获取验证码
#define kCodePhone @"Phone"
#define kCodeType @"Type"
#define kCodeCode @"Code"

#pragma mark - 绑定,解绑企业
#define kCompanyID @"CompanyID"
#define kCompanyRegionCode @"RegionCode"
#define kCompanyName @"CompanyName"
//企业名称
#define kEntName @"EntName"
#pragma mark - 招投标项目
#define kBidRegionCode @"RegionCode"
#define kBidRegion @"Region"
#define kBidRegionType @"RegionType"
#define kBidProjectType @"ProjectType"
#define kBidProjectID @"ProjectId"
#define kBidCompanyType @"CompanyType"
#define kBidExactQuery @"ExactQuery"//0/1，   默认 0 必须


//资质
#define kBidAptitudesRequired @"AptitudesRequired"
#define kAptitude @"Aptitude"
//业绩要求
#define kBidPerformance @"Performance"
//成员要求
#define kBidMemberRequired @"MemberRequired"
#define kBidDescribe @"Describe"
#define kBidMarker @"Marker"
#define kBidAttentionID @"AttentionId"
#define kBidName @"ProjectName"
#define kBidAlias @"ProjectAlias"
#define kBidType @"ProjectType"
#define kBidIsMatchAny @"IsMatchAny"
#define KBidOthers @"Others"
#define kBidIsOpenPhone @"IsOpenPhone"
#define kBidDeadline @"Deadline"
#define kBidStatus @"Status"
#define kQualitySubCollection @"SubCollection"
//允许多少人报名
#define kBidRequiredCount @"RequiredCount"
//报名要求
#define kBidRequiredAttention @"RequiredAttention"
#define kBidRequireLetter @"RequiredVouch"

#pragma mark - 评价
#define kAssessRating @"Rank"
#define kAssessReason @"RankCode"

#pragma mark - 资质查询
//诚信得分
#define KWater @"Water"
#define KTraffic @"Deliver"
#define KBuilding @"Build"
#define KGarden @"Park"

#define kCredit2DisplayName @"DisplayName"
//资质查询－企业名称
#define KCredit @"Credits"
#define KCredit2 @"Credit2"
#define KRegionType @"RegionType"
#pragma mark - 我参与的项目
#define kJoinCount @"Count"
#define kJoinItems @"Items"

//客户管理
#pragma mark - 客户管理
#define kCustomerId @"CustomerId"
#define kCustomerName @"CustomerName"
#define kCustomerAptitudes @"CustomerAptitudes"
#define kCustomerContact @"Contact"
#define kCustomerPhone @"Phone"
#define kCustomerRemark @"Remark"
#define kCustomerAdress @"Address"
#define kCustomerCooperation @"Cooperation"
#define kCustomerAptitude1 @"Aptitude1"
#define kCustomerAptitude2 @"Aptitude2"
#define kCustomerAptitude3 @"Aptitude3"
#define kCustomerAptitude4 @"Aptitude4"
/**
 *  专业技术人员
 */
#define kCustomerProfessionalDesc @"ProfessionalDesc"


#pragma mark - 导出项目
#define kExportArray @"ExportArray"
#define kExportType @"ExportType"
#define kExportTitle @"ExportTitle"

#pragma mark - 公共
#define kCommonType @"Type"
#define kCommonKey @"Key"
#define kCommonValue @"Value"
#define kCommonVersionNo @"VersionNo"
#define kCommonMachineType @"MachineType"

#define kPageType @"PageType"
#define kPageDataDic @"PageDataDic"
#define kPageReturnType @"Return_Type"

//用于资质选择外层KEY
#define kTopKey @"TopKey"
//资质选择内层KEY
#define kLimitKey @"LimitKey"
#define kNewSubCollection @"SubCollection"


//所在企业－添加企业
#pragma mark - 所在企业－添加企业
#define kPlaceOfOrign @"PlaceOfOrigin"
#define kFilingArea @"FilingArea"
#define kWorkPlace @"WorkPlace"
/**
 *  显示详情页空白的显示
 */
#define NoneText @"暂无"

#pragma mark - 通知
#define Notification_BidList_Refresh @"BidList_Refresh"
#define Notification_OurPublish_Refresh @"OurPublish_Refresh"
#define Notification_BidListByID_Refresh @"BidListByID_Refresh"
#define Notification_Bid_Attention @"Bid_Attention"
#define Notification_Customer_Refresh @"CUSTOMER_REFRESH"
#define Notification_CProject_Refresh @"CProject_Refresh"
#define Notification_Customer_Detail_Refresh @"Customer_Detail_Refresh"
#define Notification_CProject_Detail_Refresh @"CProject_Detail_Refresh"
#define Notification_User_Login_Success @"User_Login_Success"
#define Notification_Set_Publish_Count @"Set_Publish_Count"
#define Notification_Sub_Publish_Count @"Sub_Publish_Count"
#define Notification_OurOrder_Refresh @"OurOrder_Refresh"
#define Notification_OrderDetail_Refresh @"OrderDetail_Refresh"
#define Notification_Bid_Cerification @"Bid_Cerification"
#define Notification_Upload_Cerification @"Upload_Cerification"
#define Notification_EndRefresh_PersonView @"EndRefresh_PersonView"
#define Notification_Wallet_ToWalletMain @"Wallet_ToWalletMain"
#define Notification_Wallet_RefreshWalletInfo @"Wallet_RefreshWalletInfo"
#define Notification_OrderReceive_Refresh @"OrderReceive_Refresh"

#define Notification_LetterPerform_Refresh @"LetterPerform_Refresh"

#define Notification_LetterAddress_Refresh @"LetterAddress_Refresh"


#define Notification_RePay_BidLetter @"Notification_RePay_BidLetter"


#define Notification_TenPay_Result @"Notification_TenPay_Result"
#define Notification_AliPay_Result @"Notification_AliPay_Result"
#define TenpaySuccess @"TenpaySuccess"
#define TenpayFail @"TenpayFail"

//显示资料外包首页的区域选择
#define Notification_ShowAreaPicker_Tech @"Notification_ShowAreaPicker_Tech"
//隐藏资料外包首页的区域选择
#define Notification_HideAreaPicker_Tech @"Notification_HideAreaPicker_Tech"


#pragma mark -- 标记
//技术标提交统计  感兴趣和不感兴趣
#define None_Requested_Jishu @"None_Requested_Jishu"
//预算标提交统计  感兴趣和不感兴趣
#define None_Requested_Yusuan @"None_Requested_Yusuan"
//银行保函提交统计  感兴趣和不感兴趣
#define None_Requested_Bank @"None_Requested_Bank"
//技术标  --  已选择，但是未登录提交
#define JiShuNoneRequest @"JiShuNoneRequest"
//预算  --  已选择，但是未登录提交
#define YusuanNoneRequest @"YusuanNoneRequest"
//银行保函  --  已选择，但是未登录提交
#define BankNoneRequest @"BankNoneRequest"

//报名弹窗提示次数
#define AttentionTipCount @"AttentionTipCount"

#pragma mark -- 我要认证
//工作简历
#define kJobResume @"JobResume"
#define kWorkExperience @"WorkExperiences"

//项目简历
#define kProjectResume @"ProjectResume"
#define kProjectExperience @"ProjectExperiences"
//个人概述
#define kPersonalOverView @"Description"
//昵称
#define kName @"Name"
#define kNickName @"NickName"
#define kSex @"Sex"
#define kDateofBirth @"Birthday"
#define kGraduatedSchool @"Education"
//接单区域
#define kOrderRegion @"Region"
#define kOrderType @"ProductType"
//擅长领域
#define kExpertCategory @"ExpertCategory"
#pragma mark --  简历
#define kOrganization @"Organization"
//工作部门
#define kDepartment @"Department"
#define kJob @"Job"
#define kWorkTime @"WorkTime"
#define kStartDt @"StartDt"
#define kEndDt @"EndDt"
#define kJobDescription @"JobDescription"
//证明人
#define kWorkmate @"Workmate"
#pragma mark -- 补遗
#define kAdditionalContent @"Content"
#define kAdditionalDownloadUrl @"DownloadUrl"
#define kAdditionalAccessCode @"AccessCode"
//查看用户信息
#define kProductLevel @"ProductLevel"
#define kMaxQuantity @"MaxQuantity"
//我的接单－扣款－付款
#define kMyorderPaymentTime @"PaymentTime"
#define kMyorderPaymentMoney @"PaymentMoney"
#define kMyorderPaymentDescription @"PaymentDescription"
#define kMyorderDeductionsTime @"DeductionsTime"
#define kMyorderDeductionsMoney @"DeductionsMoney"
#define kMyorderDeductionsDescription @"DeductionsDescription"
#pragma mark --  环信
#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#endif /* KeyDefine_h */
