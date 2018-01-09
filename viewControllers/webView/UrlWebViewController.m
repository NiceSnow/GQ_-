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
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation UrlWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)rightPress:(UIButton*)btn{
//    本地发消息给h5
    //    webView.evaluateJavaScript("getName()") { (any,error) -> Void in
    [self.webView evaluateJavaScript:@"callAlert()" completionHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setrightBarItem:@"play"];
//    [self.view addSubview:self.HeaderScrollView];
    [self.view addSubview:self.webView];
    
    //进度条初始化
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 88, screenWidth, 2)];
    self.progressView.backgroundColor = [UIColor greenColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.navigationItem.leftBarButtonItem = [Tools getBarButtonItemWithTarget:self action:@selector(leftBarButtonItemAction)];
//    [HUDView showGIFHUD:self];
    [self loadWebView];
    // Do any additional setup after loading the view.
}

- (void)callAndroid:(id)message
{
    NSLog(@"------------------------------%@", message);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
    /*
     else if ([keyPath isEqualToString:@"title"]){
     
     if (object == self.wkWebView) {
     
     self.navigationItem.title = self.wkWebView.title;
     
     } else {
     
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
     }
     }
     */
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)leftBarButtonItemAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)loadWebView
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    [HUDView hiddenHUD];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
    [HUDView hiddenHUD];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
}
//WKUserContentController实现js native交互
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *msgBody = [[NSDictionary alloc] initWithDictionary:message.body];
    NSLog(@"%@",msgBody);
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
//        h5传消息到本地  userContentController方法接收消息
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc]init];
        //注册js方法
        config.userContentController = [[WKUserContentController alloc]init];
        //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
        [config.userContentController addScriptMessageHandler:self name:@"Message"];
//        常规设置
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        config.preferences = preferences;
        
        _webView =  [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
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

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
