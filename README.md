# LCWebView
全面适配UIWebView和WKWebView (iOS7使用UIWebView, iOS8AndLaster 使用WKWebView)

setting for protocol (LCWebViewDelegate)适用iOS7及以上

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
@optional
/**
 *  js传递参数给Native处理.此处可以进行弹框显示.
 *
 *  @param string js字符串
 *
 */
- (void)LC_jsCallWebViewReceiveString:(NSString *)string;



setting for protocol (LCWebViewWKSupplementDelegate)适用iOS8及以上(just WKWebView)
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

