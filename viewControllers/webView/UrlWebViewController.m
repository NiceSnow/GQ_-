//
//  UrlWebViewController.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "UrlWebViewController.h"
#import <WebKit/WebKit.h>
#import "HUDView.h"

@interface UrlWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView * webView;
@property(nonatomic,strong) baseScrollView* HeaderScrollView;
@end

@implementation UrlWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.HeaderScrollView];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.navigationItem.leftBarButtonItem = [Tools getBarButtonItemWithTarget:self action:@selector(leftBarButtonItemAction)];
    [HUDView showGIFHUD:self];
    [self loadWebView];
    // Do any additional setup after loading the view.
}

- (void)leftBarButtonItemAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
//        CATransition* transition = [CATransition animation];
//        //执行时间长短
//        transition.duration = 0.5;
//        //动画的开始与结束的快慢
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        //各种动画效果
//        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//        //动画方向
//        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//        //将动画添加在视图层上
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)loadWebView
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [HUDView hiddenHUD];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}
//WKUserContentController实现js native交互
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"%@",URL.absoluteString);
    //不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler (WKNavigationResponsePolicyAllow);
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView =  [[WKWebView alloc]init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor brownColor];
        [_webView sizeToFit];
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(baseScrollView *)HeaderScrollView{
    if (!_HeaderScrollView) {
        _HeaderScrollView = [[baseScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _HeaderScrollView.backgroundColor = [UIColor greenColor];
        //        _HeaderScrollView.delegate = self;
        _HeaderScrollView.contentSize = CGSizeMake(screenWidth*2, 0);
    }
    return _HeaderScrollView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
