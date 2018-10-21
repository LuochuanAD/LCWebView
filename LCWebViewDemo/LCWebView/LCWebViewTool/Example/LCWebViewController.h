//
//  LCWebViewController.h
//  LCWebView
//
//  Created by care on 2018/1/2.
//  Copyright © 2018年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCWebViewController : UIViewController
- (void)loadRequest:(NSURLRequest *)request;//加载网页

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)loadHTMLFileName:(NSString *)htmlName;
@end
