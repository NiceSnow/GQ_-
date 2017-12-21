

#import "NewFeatureView.h"
#import "UIImage+extension.h"


static NSInteger kCount = 3;
@interface NewFeatureView () <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
    NSArray* dataArray;
    UIButton* _lastBtn;
    NSInteger _currentIndex;
}
@property(nonatomic,assign) CGPoint startLocation;
@property(nonatomic,assign) CGPoint stopLocation;
@end

@implementation NewFeatureView

#pragma mark 自定义view
- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addScrollView];
    
    [self addScrollImages];
    
    [self addPageControl];
    
    UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

- (void)handleSwipeFrom:(UIPanGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _startLocation = [recognizer locationInView:self.view];
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        _stopLocation = [recognizer locationInView:self.view];
        CGFloat dx = _stopLocation.x - _startLocation.x;
        if(dx>85) {
            if (_currentIndex>0) {
                _currentIndex--;
                [UIView transitionWithView:_scroll duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    _scroll.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
                [_scroll setContentOffset:CGPointMake(_currentIndex * screenWidth, 0) animated:NO];
            }
        }
        if(dx<-85) {
            if (_currentIndex<kCount-1) {
                _currentIndex++;
                [UIView transitionWithView:_scroll duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    _scroll.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
                [_scroll setContentOffset:CGPointMake(_currentIndex * screenWidth, 0) animated:NO];
            }
        }
    }
    
}

- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    CGRect rect = [[UIScreen mainScreen] bounds];
    scroll.frame = rect;
    scroll.showsHorizontalScrollIndicator = NO;
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.scrollEnabled = NO;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        NSString* imageString = [NSString stringWithFormat:@"new_features_%d",i+1];
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(i * size.width, 0, size.width, size.height )];
        [_scroll addSubview:backView];
        UIImageView * backImageView = [UIImageView new];
        [backView addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight);
        }];
        backImageView.image = [UIImage AutorImage:imageString];
        backImageView.userInteractionEnabled = YES;
        backView.tag = i;
    }
}

#pragma mark 添加分页指示器
- (void)addPageControl
{
    UIPageControl *page = [[UIPageControl alloc] init];
    page.backgroundColor = [UIColor blueColor];
    page.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.93);
    page.numberOfPages = kCount;
    [page setValue:[UIImage imageNamed:@"page"] forKeyPath:@"pageImage"];
    [page setValue:[UIImage imageNamed:@"pageSel"] forKeyPath:@"currentPageImage"];
    [page setSelected:YES];
    [self.view addSubview:page];
    _page = page;
    
    CGRect rect = CGRectMake(screenWidth/3, self.view.bounds.size.height*0.93 - screenWidth/3/4.5, screenWidth/3, screenWidth/3/291*76);
    UIButton * but=[[UIButton alloc]initWithFrame:rect];
    but.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.90);
    but.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [but setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(pressBut:) forControlEvents:UIControlEventTouchUpInside];
    but.hidden = YES;
    but.tag=1226;
    [self.view addSubview:but];
    _lastBtn = but;
}

-(void)pressBut:(id)sender
{
    [UIApplication sharedApplication].keyWindow.rootViewController = self.myTabbarController;
    [UserDefault setObject:newVersion forKey:versionKey];
    [UserDefault synchronize];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (_page.currentPage == kCount-1) {
        _page.hidden = YES;
        _lastBtn.hidden = NO;
    }else{
        _page.hidden = NO;
        _lastBtn.hidden = YES;
    }
}

@end
