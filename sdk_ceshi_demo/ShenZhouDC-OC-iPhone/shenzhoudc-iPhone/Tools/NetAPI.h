//
//  NetAPI.h
//  shenzhoudc-iPhone
//
//  Created by zzh on 16/12/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

#ifndef NetAPI_h
#define NetAPI_h

#endif /* NetAPI_h */


//正式接口
//#define DOMAIN_NAME     @"http://szfay.eteclab.org/api/"
#define DOMAIN_NAME     @"http://szfay.com/api/"

//最新的外网地址
//#define DOMAIN_NAME    @"http://115.28.184.232:8085/api/"

#define DOMAIN_NAME_H5  @"http://szfay.com/app/"




//MARK:  ____________ 用户相关 ______________
/**
 * 手机验证码
 */
//#define API_GET_MOBILE_CODE @"api/v1/user/code"

/**
 * 用户登录
 */
#define API_POST_LOGIN @"v1/login"

/**
 * 用户退出登录
 */
#define API_GET_LOGINOUT @"v1/user/logout"

/**
 * 检查登录TOKEN
 */
#define API_GET_CHECK_TOKEN @"/v1/user/token/"  // 后面直接凭借token

/**
 * 修改密码
 */
#define API_POST_MODIFY_PASSWORD @"/v1/user/password/modify"

/**
 * 重置密码密码
 */
#define API_POST_RESET_PASSWORD @"/v1/user/password/reset"

/**
 * 获取手机验证码
 */

#define API_GET_USER_AUTHCODE @"/v1/user/code"
/**
 * 用户注册
 */
#define API_POST_REGISTER @"/api/v1/user/regist"

/**
 * 获取用户资料
 */
#define API_GET_USER_PROFILE @"/v1/user/profile"

//新接口 获取用户资料
#define API_GET_NEW_USERPROFILE @"v1/user/getUsers"

/**
 * 修改用户资料
 */
#define API_POST_MODIFY_USER_PROFILE @"/v1/user/profile"

/**
 * 修改用户头像
 */
#define API_POST_MODIFY_USER_PORTRAIT @"/v1/user/portrait"

/**
 * 修改用户主页背景
 */
#define API_POST_MODIFY_BACKGROUND @"/v1/user/background"

/**
 * 微信登录
 */
#define API_POST_WX_LOGIN @"/v1/user/weixin/login"

/**
 * QQ登录
 */
#define API_POST_QQ_LOGIN @"/v1/user/qq/login"



//MARK:  ____________ 业务相关 ______________
/**
 * 解决方案列表
 */
#define API_GET_SOLUTION @"v1/solution"

/**
 * 新的解决方案列表
 */
#define API_GET_SOLUTION_LIST @"v1/solution/getSolutionList"

/**
 * 产品列表
 */
#define API_GET_PRODUCT @"v1/product"

/**
 * 产品列表
 */
#define API_GET_PRODUCT_FROM_CATEGORY @"v1/datafactory/getResourceList"

//发现--获取视频/文档 接口
#define API_GETFILETYPE @"v1/datafactory/"

/**
 * 产品详情轮播图
 */
#define API_GET_PRODUCT_PICTURE @"v1/product/images"

/**
 * 首页广告
 */
#define API_GET_BANNER @"v1/banner"

#define API_GET_ITSERVER @"v1/details"
//搜索报名人列表
#define API_GET_PARTICIPATELIST @"v1/details/searchordertakers"
//报名人列表
#define  API_GETTHISDEALPLIST @"v1/details/pushOrderDetails"
/**
 * 需求列表
 */
#define API_GET_DEMAND @"v1/demand"
// 技术达人报名接单
#define API_POST_RECIEVE @"v1/details/getEnroll"
//确定最终接单人
#define API_POST_MAKESURERECIEVERAPI @"v1/details/getSureType";
/**
 * 我的方案(我发布的)
 */
#define API_GET_MYPLAN @"v1/solution/getMySolution"
/**
 * 我的方案（我参与的）
 */
#define API_GET_MYPLAN_PARTIPATE @"v1/solution/getMyBuySolution"
/**
 * 派工列表
 */
#define API_GET_ASSIGN @"/v1/assign"

/**
 * 解决方案详情
 */
#define API_GET_SLOUTION_DETAILS @"v1/solutionpkg/"  //后面直接拼接ID  solution
//solutionpkg
/**
 * 新的解决方案详情
 */
#define API_GET_SLOUTION_DETAILS_NEW @"v1/solution/getSolutionDetilsById/"

/**
 * 完整版PDF地址
 */
#define API_POST_COMPLETE_SLOUTION_PDF @"v1/solution/getWPDFpath"

/**
 *简版PDF地址
 */
#define API_GET_SIMPLE_SLOUTION_PDF @"v1/solution/getJPDFpath"

/**
 * 新的解决方案简单信息
 */
#define API_GET_SLOUTION_SIMPLE @"v1/solution/getSolutionSimpleById/"

/**
 * 方案点赞
 */
#define API_POST_SLOUTION_ADDTHUMBS @"v1/solution/addThumbs"


/**
 * 评论列表,
 * resourceType(1 商品   2 需求  3 解决方案 4 派工)
 * resourceId （产品、需求、解决方案、派工 的id)
 * userId(查询自己发的评论需要传此参数)
 */
#define API_GET_COMMENT @"/v1/comment"
//发单人查看双方评价
#define API_GET_DOUBLECOMMENT @"v1/details/getEvaluate"
/**
 * 解决方案详情页，相关产品
 */
#define API_GET_SLOUTION_ABOUT_PROFUCT @"v1/product/getProduct"

/**
 * 解决方案页成交量
 */
#define API_GET_SLOUTION_DETAILS_TURNOVER @"v1/solution/turnover"

/**
 * 购买解决方案中的套餐
 */
#define API_GET_SLOUTION_PACKAGE @"v1/solutionpkg"

/**
 * 支付预下单
 */
#define API_POST_SLOUTION_ORDER @"v1/charge/order"

/**
 * 购买解决方案
 */
#define API_GET_SLOUTION_BUY @"v1/solution/buy"

/**
 * 解决方案下单（新接口）
 */
#define API_POST_SLOUTION_ORDER_NEW @"v1/solution/place/order"

/**
 * 解决方案下单后购买（新接口）
 */
#define API_POST_SLOUTION_BUY_NEW @"v1/payment/pay/solution"

/**
 * 产品详情
 */
#define API_GET_PRODUCT_DETAILS @"v1/product/"  //后面直接拼接ID

/**
 * 产品详情信息
 */
#define API_GET_PRODUCT_DETAILS_MESSAGE @"v1/datafactory/getProductOrImage"

/**
 * 产品详情页，相关解决方案
 */
#define API_GET_SLOUTION_ABOUT_SOLUTION @"v1/solution / getSolution"

/**
 * 需求详情
 */
#define API_GET_DEMAND_DETAILS @"v1/demand/"  //后面直接拼接ID
/**
 * 发布评价
 */
#define API_POST_SENDCOMMENT @"v1/comment/editComment"
//技术达人认证
#define API_POST_AUTH @"v1/user/talent"

/**
 * 需求应标
 */
#define API_GET_DEMAND_DEMANDBID @"v1/demand/demandBid"

/**
 * 需求附件
 */
#define API_GET_DEMAND_FILE @"v1/demand/geiFile"

/**
 * 需求应标用户
 */
#define API_GET_DEMAND_USER @"v1/user /getDemandUser"

/**
 * 检验用户是否应标
 */
#define API_GET_DEMAND_ISBID @"v1/demand/ifBid"

/**
 *  派工查看详情
 */
#define API_GET_ASSIGN_DETAILS @"v1/assign"
/**
 *  派工抢单
 */
#define API_GET_ASSIGN_ASSIGNINDENT  @"v1/assign/assignIndent"
/**
 *  派工完成确认
 */
#define API_GET_ASSIGN_ASSIGNAFFIRM @"v1/assign/assignAffirm"
/**
 *  派工交付确认
 */
#define API_GET_ASSIGN_DELIVERY @"v1/assign/delivery"
/**
 *  筛选 方案厂商
 */
#define API_GET_COMMPANY @"v1/partner"//company

/**
 *  筛选 行业分类
 */
#define API_GET_CATEGORY @"v1/industry"//category

/**
 *  购买方案
 */
#define API_GET_BUY_SOLUTION @"v1/solution/buy"

/**
 *  方案详情成交量
 */
#define API_GET_SOLUTION_TURNOVER @"v1/solution/turnover"
/**
 *  筛选 实施地区
 */
#define API_GET_DICT_PROVINCE @"v1/dict/province"
/**
 *  派工详情图片
 */
#define API_GET_ASSIGN_GETIMAGE @"v1/assign/getImage"
/**
 *  优秀技术达人
 */
#define API_GET_USER_GETUSER @"v1/user/getUser"

//我的派工（发布的）
#define  API_GET_MY_DISPATCH @"v1/assign/getMyAssign"
/**
 *我的派工（参与的）
 */
#define API_GET_MYDISPATCH_PARTIPATE @"v1/assign/getMyBuyAssign"

//我的需求
#define API_GET_MY_NEED @"v1/demand/getMyDemand"
//我的派单
#define API_GET_MYSENDLIST @"v1/details/pushorder"  //v1/details/pushorder
//我的接单
#define API_GET_MYRECIEVELIST @"v1/details/connectorder"

//获取用户认证的信息
#define  API_GET_USERINFO_AUTH @"v1/user/authentication/"

// 获取产品生产筛选分类
#define API_GET_SCREEN_CHANPIN_CATEGORY @"v1/datafactory/getResourceList"

// 给资源点赞
#define API_POST_SOURCE_DIANZAN @"v1/datafactory/data/addThumbs"

// 我购买的方案列表
#define API_GET_BUY_SLOUTION_LIST @"v1/solution/getUserSolutionBuyList"

// 我发布的方案列表
#define API_GET_PUBLISH_SLOUTION_LIST @"v1/solution/getUserSolutionList"

// 交钥匙项目详情
#define API_POST_KEY_PROJECT_DETAILS @"v1/solution/getPakDetils"

// 交钥匙项目下单
#define API_POST_KEY_PROJECT_ORDER @"v1/solutionpkg/place/order"

// 已发布交钥匙项目列表
#define API_GET_KEY_PROJECT_PUBLISH_LIST @"v1/solutionpkg/getUserSolutionpkgPushList"

// 已购买交钥匙项目列表
#define API_GET_KEY_PROJECT_BUY_LIST @"v1/solutionpkg/getUserSolutionpkgBuyList"

// 完成交钥匙项目发布人取消确认合同
#define API_POST_KEY_PROJECT_CANCEL @"v1/solutionpkg/unconfirm/agreement"

// 完成交钥匙项目发布人确认合同接口
#define API_POST_KEY_PROJECT_SURE @"v1/solutionpkg/confirm/agreement"

// 完成交钥匙项目发布人获取合同图片
#define API_POST_KEY_PROJECT_AGREEMENT @"v1/solutionpkg/get/agreement"

// 交钥匙项目确认支付
#define API_POST_KEY_PROJECT_SURE_PAY @"v1/solutionpkg/confirm/paymented"

// 交钥匙项目开工
#define API_POST_KEY_PROJECT_START_WORK @"v1/solutionpkg/confirm/workstart"

// 交钥匙项目确认验收
#define API_POST_KEY_PROJECT_SURE_YANSHOU @"v1/solutionpkg/confirm/accept"

// 交钥匙项目确认完工
#define API_POST_KEY_PROJECT_SURE_FINISH_WORK @"v1/solutionpkg/confirm/workover"

// 解决方案评价
#define API_POST_SOLUTION_EVALUATE @"v1/solution/EvaluateSolution"

// 交钥匙项目购买人列表
#define API_GET_KEY_PROJECT_BUYER_LIST @"v1/solutionpkg/getSolutionpkgBuyerList"

// 交钥匙项目购买人确认接单
#define API_POST_KEY_PROJECT_SURE_RECEIVE_ORDER @"v1/solutionpkg/confirm/order"

// 获取用户协议接口
#define API_GET_USER_PROTOCOL @"v1/regist/getUserProtocorl"

// 获取达人协议接口
#define API_GET_TANLENT_PROTOCOL @"v1/regist/getTanlentProtocorl"

// 获取公司协议接口
#define API_GET_COMPANY_PROTOCOL @"v1/regist/getManufacturerProtocorl"

// 获取派工协议接口
#define API_GET_PAIGONG_PROTOCOL @"v1/regist/getOrderDetailsProtocorl"

// 获取解决方案协议接口
#define API_GET_SOLUTION_PROTOCOL @"v1/regist/getSolutionProtocorl"

// 获取交钥匙项目协议接口
#define API_GET_KEY_PROJECT_PROTOCOL @"v1/regist/getSolutionPkgProtocorl"

// 获取注册协议
#define API_GET_REGISTER_PROTOCOL @"v1/regist/getRegistProtocorl"

// 获取购买方案协议
#define API_GET_BUY_SOLUTION_PROTOCOL @"v1/regist/getSolutionBuyProtocorl"

// 获取达人报名协议
#define API_GET_IT_JOIN_PROTOCOL @"v1/regist/getOrderDetailsEnrollProtocorl"

// 解决方案评价列表
#define API_GET_SOLUTION_COMMENT_LIST @"v1/solution/getSolutionAssessList"

// 交钥匙项目评价列表
#define API_GET_KEY_PROJECT_COMMENT_LIST @"v1/solutionpkg/getSolutionpkgAssessList/"

// 申请提现到微信
#define API_POST_APPLY_WITHDRAW_WECHAT @"v1/withdraw/deposit/weixin/apply"

// 申请提现到支付宝
#define API_POST_APPLY_WITHDRAW_APLPAY @"v1/withdraw/deposit/alipay/apply"

// 申请提现到公司账号
#define API_POST_APPLY_WITHDRAW_COMPANY @"v1/withdraw/deposit/company/apply"

// 绑定微信
#define API_POST_BINDING_WECHAT @"v1/withdraw/deposit/weixin/binding"

// 绑支付宝
#define API_POST_BINDING_ALIPAY @"v1/withdraw/deposit/alipay/binding"

// 用户确认给解决方案付款接口
#define API_POST_SOLUTION_CONFIRM_PAYMENT @"v1/solution/confirm/solution/payment"

// 获取首页广告位
#define API_GET_ADS_LIST @"v1/userAdmin/app/getAdvert"

// 找回密码短信验证
#define API_POST_PASSWORD_AUTH @"v1/user/password/auth"

// 找回密码短信验证
#define API_POST_PASSWORD_AUTH @"v1/user/password/auth"

// 找回密码确认接口
#define API_POST_PASSWORD_RESET @"v1/user/password/reset"

// 收藏商品
#define API_POST_FAVORITE @"v1/solution/collect"

// 取消收藏
#define API_POST_CANCEL_FAVORITE @"v1/solution/closeCollect"

// 我的收藏
#define API_GET_MY_FAVORITE @"v1/solution/getCollectByUserId"

// 根据产品id查询产品资源
#define API_GET_PRODUCT_DETAILS_NEW @"v1/datafactory/data/"

// 获取解决方案筛选分类
#define API_GET_SOLUTION_SEARCH_CATEGORY @"v1/solution/getReadeList"



#pragma mark:  ******** H5 相关 **********
// 用户资料 后面拼  ?id=xxx
#define H5_USER_INFO @"usercenter.html"

// 评价页面用到
#define H5_CONFIRM @"confirm.html"

// 订单详情
#define H5_CONTENT @"content.html"



