***

***使用*** pod 'LCWebViewTool', '~> 1.0.0'

***
***

***License*** LCWebViewTool is released under the MIT license. See [LICENSE](https://github.com/LuochuanAD/LCWebView/blob/master/LICENSE "https://github.com/LuochuanAD/LCWebView/blob/master/LICENSE") for details.

***

***

***一,说明***

***
我的项目是从iOS7开始支持, 一直用UIWebView作为网页容器.  但是,为了更好的用户体验. 我将UIWebView和WKWebView封装合并成一个网页容器LCWebView. 下面是我的做法:
``` python

```
***
***二,LCWebViewDelegate (此代理所有方法均为WKWebView和UIWebView共同拥有的协议,支持iOS7及以上)***

***
此协议有5个方法.(如果项目要求不多,可以只使用这一个协议的方法):
``` python

/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 *
 *  @param navigationType 用户点击类型
 */
- (BOOL)LC_webView:(LCWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(LCWebViewNavigationType)navigationType;

/**
 *  开始加载 webview
 */
- (void)LC_webViewDidStartLoad:(LCWebView *)webView;

/**
 *  加载完成 webview
 */
- (void)LC_webViewDidFinishLoad:(LCWebView *)webView;

/**
 *  加载失败 webview
 *
 *  @param error 失败原因
 *
 */
- (void)LC_webView:(LCWebView *)webView didFailLoadWithError:(NSError *)error;

/**
 *  js传递参数给Native处理.此处可以进行弹框显示.
 *
 *  @param string js字符串
 *
 */
- (void)LC_jsCallWebViewReceiveString:(NSString *)string;
```

***

***三,LCWebViewWKSupplementDelegate (此代理所有方法均为WKWebView补充协议,不支持UIWebView,为了更好的用户体验,在此添加补充.支持iOS8及以上) 此协议有10个方法(此协议方法,在项目要求不多的情况下不使用也行):***

***
``` python

/**
 *  收到服务器响应决定是否跳转(WKWebView代理方法)
 *
 *  @param response 服务器返回值
 *
 *
 *  @param mainFrame 是否是主框架
 *
 */
- (BOOL)LC_webView:(LCWebView *)webView decidePolicyForNavigationResponse:(NSURLResponse *)response IsForMainFrame:(BOOL)mainFrame API_AVAILABLE(macosx(10.10), ios(8.0));
/**
 *  接收服务器跳转请求之后调用(WKWebView代理方法)
 *
 *  @param navigation 导航对象
 *
 */
-(void)LC_webView:(LCWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation API_AVAILABLE(macosx(10.10), ios(8.0));
/**
 *  当内容开始返回时调用(WKWebView代理方法)
 *
 *  @param navigation 导航对象
 *
 */
- (void)LC_webView:(LCWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation API_AVAILABLE(macosx(10.10), ios(8.0));//
/**
 *  打开新窗口(WKWebView代理方法)
 *
 *  @param configuration 新窗口的配置
 *
 *  @param navigationAction 导航行为对象
 *
 *  @param windowFeatures 窗口特性
 *
 */
- (nullable LCWebView *)LC_webView:(LCWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures API_AVAILABLE(macosx(10.10), ios(8.0));
/**
 *  权限认证. 注意测试iOS8系统,自签证书的验证是否可以.(暂时不建议使用该方法)(WKWebView代理方法)
 *
 *  @param challenge 验证
 *
 *  @param completionHandler 证书验证block
 *
 */
- (void)LC_webView:(LCWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler API_AVAILABLE(macosx(10.10), ios(8.0));
/**
 *  WKwebView关闭(WKWebView代理方法)
 */
- (void)LC_webViewDidClose:(LCWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
/**
 *  进程终止(WKWebView代理方法)
 */
- (void)LC_webViewWebContentProcessDidTerminate:(LCWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
/**
 *  是否预览(WKWebView代理方法)
 *
 *  @param elementInfo 预览元素信息(url)
 *
 */
- (BOOL)LC_webView:(LCWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(macosx(10.12), ios(10.0));
/**
 *  自定义预览视图(WKWebView代理方法)
 *
 *  @param elementInfo 预览元素信息(url)
 *
 *  @param previewActions 预览行为对象(title,identifier)
 *
 */
- (nullable UIViewController *)LC_webView:(LCWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(macosx(10.12), ios(10.0));
/**
 *  提交预览视图(WKWebView代理方法)
 *
 *  @param previewingViewController 预览视图ViewController
 *
 */
- (void)LC_webView:(LCWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(macosx(10.12), ios(10.0));

```
***

***四,通用的属性和调用方法.(支持iOS7及以上)***

***
``` python
@property (nonatomic, readonly, strong) UIScrollView *scrollView;
@property (nullable, nonatomic, readonly, copy) NSString *title;
@property (nullable, nonatomic, readonly, copy) NSURL *URL;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;
@property (nullable, nonatomic, readonly, strong) NSURLRequest *request;
@property (nonatomic, weak, nullable)id<LCWebViewDelegate> webDelegate;
@property (nonatomic, weak, nullable)id<LCWebViewWKSupplementDelegate> supplementDelegate;
/**
 *  LCWebView 初始化方法
 *
 *  @param configuration WKWebView自定义配置
 *
 */
- (instancetype)initWithFrame:(CGRect)frame withWKWebViewConfiguration:(nullable WKWebViewConfiguration * )configuration;
/**
 *  LCWebView 刷新
 */
- (nullable WKNavigation *)LC_reload;
/**
 *  LCWebView 返回下一页
 */
- (nullable WKNavigation *)LC_goBack;
/**
 *  LCWebView 返回上一页
 */
- (nullable WKNavigation *)LC_goForward;
/**
 *  LCWebView 停止加载
 */
- (void)LC_stopLoading;
/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 */
- (nullable WKNavigation *)LC_loadRequest:(NSURLRequest*)request;
/**
 *  加载一个 webview
 *
 *  @param string 请求的 URL String
 *
 *  @param baseURL 请求的 baseURL
 *
 */
- (nullable WKNavigation *)LC_loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (nullable WKNavigation *)LC_loadHTMLFileName:(NSString *)htmlName;
/**
 *  oc调js,只提供此方法
 *
 *  @param javaScriptString js字符串
 *
 *  @param completionHandler block
 *
 */
- (void)LC_evaluatJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError *_Nullable error))completionHandler;


```
***

***五, UIWebView的属性配置(只支持iOS7.可以不做任何设置)***

***
``` python
/**
 *  缩放页面适应屏幕大小(仅设置UIWebView)  注:iPhone Safari defaults to NO
 */
@property (nonatomic) BOOL scalesPageToFit;
/**
 *  把网页上内容转换成可点击的链接(仅设置UIWebView) 注:NS_OPTIONS 按位掩码 可以多选(电话,超链接,地址等等)
 */
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;
/**
 *  使用内嵌Html播放还是使用本地控制(仅设置UIWebView) 注:iPhone Safari defaults to NO. iPad Safari defaults to YES
 *  内嵌Html播放时,在HTML中的video元素必须包含webkit-playsinline属性
 */
@property (nonatomic) BOOL allowsInlineMediaPlayback;
/**
 *  自动播放还是手动播放(仅设置UIWebView) 注:iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction;
/**
 *  页面是否可以投影Air Play(仅设置UIWebView) 注:iPhone and iPad Safari both default to YES
 */
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay;
/**
 *  设置是否将数据加载入内存后渲染界面(仅设置UIWebView) 注:iPhone and iPad Safari both default to NO
 */
@property (nonatomic) BOOL suppressesIncrementalRendering;
/**
 *  设置用户是否能打开keyboard交互(仅设置UIWebView) 注:default is YES
 */
@property (nonatomic) BOOL keyboardDisplayRequiresUserAction;
/**
 *  当网页的大小超出view时，将网页以翻页效果展示(仅设置UIWebView) 注:NS_ENUM
 */
@property (nonatomic) UIWebPaginationMode paginationMode;
/**
 *  决定CSS的属性分页是否可用(仅设置UIWebView) 注:NS_ENUM 默认是UIWebPaginationBreakingModePage
 */
@property (nonatomic) UIWebPaginationBreakingMode paginationBreakingMode;
/**
 *  每一页的长度(仅设置UIWebView)
 */
@property (nonatomic) CGFloat pageLength;
/**
 *  每一页的间距(仅设置UIWebView)
 */
@property (nonatomic) CGFloat gapBetweenPages;
/**
 *  获取页数(仅设置UIWebView)
 */
@property (nonatomic, readonly) NSUInteger pageCount;

```

***

***六,WKWebView的属性和额外方法 (为了更好的用户体验,建议设置,不设置也行.支持iOS8及以上)***

***
``` python
/**
 *  网站列表,历史记录,可以通过前进和后退 (仅设置WKWebView)
 */
@property (nonatomic, readonly, strong) WKBackForwardList *backForwardList;
/**
 *  网页加载进度(仅设置WKWebView)   可以使用KVO监听
 */

@property (nonatomic, assign) double estimatedProgress;
/**
 *  是否安全加载页面(仅设置WKWebView)
 */
@property (nonatomic, readonly) BOOL hasOnlySecureContent;
/**
 *  是否允许水平滑动前进后退(仅设置WKWebView) 注:defaults to NO
 */
@property (nonatomic) BOOL allowsBackForwardNavigationGestures;
/**
 *  设置用户代理UserAgent(仅设置WKWebView) 注:iOS9及以上
 */
@property (nullable, nonatomic, copy) NSString *customUserAgent API_AVAILABLE(macosx(10.11), ios(9.0));
/**
 *  是否支持链接预览,3DTouch等等(仅设置WKWebView) 注:iOS9及以上
 */
@property (nonatomic) BOOL allowsLinkPreview API_AVAILABLE(macosx(10.11), ios(9.0));

/**
 *  定向跳转WKBackForwardList中某个页面
 *
 *  @param item 历史记录表中某个网页的对象.(仅支持WKWebView)
 */
- (nullable WKNavigation *)LC_goToBackForwardListItem:(WKBackForwardListItem *)item;
/**
 *  比较网络数据是否有变化，没有变化则使用缓存，否则从新请求.(仅支持WKWebView)
 */
- (nullable WKNavigation *)LC_reloadFromOrigin;

```
***

***七, 补充说明:***

***
(1) LCWebView 的初始化方法只提供一个方法:
``` python
- (instancetype)initWithFrame:(CGRect)frame withWKWebViewConfiguration:(nullable WKWebViewConfiguration * )configuration;
```
当手机系统版本为iOS7则使用UIWebView来加载,当手机系统为iOS8及以上时,LCWebView内部使用WKWebView来加载.如果参数:configuration 设置为nil时,LCWebView内部会默认设置好configuration.

(2) LCWebView 的Native调用js只提供一个方法:
``` python
- (void)LC_evaluatJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError *_Nullable error))completionHandler;
```
(3) LCWebView 的调js用Native只提供LCWebViewDelegate协议中一个方法:
``` python
- (void)LC_jsCallWebViewReceiveString:(NSString *)string;
``` 
注:所有的js调用Native的弹框.都通过该方法来处理.
例如如下前端代码,通过传递给Native端的字符串来进行弹框显示,具体可以看Demo:
``` python
<input type="button" value="js传参给Native" onclick="callFunc()">
<script type="text/javascript">

        function callOC(func,param){
            var url= "func=" + func;
            for(var i in param)
        {
            url = url + "&" + i + "=" + param[i];
        }
        
            window.webkit.messageHandlers.Native.postMessage(url);   
        }
        function callFunc(){
            var stack = new Array();
            stack["user"] = "泰日天";
            stack["message"] = "我是帅哥吗?";
            stack["time"]  = new Date();
            callOC("Alert",stack);
        }
    </script>
``` 
(4) LCWebView 提供POST请求.方法:
``` python
- (nullable WKNavigation *)LC_loadRequest:(NSURLRequest*)request;
```
(5) LCWebView 提供加载网页进度.可以通过KVO来获取,详情看Demo. 

(6)LCWebView 在iOS8的系统上,内部使用的是WKWebView. WKWebView加载本地的css,js出现的样式显示不出来等问题.这是系统本身的bug. 我暂时无法解决.   LCWebView不推荐加载带有本地css,js文件的html.   单纯的加载一个html从iOS7开始是支持的.

(7) LCWebView 关于https加载自签名证书的解决方法:
UIWebView的https 自签名证书解决方法: [http://blog.csdn.net/luochuanad/article/details/53410537](http://blog.csdn.net/luochuanad/article/details/53410537 "http://blog.csdn.net/luochuanad/article/details/53410537")

WKWebView的https 自签名证书的解决方法:
[https://github.com/LuochuanAD/HybirdWKWebVIew](https://github.com/LuochuanAD/HybirdWKWebVIew "https://github.com/LuochuanAD/HybirdWKWebVIew")

(8)LCWebView 关于cookie的问题:
[https://www.jianshu.com/p/85f24794bbea](https://www.jianshu.com/p/85f24794bbea "https://www.jianshu.com/p/85f24794bbea")

