//
//  LCWebView.h
//  LCWebView
//
//  Created by care on 2017/12/20.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHeader.h"
#import <WebKit/WebKit.h>
#import "LCWebViewDelegate.h"
#import "LCWebViewWKSupplementDelegate.h"
NS_ASSUME_NONNULL_BEGIN
//@protocol LCWebViewDelegate;
//@protocol LCWebViewWKSupplementDelegate;
@interface LCWebView : UIView
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





#pragma mark ---------为了更好的用户体验 WKWebView 补充属性和方法(仅支持iOS8及以上,可不做任何设置)-----------------
#if WK_API_ENABLED
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

/** iOS11 的这2个方法未封装
- (void)takeSnapshotWithConfiguration:(nullable WKSnapshotConfiguration *)snapshotConfiguration completionHandler:(void (^)(UIImage * _Nullable snapshotImage, NSError * _Nullable error))completionHandler API_AVAILABLE(ios(11.0));
+ (BOOL)handlesURLScheme:(NSString *)urlScheme API_AVAILABLE(macosx(10.13), ios(11.0));
 */
#endif
#pragma mark ---------为了更好的用户体验 UIWebVieW 各属性配置(仅支持iOS7,可不做任何设置)-----------------

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

@end
NS_ASSUME_NONNULL_END
