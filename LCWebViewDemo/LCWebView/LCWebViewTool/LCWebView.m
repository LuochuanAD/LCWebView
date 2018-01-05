//
//  LCWebView.m
//  LCWebView
//
//  Created by care on 2017/12/20.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import "LCWebView.h"
#import "WeakDelegateWKWebViewController.h"

@interface LCWebView()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,WKWebWeakDelegate>
{
    WKUserContentController *userContentController;
    NSURLRequest *readWriteRequest;
    NSString *readWriteTitle;
    
}
@property (nonatomic, readonly, strong) id realWebView;
@end

@implementation LCWebView
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
-(void)dealloc{
    if (hasWKWebView) {
        [userContentController removeScriptMessageHandlerForName:@"Native"];
        [self removeAllKVOSetting];
        WKWebView *webview=(WKWebView *)self.realWebView;
        webview.UIDelegate=nil;
        webview.navigationDelegate=nil;
    }else{
        UIWebView *webview=(UIWebView *)self.realWebView;
        webview.delegate=nil;
    }
    [self.realWebView scrollView].delegate=nil;
    [self.realWebView removeFromSuperview];
    _realWebView=nil;
}

- (instancetype)initWithFrame:(CGRect)frame withWKWebViewConfiguration:(nullable WKWebViewConfiguration * )configuration{
    self=[super initWithFrame:frame];
    if (self) {
        [self initRealWebViewWithCustomSettingWithWKWebViewConfiguration:configuration];
    }
    return self;
}
- (void)initRealWebViewWithCustomSettingWithWKWebViewConfiguration:(nullable WKWebViewConfiguration * )configuration{
    if (hasWKWebView) {//ios8以上
        [self createWKWebViewWithWKWebViewConfiguration:configuration];
    }else{
        [self createUIWebView];
    }
    [self.realWebView setFrame:self.frame];
    [self addSubview:self.realWebView];
    
}
- (void)createWKWebViewWithWKWebViewConfiguration:(nullable WKWebViewConfiguration * )configuration{
    if (configuration==nil){
        configuration=[[NSClassFromString(@"WKWebViewConfiguration") alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.preferences = [WKPreferences new];
        // The minimum font size in points default is 0;
        configuration.preferences.minimumFontSize = 40;
        // 是否支持 JavaScript
        configuration.preferences.javaScriptEnabled = YES;
        // 不通过用户交互，是否可以打开窗口
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        //此处自定义默认配置
    }
    WeakDelegateWKWebViewController *delegateController=[[WeakDelegateWKWebViewController alloc]init];
    delegateController.delegate=self;
    userContentController=[[NSClassFromString(@"WKUserContentController") alloc]init];
    [userContentController addScriptMessageHandler:delegateController name:@"Native"];
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:wkUserScript];
    
    configuration.userContentController=userContentController;
    WKWebView *wkwebView=[[NSClassFromString(@"WKWebView") alloc]initWithFrame:self.frame configuration:configuration];
    wkwebView.UIDelegate=self;
    wkwebView.navigationDelegate=self;
    wkwebView.backgroundColor=[UIColor clearColor];
    wkwebView.opaque=NO;
    
    [wkwebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [wkwebView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    [wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _realWebView=wkwebView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        readWriteTitle=change[NSKeyValueChangeNewKey];
    }else if ([keyPath isEqualToString:@"URL"]){
        
    }else if ([keyPath isEqualToString:@"estimatedProgress"]){
        NSString *value=change[NSKeyValueChangeNewKey];
        self.estimatedProgress=value.doubleValue;
    }
}

- (void)removeAllKVOSetting{
    WKWebView *webview=(WKWebView *)self.realWebView;
    [webview removeObserver:self forKeyPath:@"title"];
    [webview removeObserver:self forKeyPath:@"URL"];
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    
}
- (void)createUIWebView{
    UIWebView *uiwebView=[[UIWebView alloc]initWithFrame:self.frame];
    uiwebView.backgroundColor=[UIColor clearColor];
    uiwebView.opaque=NO;
    for (UIView *subview in [uiwebView.scrollView subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            ((UIImageView *) subview).image = nil;
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    uiwebView.scalesPageToFit=YES;
    uiwebView.delegate=self;
    _realWebView=uiwebView;
}
- (nullable WKNavigation *)LC_reload{
    if (hasWKWebView) {
        return [(WKWebView *)self.realWebView reload];
    }else{
        [(UIWebView *)self.realWebView reload];
        return nil;
    }
}
- (nullable WKNavigation *)LC_goBack{
    if (hasWKWebView) {
        return [(WKWebView *)self.realWebView goBack];
    }else{
        [(UIWebView *)self.realWebView goBack];
        return nil;
    }
}
- (nullable WKNavigation *)LC_goForward{
    if (hasWKWebView) {
        return [(WKWebView *)self.realWebView goForward];
    }else{
        [(UIWebView *)self.realWebView goForward];
        return nil;
    }
}
- (void)LC_stopLoading;{
    if (hasWKWebView) {
        [(WKWebView *)self.realWebView stopLoading];
    }else{
        [(UIWebView *)self.realWebView stopLoading];
    }
}
- (NSURL *)URL{
    if (hasWKWebView) {
        return [(UIWebView *)self.realWebView request].URL;
    }else{
        return [(WKWebView *)self.realWebView URL];
    }
}

- (BOOL)isLoading{
    return [self.realWebView isLoading];
}
- (BOOL)canGoBack{
    return [self.realWebView canGoBack];
}
- (BOOL)canGoForward{
    return [self.realWebView canGoForward];
}
- (UIScrollView *)scrollView{
    return [self.realWebView scrollView];
}
- (NSString *)title{
    return readWriteTitle;
}
- (NSURLRequest *)request{
    if (hasWKWebView) {
        return readWriteRequest;
    }else{
        return [(UIWebView *)self.realWebView request];
    }
}
- (nullable WKNavigation *)LC_loadRequest:(NSURLRequest*)request{
    readWriteRequest=request;
    if (hasWKWebView) {
        
        if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]){
            NSString *url = request.URL.absoluteString;
            NSString *params = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
            if ([params containsString:@"="]) {
                params = [params stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
                params = [params stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
                params = [NSString stringWithFormat:@"{\"%@\"}", params];
            }else{
                params = @"{}";
            }
            NSLog(@"%@ POST参数:%@",request,params);
            NSString *js=[NSString stringWithFormat:@"%@wk_post(\"%@\", %@)",WKWebViewPost_JS,url,params];
            WeakSelf;
            [self LC_evaluatJavaScript:js completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                if (error && [weak_self.webDelegate respondsToSelector:@selector(LC_webView:didFailLoadWithError:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weak_self.webDelegate LC_webView:weak_self didFailLoadWithError:error];
                    });
                }
            }];
            return nil;
        }else{
            return [(WKWebView *)self.realWebView loadRequest:request];
        }
    }else{
        [(UIWebView *)self.realWebView loadRequest:request];
        return nil;
    }
}
- (nullable WKNavigation *)LC_loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL{
    if (hasWKWebView) {
        if (baseURL==nil) {
            NSString * basePath=[[NSBundle mainBundle] bundlePath];
            NSURL *baseurl=[NSURL fileURLWithPath:basePath];
            return [(WKWebView *)self.realWebView loadHTMLString:string baseURL:baseurl];
        }else{
            return [(WKWebView *)self.realWebView loadHTMLString:string baseURL:baseURL];
        }
    }else{
        [(UIWebView *)self.realWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    }
}
- (nullable WKNavigation *)LC_loadHTMLFileName:(NSString *)htmlName{
    NSString *htmlPath=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@.html",htmlName] ofType:nil];
    if (htmlPath) {
        if (@available(iOS 9.0, *)) {
            NSURL *fileURL=[NSURL fileURLWithPath:htmlPath];
            return [(WKWebView *)self.realWebView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        }else{
            NSURL *fileURL=[self fileURLForBuggyWKWebViewVersionEight:[NSURL fileURLWithPath:htmlPath]];
            NSURLRequest *fileRequest=[NSURLRequest requestWithURL:fileURL];
           return [self LC_loadRequest:fileRequest];
        }
    }else{
        return nil;
    }
}
- (NSURL *)fileURLForBuggyWKWebViewVersionEight:(NSURL *)fileURL
{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    return dstURL;
}
- (LCWebViewNavigationType)chooseNavigationForUIWebView:(UIWebViewNavigationType)navigationType{
    LCWebViewNavigationType lcNavigationType;
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            lcNavigationType=LCWebViewNavigationTypeLinkActivated;
        }
            break;
        case UIWebViewNavigationTypeFormSubmitted:
        {
            lcNavigationType=LCWebViewNavigationTypeFormSubmitted;
        }
            break;
        case UIWebViewNavigationTypeBackForward:
        {
            lcNavigationType=LCWebViewNavigationTypeBackForward;
        }
            break;
        case UIWebViewNavigationTypeReload:
        {
            lcNavigationType=LCWebViewNavigationTypeReload;
        }
            break;
        case UIWebViewNavigationTypeFormResubmitted:
        {
            lcNavigationType=LCWebViewNavigationTypeFormResubmitted;
        }
            break;
        case UIWebViewNavigationTypeOther:
        {
            lcNavigationType=LCWebViewNavigationTypeOther;
        }
            break;
            
        default:{
            lcNavigationType=LCWebViewNavigationTypeOther;
        }
            break;
    }
    return lcNavigationType;
}
- (LCWebViewNavigationType)chooseNavigationForWKWebView:(WKNavigationType)navigationType{
    LCWebViewNavigationType lcNavigationType;
    switch (navigationType) {
        case WKNavigationTypeLinkActivated:
        {
            lcNavigationType=LCWebViewNavigationTypeLinkActivated;
        }
            break;
        case WKNavigationTypeFormSubmitted:
        {
            lcNavigationType=LCWebViewNavigationTypeFormSubmitted;
        }
            break;
        case WKNavigationTypeBackForward:
        {
            lcNavigationType=LCWebViewNavigationTypeBackForward;
        }
            break;
        case WKNavigationTypeReload:
        {
            lcNavigationType=LCWebViewNavigationTypeReload;
        }
            break;
        case WKNavigationTypeFormResubmitted:
        {
            lcNavigationType=LCWebViewNavigationTypeFormResubmitted;
        }
            break;
        case WKNavigationTypeOther:
        {
            lcNavigationType=LCWebViewNavigationTypeOther;
        }
            break;
            
        default:{
            lcNavigationType=LCWebViewNavigationTypeOther;
        }
            break;
    }
    return lcNavigationType;

}
- (void)LC_evaluatJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError *_Nullable error))completionHandler{
    if (hasWKWebView) {
        [(WKWebView *)self.realWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }else{
      NSString *result=[(UIWebView *)self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler) {
            completionHandler(result,nil);
        }
    }
}
#pragma mark  -----所有的webView delegate--------
#pragma mark -------WKScriptMessageHandler----------------------
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //js 调用方法,传递参数.  进行js调用Native的一系列操作处理. 如调用原生弹框
    /*
     function callOC(func,param){
     var url= "func=" + func;
     for(var i in param)
     {
     url = url + "&" + i + "=" + param[i];
     }
     window.webkit.messageHandlers.Native.postMessage(url);
     }
     **/
    if ([message.name isEqualToString:@"Native"]) {
        if ([self.webDelegate respondsToSelector:@selector(LC_jsCallWebViewReceiveString:)]) {
            [self.webDelegate LC_jsCallWebViewReceiveString:message.body];
        }
    }
}
#pragma mark  -----UIWebViewDelegate--------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //js 调用方法,传递参数.  进行js调用Native的一系列操作处理. 如调用原生弹框
    /*
     function callOC(func,param){
     var url= "native:" + "&func=" + func;
     for(var i in param)
     {
     url = url + "&" + i + "=" + param[i];
     }
     document.location = url;
     }
     **/
    NSString *requestBody=[[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//iOS9以下可以使用,此处警告不用管
    if ([requestBody hasPrefix:@"native"]) {
        if ([self.webDelegate respondsToSelector:@selector(LC_jsCallWebViewReceiveString:)]) {
            [self.webDelegate LC_jsCallWebViewReceiveString:requestBody];
        }
    }
    
    BOOL result=YES;
    if ([self.webDelegate respondsToSelector:@selector(LC_webView:shouldStartLoadWithRequest:navigationType:)]) {
        LCWebViewNavigationType lcNavigationType=[self chooseNavigationForUIWebView:navigationType];
        result=[self.webDelegate LC_webView:self shouldStartLoadWithRequest:request navigationType:lcNavigationType];
    }
    
    return result;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.webDelegate respondsToSelector:@selector(LC_webViewDidStartLoad:)]) {
        [self.webDelegate LC_webViewDidStartLoad:self];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    readWriteTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.webDelegate respondsToSelector:@selector(LC_webViewDidFinishLoad:)]) {
        [self.webDelegate LC_webViewDidFinishLoad:self];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.webDelegate respondsToSelector:@selector(LC_webView:didFailLoadWithError:)]) {
        [self.webDelegate LC_webView:self didFailLoadWithError:error];
    }
}
#pragma mark ------WKUIDelegate---------------
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]){
        return (WKWebView *)[self.supplementDelegate LC_webView:self createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }
    return nil;
}
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
- (void)webViewDidClose:(WKWebView *)webView{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webViewDidClose:)]) {
        if (@available(iOS 9.0, *)) {
            [self.supplementDelegate LC_webViewDidClose:self];
        }
    }
}
#else
#endif

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:shouldPreviewElement:)]) {
        if (@available(iOS 10.0, *)) {
            return [self.supplementDelegate LC_webView:self shouldPreviewElement:elementInfo];
        }
    }
    return NO;
}
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:previewingViewControllerForElement:defaultActions:)]) {
        if (@available(iOS 10.0, *)) {
            return [self.supplementDelegate LC_webView:self previewingViewControllerForElement:elementInfo defaultActions:previewActions];
        }
    }
    return nil;
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:commitPreviewingViewController:)]) {
        if (@available(iOS 10.0, *)) {
            [self.supplementDelegate LC_webView:self commitPreviewingViewController:previewingViewController];
        }
    }
}
#else
#endif

#pragma mark -------WKNavigationDelegate------------
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL result=YES;
    if ([self.webDelegate respondsToSelector:@selector(LC_webView:shouldStartLoadWithRequest:navigationType:)]) {
        LCWebViewNavigationType lcNavigationType=[self chooseNavigationForWKWebView:navigationAction.navigationType];
        result=[self.webDelegate LC_webView:self shouldStartLoadWithRequest:navigationAction.request navigationType:lcNavigationType];
    }
    NSURL *url=navigationAction.request.URL;
    // APPStore
    if ([url.absoluteString containsString:@"itunes.apple.com"]||[url.scheme isEqualToString:@"tel"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            if (@available(iOS 10.0, *)) {
                NSDictionary *options=@{UIApplicationOpenURLOptionUniversalLinksOnly:@YES};
                [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if (result) {
        readWriteRequest=navigationAction.request;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:decidePolicyForNavigationResponse:IsForMainFrame:)]) {
        BOOL result=[self.supplementDelegate LC_webView:self decidePolicyForNavigationResponse:navigationResponse.response IsForMainFrame:navigationResponse.forMainFrame];
        if (!result) {
            decisionHandler(WKNavigationResponsePolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if ([self.webDelegate respondsToSelector:@selector(LC_webViewDidStartLoad:)]) {
        [self.webDelegate LC_webViewDidStartLoad:self];
    }
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:didReceiveServerRedirectForProvisionalNavigation:)]){
        [self.supplementDelegate LC_webView:self didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if ([self.webDelegate respondsToSelector:@selector(LC_webView:didFailLoadWithError:)]) {
        [self.webDelegate LC_webView:self didFailLoadWithError:error];
    }
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:didCommitNavigation:)]){
        [self.supplementDelegate LC_webView:self didCommitNavigation:navigation];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        readWriteTitle=[NSString stringWithFormat:@"%@",obj];
    }];
    if ([self.webDelegate respondsToSelector:@selector(LC_webViewDidFinishLoad:)]) {
        [self.webDelegate LC_webViewDidFinishLoad:self];
    }
    
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if ([self.webDelegate respondsToSelector:@selector(LC_webView:didFailLoadWithError:)]) {
        [self.webDelegate LC_webView:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webView:didReceiveAuthenticationChallenge:completionHandler:)]){
        [self.supplementDelegate LC_webView:self didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }
//    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
}
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"LCWebView提醒进程终止URL:%@",webView.URL);
    if ([self.supplementDelegate respondsToSelector:@selector(LC_webViewWebContentProcessDidTerminate:)]){
        if (@available(iOS 9.0, *)) {
            [self.supplementDelegate LC_webViewWebContentProcessDidTerminate:self];
        } else {
            // Fallback on earlier versions
        }
    }
    //首先 在此处刷新[webView reload]高内存消耗,解决白屏; 其次,在viewWillAppear中检测到webview.title为空,则reload webview.
}
#else
#endif

#pragma mark -------为了更好的用户体验 UIWebVieW 各属性配置(仅支持iOS7)----------
- (BOOL)scalesPageToFit{
    return [(UIWebView *)self.realWebView scalesPageToFit];
}
- (BOOL)allowsInlineMediaPlayback{
    return [(UIWebView *)self.realWebView allowsInlineMediaPlayback];
}
- (BOOL)mediaPlaybackRequiresUserAction{
    return [(UIWebView *)self.realWebView mediaPlaybackRequiresUserAction];
}
- (BOOL)mediaPlaybackAllowsAirPlay{
    return [(UIWebView *)self.realWebView mediaPlaybackAllowsAirPlay];
}
- (BOOL)suppressesIncrementalRendering{
    return [(UIWebView *)self.realWebView suppressesIncrementalRendering];
}
- (BOOL)keyboardDisplayRequiresUserAction{
    return [(UIWebView *)self.realWebView keyboardDisplayRequiresUserAction];
}
- (CGFloat)pageLength{
    return [(UIWebView *)self.realWebView pageLength];
}
- (CGFloat)gapBetweenPages{
    return [(UIWebView *)self.realWebView gapBetweenPages];
}
- (NSUInteger)pageCount{
    return [(UIWebView *)_realWebView pageCount];
}
- (UIDataDetectorTypes)dataDetectorTypes{
    return [(UIWebView *)self.realWebView dataDetectorTypes];
}
- (UIWebPaginationMode)paginationMode{
    return [(UIWebView *)self.realWebView paginationMode];
}
- (UIWebPaginationBreakingMode)paginationBreakingMode{
    return [(UIWebView *)self.realWebView paginationBreakingMode];
}
#pragma mark -------为了更好的用户体验 WKWebView 补充属性和方法(iOS8及以上)----------

- (WKBackForwardList *)backForwardList{
    return [(WKWebView *)self.realWebView backForwardList];
}
- (BOOL)hasOnlySecureContent{
    return [(WKWebView *)self.realWebView hasOnlySecureContent];
}
- (BOOL)allowsBackForwardNavigationGestures{
    return [(WKWebView *)self.realWebView allowsBackForwardNavigationGestures];
}
- (NSString *)customUserAgent{
    return [(WKWebView *)self.realWebView customUserAgent];
}
- (BOOL)allowsLinkPreview{
    return [(WKWebView *)self.realWebView allowsLinkPreview];
}
- (nullable WKNavigation *)LC_goToBackForwardListItem:(WKBackForwardListItem *)item{
    return [(WKWebView *)self.realWebView goToBackForwardListItem:item];
}
- (nullable WKNavigation *)LC_reloadFromOrigin{
    return [(WKWebView *)self.realWebView reloadFromOrigin];
}
@end
