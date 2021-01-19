
import Foundation

//***************************************  网络请求接口定义  ****************************************


/// 是否使用正式支付,true正式支付，false积分支付
let IS_FORMAL_PAY = true

/// 是否是正式环境,true正式环境，false测试环境
let IS_PRODUCTION_ENVIRONMENT = true

/// BASE_URL,只读,不可去修改
var SERVICE_BASE_ADDRESS: String = {
    return IS_PRODUCTION_ENVIRONMENT ? "https://nebulaedu.com/api/" : "https://dev.nebulaedu.com/api/"
}()

//MARK:  ***** 支付相关的统一下单接口 *******
/// 支付统一下单接口
var PAY_UNIFY_ORDER: String = {
    return IS_PRODUCTION_ENVIRONMENT ? "http://pay.nebulaedu.com/pay/v1/charge/order" : "http://pay.nebulaedu.com/pay/v1/charge/order"
}()

//MARK: --------------- 用户相关 ------------------

/// 获取手机短信验证码
let API_GET_MOBICODE = "v1/user/code"
/// 获取手机短信验证码新接口
let API_GET_MOBICODE_NEW = "v1/user/newCode"

/// 获取图片验证码
let API_GET_IMAGE = "v1/user/imageCode"

/// 用户注册(说明:此接口主要是账号注册,用户的个人资料需要调用修改用户资料接口去完成。)
let API_POST_REGISTER = "v1/user/regist"

/// 消息列表
let API_POST_USER_NOTICE = "v1/user/notice"

/// 消息详情
let API_GET_NOTICE_DETAIL = "v1/user/notice/" //直接拼接noticeId

/// 用户登录
let API_POST_LOGIN = "v1/user/login"

/// 用户退出登录
let API_POST_LOGOUT = "v1/user/logout"

/// 检查登录凭证TOKEN
let API_GET_TOKEN = "v1/user/token/"  //把TOKEN直接拼接在后面

/// 修改用户账号密码
let API_POST_PASSWORD_MODIFY = "v1/user/password/modify"

/// 重置用户账号密码
let API_POST_PASSWORD_RESET = "v1/user/password/reset"

/// 用户收藏
let API_GERT_USER_COLLECTION = "v1/user/collection"

/// 获取用户收藏记录
let API_GET_USER_COLLECTION_RECORD = "v1/user/collectionList"

/// 获取常见问题
let API_GET_APP_QUESTION = "v1/app/question"

/// 获取关于我们
let API_GET_APP_ABOUT = "v1/app/about"

/// 我收藏的资讯列表
let API_GET_NEWS_FAVORITE_LIST = "v1/news/userNews/"

/// 注册时的服务协议
let API_GET_APP_REGISTER_AGREEMENT = "v1/app/help"

/// 服务条款
let API_GET_SEVICE_TERMS = "v1/app/serviceTerms"

/// 预约
let API_POST_ORDER_APPOINTMENT = "v1/order/appointment"

/// 获取用户资料
let API_GET_USER_PROFILE = "v1/user/profile"

/// 修改用户资料
let API_POST_USER_MODIFY = "v1/user/profile"

/// 修改用户头像
let API_POST_USER_PORTRAIT = "v1/user/uploadPortrait/" //后面直接拼接profileId

/// 获取用户积分列表
let API_GET_USER_SCORE = "v1/user/score"

/// 反馈意见
let API_POST_APP_ADVICE = "v1/app/feedback"

/// 省份列表
let API_GET_PROVINCE_LIST = "v1/user/province"

/// 城市列表
let API_GET_CITY_LIST = "v1/user/city/"

/// 学校列表
let API_GET_SCHOOL_LIST = "v1/user/school/"

/// 学校认证信息
let API_GET_USER_SCHOOL_MESSAGE = "v1/user/userSchool/"


//MARK: --------------- 业务相关 ------------------

/// 附近洗衣点
let API_GET_WASHING_PLACE = "v1/product/base"

/// 最近洗衣
let API_GET_WASHING_LAUNDRY = "v1/product/lastLaundryTime"

/// 获取一个地点的洗衣机列表
let API_GET_WASHINGMACHINE_LIST = "v1/product/list"

/// 洗衣机套餐列表
let API_GET_WASHINGPACKAGE_LIST = "v1/product/package"

/// 洗衣机详情
let API_GET_WASHINGMACHINE_DETAILS = "v1/product/" //后面直接凭借id

/// 根据设备编号查询洗衣机
let API_GET_WASHINGMACHINE_DETAILS_IMEI = "v1/product/imei/" //后面直接凭借设备imei

/// 订单列表
let API_GET_ORDER_LIST = "v1/order"

/// 下单
let API_POST_ORDER = "v1/order"

/// 退款申请
let API_POST_ORDER_REFUND = "v1/order/refund"

/// 带图片的退款申请
let API_POST_ORDER_REFUND_IMAGE = "v1/order/refundImages"

/// 未完成订单查询
let API_GET_ORDER_NO = "v1/order/noComplete"

/// 获取订单列表的标题
let API_GET_ORDER_TITLE = "v1/order/category"

/// 验证该订单是否可退款
let API_GET_ORDER_REFUND_CHECK = "v1/order/refundCheck"

/// 预约洗衣
let API_GET_ORDER_TRACKORDER = "v1/order/trackOrderAppointment"

/// 验证机器得到的验证码
let API_POST_ORDER_CODE = "v1/order/code"

/// 验证机器
let API_GET_CHECK_ORDER = "v1/order/checkOrder"

/// 订单详情
let API_GET_ORDER_DETAILS = "v1/order/"

///  附近学校
let API_GET_SCHOOL = "v1/product/school"

/// 推荐洗衣机
 let API_GET_RECOMMEND_WASHINGMACHINE = "v1/product/recommend"

/// 推荐洗衣机 V2
let API_GET_RECOMMEND_WASHINGMACHINE_V2 = "v2/product/recommend"

/// 未支付设备 V2
let API_GET_NO_PAY_DEVICE_V2 = "v2/product/noPay"

/// 未启动设备 V2
let API_GET_NO_START_DEVICE_V2 = "v2/product/noStart"

/// 未启动设备 V2
let API_GET_USING_DEVICE_V2 = "v2/product/use"

/// 首页附近洗衣点
let API_GET_FLOOR_CARD = "v1/product/floorCard"

/// 取消订单
let API_GET_CANCEL_ORDER = "v1/order/cancelPay"

/// 根据洗衣点查找洗衣机
let API_GET_FLOOR_WASHINGMACHINE = "v1/product/listByFloorCard"

/// 根据设备和用户Id查询订单号
let API_GET_ORDER_FORM_MACHINE = "v1/order/recommendOrder"

/// 启动设备
let API_GET_DEVICE_START = "v1/deviceStart"

//MARK: --------------- 任务相关 ------------------

/// 任务列表
let API_GET_TASK_LIST = "v1/task"

/// 积分支付
let API_GET_ORDER_TRACK = "v1/order/trackOrderScore"

/// 预约积分支付
let API_GET_ORDER_YUYUE_TRACK = "v1/order/toTrackOrderScore"

/// 任务详情
let API_GET_TASK_Details = "v1/task/" // 后面直接拼接taskId

/// 任务详情图片列表
let API_GET_TASK_Details_PICTURE_LIST = "v1/task/image/" // 后面直接拼接taskId

/// 完成任务
let API_GET_TASK_FINISH = "v1/task/finishTask"



//MARK: --------------- 资讯相关 ------------------

/// 资讯列表
let API_GET_NEWS_LIST = "v1/news"

/// 资讯详情
let API_GET_NEWS_DETAILS = "v1/news/" //后面拼接资讯id

/// 资讯评论列表
let API_GET_NEWS_COMMENT_LIST = "v1/news/comment" //后面拼接资讯id

/// 发表新闻评论
let API_POST_NEWS_COMMENT_PUBLISH = "v1/news/comment"

/// 给新闻评论点赞
let API_GET_NEWS_COMMENT_PRAISE = "v1/news/commentGoods"

/// 给新闻点赞、收藏
let API_GET_NEWS_PRAISE_FAVORITE = "v1/news/newsGoods"

/// 给新闻点赞、收藏
let API_GET_NEWS_COMMENT_DELETE = "v1/news/deleteComment/" // 后面直接拼接评论id

/// 举报评论
let API_POST_NEWS_COMMENT_REPORT = "v1/news/comment"


//MARK: --------------- 评论留言相关 ------------------

/// 留言列表
let API_GET_COMMENT_LIST = "v1/comment"

/// 发布留言
let API_POST_PUBLISH_COMMENT = "v1/comment/editComment"

/// 回复留言
let API_POST_REPLY_COMMENT = "v1/comment/replyComment"

/// 留言点赞
let API_GET_COMMENT_THUMBS = "v1/comment/goods"

/// 删除留言,直接拼接ID
let API_GET_COMMENT_DELETE = "v1/comment/delete/"

/// 举报留言
let API_POST_COMMENT_REPORT = "v1/comment/report"


/// 广告
let API_GET_ADS = "v1/ads"


//MARK: --------------- 创业相关 ------------------

/// 保存或者编辑或者发布创业项目
let api_post_cy_save_porject = "v1/project"

/// 删除创业项目
public func api_delete_cy_delete_porject(projectId: String) -> String {
    return "v1/project/\(projectId)"
}

/// 我的创业项目
let api_get_cy_my_project = "v1/project/my/"

/// 创业推荐项目
let api_get_cy_recommend = "v1/project/recommend"

/// 创业排名榜单
let api_get_cy_popularity = "v1/project/ranking/"

/// 某个学校下的创业项目
let api_get_cy_school_project = "v1/project/school/"

/// 专家对某个创业项目的评论
public func api_get_cy_expert_comment(projectId: String) -> String {
    return "v1/project/\(projectId)/experts"
}

/// 用户对某个创业项目的评论
public func api_get_cy_user_comment(projectId: String) -> String {
    return "v1/project/\(projectId)/comments"
}

/// 创业项目的图片
public func api_get_cy_images(projectId: String) -> String {
    return "v1/project/\(projectId)/images"
}

/// 用户发送对创业项目的评论
public func api_post_cy_sendComent(projectId: String) -> String {
    return "v1/project/\(projectId)/comment"
}

/// 创业项目详情
public func api_get_cy_project_details(projectId: String) -> String {
    return "v1/project/\(projectId)"
}

/// 给项目点赞
public func api_get_cy_project_support(projectId: String) -> String {
    return "v1/project/\(projectId)/goods"
}

/// 给项目评论点赞
public func api_get_cy_project_comment_support(projectId: String, commentId: String) -> String {
    return "v1/project/\(projectId)/comments/\(commentId)/goods"
}

/// 发布用户评论回复
public func api_post_cy_comment_reply(projectId: String) -> String {
    return "v1/project/\(projectId)/replyComment"
}



//MARK: --------------- 星币相关 ------------------

/// 钱包余额
let api_get_wallet_balance = "v1/user/wallet"

/// 充值套餐
let api_get_recharge_package = "v1/user/rechargePackage"

/// 星币充值下单
let api_get_star_coins_recharge_order = "v1/user/recharge"

/// 星币支付
let api_get_star_coins_pay = "v1/order/nebulaCoins"

/// 星币消费记录
public func api_get_star_coins_consumption_record(userId: String) -> String {
    return "v1/user/\(userId)/purchase"
}

/// 星币充值记录
public func api_get_star_coins_recharge_record(userId: String) -> String {
    return "v1/user/\(userId)/recharge"
}



//MARK: --------------- 推送相关 ------------------

/// 向服务器添加推送ID
let API_GET_JPUSH_REGISTER_ID = "v1/user/pushRegistration"



//MARK: --------------- 支付相关 ------------------
/// 支付订单检测
let API_GET_PAY_CHECK = "v1/order/check"


//MARK: --------------- 数据收集 ------------------

/// 进入后台时的数据收集
let API_POST_USER_DATA = "v1/track/report"


//MARK: --------------- webView  URL ------------------

// 用户协议
let WEB_URL_USER_AGREEMENT = "http://emall.eteclab.com/#/agreement"

// 问卷调查
let WEB_URL_QUESTIONNAIRE = "http://115.28.186.171:12000/api/html/#/questionnaire/"

// 问卷调查 returnUrl
let WEB_URL_QUESTIONNAIRE_RETURN_URL = "http://emall.eteclab.com/#/toIos?url=hongbao"

// 网络公正
let WEB_URL_NETWORK_NOTARIZATION = "http://emall.eteclab.com/#/cybernotary/"













