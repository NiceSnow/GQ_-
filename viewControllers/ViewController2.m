//
//  ViewController2.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ViewController2.h"
#import "UIButton+extension.h"
#import "MYCollectionViewCell.h"

@interface ViewController2 ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"MYCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionVIew registerNib:nib forCellWithReuseIdentifier:@"MYCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_timeBtn startTime:5 title:@"123" waitTittle:@"321" complate:^{
//        NSLog(@"倒计时完成");
//        [MBProgressHUD showTitleToView:self.view contentStyle:NHHUDContentBlackStyle title:@"倒计时结束" afterDelay:2];
//    }];
}

//确定section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return 4; }

//确定每个section对应的item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return 20; }

//创建cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MYCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MYCollectionViewCell" forIndexPath:indexPath];
    cell.mylabel.text = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
    return cell;
}
    //设置item的大小
    -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath { return CGSizeMake(80, 80);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
}

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",contentOffsetY);
}
-( void )scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%f",contentOffsetY);
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
