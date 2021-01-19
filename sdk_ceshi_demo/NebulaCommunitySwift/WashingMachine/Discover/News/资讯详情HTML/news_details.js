// 新闻列表ul下li的id前缀
var news_id_prefix = "newsid_"
// 评论列表中的评论数量的id前缀
var comment_id_prefix = "commentid_"
// 评论列表中赞数量的id前缀
var prise_id_prefix = "priseid_"

// 点击评论,会调用APP方法
function clickComment(index) {
    window.webkit.messageHandlers.commentHandler.postMessage(index);
}
// 点击新闻赞,会调用APP方法
function clickNewPrise() {
    setNewsPriseAction(0);
    window.webkit.messageHandlers.newsPriseHandler.postMessage(1);
}

// 点击评论赞,会调用APP方法
function clickPrise(index) {
    window.webkit.messageHandlers.favoriteHandler.postMessage(index);
}
// 点击新闻,会调用APP方法
function clickNews(index) {
    window.webkit.messageHandlers.newsHandler.postMessage(index);
}

// 设置新闻点赞按钮的可点击性
function setNewsPriseAction(isClick) {
    var prise = document.getElementById("news_prise_id");
    if (isClick) {
        prise.onclick = function() {
            setNewsPriseAction(false);
            clickNewPrise();
        }
    } else {
        prise.onclick = function() {
            return;
        }
    }
}
// 设置新闻点赞数量
function setNewsPriseCount(count, isSelected) {
    var prise = document.getElementById("prise_text");
    prise.innerText = count;
    if (isSelected) {
        prise.className = "text_selected";
    } else {
        prise.className = "text_normal";
    }
//    var div = document.getElementById("news_prise_subsidiary");
//    if (isSelected) {
//        div.className = "prise_single prise_single_press";
//    } else {
//        div.className = "prise_single prise_single_normal";
//    }
}
// 设置评论列表中回复数量
function setCommentCount(index, count) {
    var span = document.getElementById(comment_id_prefix+index);
    span.innerText = count;
}
// 设置评论列表中点赞数量
function setPriseCount(index, count, isSupport) {
    var span = document.getElementById(prise_id_prefix+index);
    span.innerText = count;
    setPriseClassName(index, isSupport);
}
// 修改赞是否可点击
function priseUserActiviaty(index, isActivity){
    var btn = document.getElementById(prise_id_prefix+index);
    if (isActivity) {
        btn.onclick = function() {
            priseUserActiviaty(index, false);
            clickPrise(index);
        }
    } else {
        btn.onclick = function() {
            return;
        }
    }
}
//删除所有评论
function deleteAllComment() {
    var ul = document.getElementById("ul_comment_list");
    ul.innerHTML = "";
}
//向新闻列表插入新闻
function insertNewsElement(titleStr, timeStr, imgURL) {
    if (!imgURL) {
        insertTextNewsElement(titleStr, timeStr);
    } else {
        inserImgNewsElement(titleStr, timeStr, imgURL);
    }
}
// 向新闻列表插入无图片新闻
function insertTextNewsElement(titleStr, timeStr) {
    var ul = document.getElementById("recommend_news_list");
    var ulChildCount = ul.getElementsByTagName("li").length;
    var li = document.createElement("li");
    li.onclick = function() {
        clickNews(ulChildCount);
    }
    ul.appendChild(li);
    li.className = "on_img";
    li.id = news_id_prefix+ulChildCount;
    var con_a = document.createElement("a");
    li.appendChild(con_a);
    var title_div = document.createElement("div");
    con_a.appendChild(title_div);
    title_div.className = "title";
    title_div.innerText = titleStr;
    var newtime_div = document.createElement("div");
    con_a.appendChild(newtime_div);
    newtime_div.className = "tip";
    newtime_div.innerText = timeStr;
}
// 向新闻列表插入有图片新闻
function inserImgNewsElement(titleStr, timeStr, imgURL) {
    var ul = document.getElementById("recommend_news_list");
    var ulChildCount = ul.getElementsByTagName("li").length;
    var li = document.createElement("li");
    ul.appendChild(li);
    li.id = news_id_prefix+ulChildCount;
    li.onclick = function() {
        clickNews(ulChildCount);
    }
    var con_a = document.createElement("a");
    li.appendChild(con_a);
    var title_div = document.createElement("div");
    con_a.appendChild(title_div);
    title_div.className = "title";
    title_div.innerText = titleStr;
    var newtime_div = document.createElement("div");
    con_a.appendChild(newtime_div);
    newtime_div.className = "tip";
    newtime_div.innerText = timeStr;
    var img = document.createElement("img");
    con_a.appendChild(img);
    img.className = "u_head_img";
    img.src = imgURL;
}
// 向评论中插入评论
function insertCommentElement(headIcon, userName, timeStr, isPrise, contentStr, priseStr, commentStr) {
    var ul = document.getElementById("ul_comment_list");
    var ulChildCount = ul.getElementsByTagName("li").length;
    var li = document.createElement("li");
    ul.appendChild(li);
    var user_info_div = document.createElement("div");
    li.appendChild(user_info_div);
    user_info_div.className = "user_info";
    
    var img = document.createElement("img");
    user_info_div.appendChild(img);
    img.className = "user_icon";
    img.src = headIcon;
    
    var user_div = document.createElement("div");
    user_info_div.appendChild(user_div);
    user_div.className = "user_name_t";
    
    var user_name_div = document.createElement("div");
    user_div.appendChild(user_name_div);
//    user_div.className = "user_name";
    user_name_div.innerText = userName;
    
    var post_time_div = document.createElement("div");
    user_div.appendChild(post_time_div);
    post_time_div.className = "push_time";
    post_time_div.innerText = timeStr;
    
    var content_div = document.createElement("div");
    li.appendChild(content_div);
    content_div.className = "content_text";
    content_div.innerText = contentStr
    
    var bo_div = document.createElement("div");
    li.appendChild(bo_div);
    bo_div.className = "little_ux_button";
    
    var prise_span = document.createElement("span");
    bo_div.appendChild(prise_span);
    prise_span.id = prise_id_prefix+ulChildCount;
    prise_span.innerText = priseStr;
    setPriseClassName(ulChildCount, isPrise);
    prise_span.onclick = function() {
        priseUserActiviaty(ulChildCount, false);
        clickPrise(ulChildCount);
    }
}

function setPriseClassName(index, isPrise) {
    var priseSp = document.getElementById(prise_id_prefix+index);
    if (isPrise) {
        priseSp.className = "ux_up_ed";
    } else {
        priseSp.className = "ux_up";
    }
}

//随机版式
function randomStyle(){
    var index = parseInt(3*Math.random());
    var headerObj = document.getElementById("headerObj");
    headerObj.className = styles[index];
}

//设置标题
function setTitle(title){
    var newsTitle = document.getElementById("news_title");
    newsTitle.innerHTML = title;
}

function setBorder(showline){
    if(!showline){
        var headerObj=document.getElementById("headerObj");
        headerObj.style.borderLeft='none';
    }
}

//设置内容
function setContent(content){
    var newsContent = document.getElementById("news_content");
    newsContent.innerHTML = content
    imgsFormat();
    //            newsContent.innerHTML = replaceIMG(content); //替换图片样式
    imgWith(); //设置图片宽度
}

//设置来源
function setSource(source){
    var newsSource = document.getElementById("news_source");
    if(source === ""){
        newsSource.innerHTML = "";
    }else{
        newsSource.innerHTML = ""+source;
    }
}

//设置发布时间
function setPuttime(time){
    var newsTime = document.getElementById("news_puttime");
    newsTime.innerHTML = time;
}

//点击图片触发事件
function tapImg(index){
    imgIndex = index;
    callHandler = false;
    var mframe = document.getElementById("mframe");
    mframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + IMG_EVENT;
}

//返回图片的json数据
function getImgJSON(){
    return imgsJSON;
}

function getImgIndex(){
    return imgIndex;
}


function setFontSize(mFontSize){
    if(mFontSize != null)
    {
        fontSize = mFontSize;
    }
    
    var newsContent = document.getElementById("bodyObj");
    var pArray = document.getElementsByTagName("P");
    
    for(var i=0; i < pArray.length; i++){
        var pObj = pArray[i];
        
        pObj.style.fontSize = fontSize + "px";
    }
}

//放大字体
function fontZoomIn(){
    fontSize = 18;
    setFontSize(fontSize);
    return fontSize;
}

//缩小字体
function fontZoomOut(){
    fontSize = 13;
    setFontSize(fontSize);
    return fontSize;
}


//还原字体
function fontZoomNormal(){
    fontSize = 17;
    setFontSize(fontSize);
    return fontSize;
}
/*
 <dl>
 <dt><a href="#"><img src="images/detail_pic.jpg" width="278"></a></dt>
 <dd>Google 免费的在线翻译服务可即时翻译文本和网页</dd>
 </dl>
 */
var imgHoldTag = "[--IMG_TAG--]";
var imgHoldAltTag = "[--IMG_ALT--]";
var imgHoldIndex = "[--IMG_INDEX--]";
var IMG_TAG = "<dl><dt>"+imgHoldTag+"</dt><dd>"+imgHoldAltTag+"</dd></dl>";
var imgsJSON = "[";
var imgIndex = "0";

/*
 //替换图片标签
 function replaceIMG(html){
 imgsJSON = "[";
 var imgs = new Array();
 var nimgs = new Array();
 var arr;
 
 //          var path = /http([^"]*)/g; //截取图片路径
 //          var alt = /alt=([^"]*)/g;
 //          var alt = /alt=(["']+)([sS]*?)(1)/i;
 //          var imgreg = /<[iI][mM][gG][^>]+src='[^']+'[^>]*>/g; //img标签匹配
 
 var imgurlreg = /http([^"]*)/g; //图片路径
 var altreg = /\salt="([^"]+)"/i; //alt匹配
 var imgreg = /<[iI][mM][gG][^>]+[^>]*>/g; //img标签匹配
 var i = 0;
 
 while(arr = imgreg.exec(html)) {
 var imgTag = arr[0]; //获取图片标签
 alert(imgTag);
 var imgAlt = imgTag.match(altreg)[1]; //获取图片说明
 var imgPath = imgTag.match(imgurlreg)[0]; //获取图片路径
 
 imgsJSON += "{\"img\":\""+imgPath+"\" , \"description\":\""+imgAlt+"\"},"
 var nphoto = IMG_TAG.replace(imgHoldTag,imgTag).replace(imgHoldAltTag,imgAlt).replace(imgHoldIndex,imgs.length);
 nimgs.push(nphoto);
 imgs.push(imgTag);
 }
 
 imgsJSON = imgsJSON.substr(0,imgsJSON.length-1);
 imgsJSON += "]";
 
 for(i = 0; i < imgs.length; i++){
 html = html.replace(imgs[i],nimgs[i]);
 }
 //            alert(html);
 return html;
 }
 */

//设置图片宽度,调整格式
function imgsFormat(){
    var newsContent = document.getElementById("news_content");
    var html = newsContent.innerHTML;
    imgsJSON = "[";
    var imgArray = new Array();
    var nimgArray = new Array();
    var imgreg = /<[iI][mM][gG][^>]+[^>]*>/g; //img标签匹配
    var imgs = document.getElementsByName("jinghua");
    for(var i=0;i< imgs.length;i++){
        var imgObje = imgs[i];
        imgObje.width = 80;
        var imgAlt = imgObje.alt; //获取图片说明
        var imgPath = imgObje.src; //获取图片路径
        var imgTag = imgreg.exec(html)[0]; //获取图片标签
        imgsJSON += "{\"img\":\""+imgPath+"\" , \"description\":\""+imgAlt+"\"},"
        var nphoto = IMG_TAG.replace(imgHoldTag,imgTag).replace(imgHoldAltTag,imgAlt).replace(imgHoldIndex,i);
        nimgArray.push(nphoto);
        imgArray.push(imgTag);
    }
    
    imgsJSON = imgsJSON.substr(0,imgsJSON.length-1);
    imgsJSON += "]";
    
    for(i = 0; i < imgArray.length; i++){
        html = html.replace(imgArray[i],nimgArray[i]);
    }
    
    newsContent.innerHTML = html;
}

//设置图片宽度
function imgWith(){
    var imgs = document.getElementsByName("jinghua");
    for(var i=0;i< imgs.length;i++){
        var imgObje = imgs[i];
        imgObje.width = 80;
        
        //                var ab = 0;
        //                imgObje.onload = function ()
        //                {
        //                    if(ab > 0){
        //                        return;
        //                    }
        //                    ab++;
        //                    imgObje.src = "http://1001.169bb.com/169mm/201008/046/8.jpg"
        //                }
    }
}
