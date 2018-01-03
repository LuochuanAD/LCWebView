//
//  LCWebViewController.m
//  LCWebView
//
//  Created by care on 2018/1/2.
//  Copyright © 2018年 luochuan. All rights reserved.
//

#import "LCWebViewController.h"
#import "LCWebView.h"

@interface LCWebViewController ()<LCWebViewDelegate,LCWebViewWKSupplementDelegate>
@property (nonatomic, strong) LCWebView * webView;
@end

@implementation LCWebViewController
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpWebView];
    }
    return self;
}
- (void)loadRequest:(NSURLRequest *)request{
    [self.webView LC_loadRequest:request];
}
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL{
    [self.webView LC_loadHTMLString:string baseURL:baseURL];
}
- (void)loadHTMLFileName:(NSString *)htmlName{
    [self.webView LC_loadHTMLFileName:htmlName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        NSString *str=change[NSKeyValueChangeNewKey];
        NSLog(@"=======进度条=======%@",str);
    }
}

- (void)setUpWebView{
    if (!_webView) {
        _webView=[[LCWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withWKWebViewConfiguration:nil];//configuration若为nil,则会默认设置,前往查看LCWebView.m
        _webView.webDelegate=self;
        _webView.supplementDelegate=self;
        _webView.backgroundColor=[UIColor whiteColor];
        _webView.scalesPageToFit=YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_webView];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_webView.title==nil) {
        [_webView LC_reload];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_webView.title!=nil) {
        self.navigationItem.title=_webView.title;
    }
    
}
#pragma mark -----基本用法----LCWebViewDelegate------------
- (BOOL)LC_webView:(LCWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(LCWebViewNavigationType)navigationType{
    if (navigationType==LCWebViewNavigationTypeFormSubmitted) {//例如,提交表单,NO
        return NO;
    }
    
    return YES;
}

- (void)LC_webViewDidStartLoad:(LCWebView *)webView{
    NSLog(@"开始加载");
    
}
- (void)LC_webViewDidFinishLoad:(LCWebView *)webView{
    NSLog(@"加载结束");
    self.navigationItem.title=_webView.title;
}
- (void)LC_webView:(LCWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败%@",error);
}
- (void)LC_jsCallWebViewReceiveString:(NSString *)string{
    NSLog(@"---js传递OC的字符串------%@",string);
    NSMutableDictionary *param = [self queryStringToDictionary:string];
    NSLog(@"get param:%@",[param description]);
    NSString *func = [param objectForKey:@"func"];
    //调用本地函数
    if([func isEqualToString:@"Alert"])//此处为样例
    {
        [self showMessage:@"来自网页的提示" message:[param objectForKey:@"message"]];
    }
    
}
//get参数转字典
- (NSMutableDictionary*)queryStringToDictionary:(NSString*)string {
    NSMutableArray *elements = (NSMutableArray*)[string componentsSeparatedByString:@"&"];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return retval;
}
-(void)showMessage:(NSString *)title message:(NSString *)message;
{
    if (message == nil) return;
    if (NSClassFromString(@"WKWebView")){
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *jsString=[NSString stringWithFormat:@"document.getElementsByTagName('p')[0].style.color='%@';",@"green"];
            [self.webView LC_evaluatJavaScript:jsString completionHandler:^(id _Nullable customObject, NSError * _Nullable error) {
                
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSString *jsString=[NSString stringWithFormat:@"document.getElementsByTagName('p')[0].style.color='%@';",@"red"];
            [self.webView LC_evaluatJavaScript:jsString completionHandler:^(id _Nullable customObject, NSError * _Nullable error) {
                
            }];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -----更好的用户体验用法----LCWebViewWKSupplementDelegate------------

- (BOOL)LC_webView:(LCWebView *)webView decidePolicyForNavigationResponse:(NSURLResponse *)response IsForMainFrame:(BOOL)mainFrame{
    NSLog(@"收到服务器响应决定是否跳转");
    if (mainFrame==NO) {//例如;不是主框架 No
        return NO;
    }
    return YES;
}

-(void)LC_webView:(LCWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"接收服务器跳转请求之后调用");
}
- (void)LC_webView:(LCWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"当内容开始返回时调用");
}
- (nullable LCWebView *)LC_webView:(LCWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    NSLog(@"打开新窗口");
    return nil;
}

- (void)LC_webView:(LCWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"权限认证. 注意测试iOS8系统,自签证书的验证是否可以");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
}
- (void)LC_webViewDidClose:(LCWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){
    NSLog(@"WKwebView关闭");
}

- (void)LC_webViewWebContentProcessDidTerminate:(LCWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0));
{
//    首先 在此处刷新[webView reload]高内存消耗,解决白屏; 其次,在viewWillAppear中检测到webview.title为空,则reload webview.
    NSLog(@"进程终止");
    [_webView LC_reload];
}
- (BOOL)LC_webView:(LCWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(macosx(10.12), ios(10.0)){
    NSLog(@"是否预览");
    return NO;
}
- (nullable UIViewController *)LC_webView:(LCWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(macosx(10.12), ios(10.0)){
    NSLog(@"自定义预览视图");
    return nil;
}
- (void)LC_webView:(LCWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(macosx(10.12), ios(10.0)){
    NSLog(@"提交预览视图");
}


@end
