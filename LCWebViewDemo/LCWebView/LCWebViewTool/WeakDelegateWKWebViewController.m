//
//  WeakDelegateWKWebViewController.m
//  LCWebView
//
//  Created by care on 2017/12/20.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import "WeakDelegateWKWebViewController.h"
@implementation WeakDelegateWKWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
    
}

@end
