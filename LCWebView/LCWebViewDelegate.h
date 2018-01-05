//
//  LCWebViewDelegate.h
//  LCWebView
//
//  Created by care on 2017/12/29.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class LCWebView;
typedef NS_ENUM(NSUInteger, LCWebViewNavigationType){
    LCWebViewNavigationTypeLinkActivated,
    LCWebViewNavigationTypeFormSubmitted,
    LCWebViewNavigationTypeBackForward,
    LCWebViewNavigationTypeReload,
    LCWebViewNavigationTypeFormResubmitted,
    LCWebViewNavigationTypeOther
};
/**
 LCWebViewDelegate 此代理所有方法均为WKWebView和UIWebView共同拥有的协议
 */
@protocol LCWebViewDelegate <NSObject>
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
@end
NS_ASSUME_NONNULL_END
