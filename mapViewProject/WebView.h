//
//  WebView.h
//  mapViewProject
//
//  Created by amir sankar on 7/27/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface WebView : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString * url;
@property(strong,nonatomic) WKWebView *webView;
-(void)aMethod;

@end
