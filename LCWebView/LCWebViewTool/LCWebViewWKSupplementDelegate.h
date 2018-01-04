//
//  LCWebViewWKSupplementDelegate.h
//  LCWebView
//
//  Created by care on 2017/12/29.
//  Copyright © 2017年 luochuan. All rights reserved.
//
#import <WebKit/WKFoundation.h>
#if WK_API_ENABLED
#import <Foundation/Foundation.h>
#import <WebKit/WKPreviewActionItem.h>
NS_ASSUME_NONNULL_BEGIN
@class LCWebView;
/**
 LCWebViewWKSupplementDelegate 此代理所有方法均为WKWebView补充协议,不支持UIWebView,为了更好的用户体验,在此添加补充.
 */
@protocol LCWebViewWKSupplementDelegate <NSObject>
@optional
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

@end
NS_ASSUME_NONNULL_END
#endif
