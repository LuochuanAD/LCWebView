//
//  WeakDelegateWKWebViewController.h
//  LCWebView
//
//  Created by care on 2017/12/20.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@protocol WKWebWeakDelegate<NSObject>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
@end
@interface WeakDelegateWKWebViewController : UIViewController<WKScriptMessageHandler>
@property (weak, nonatomic) id<WKWebWeakDelegate> delegate;
@end
