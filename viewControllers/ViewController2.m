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
@property(nonatomic,strong) NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    [self addTestData];
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return _dataArray.count;
}

//确定每个section对应的item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

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
    [_dataArray removeAllObjects];
    [self.collectionVIew reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addTestData{
    for (int i = 0; i < 2; i ++) {
        NSMutableArray* arr = [NSMutableArray new];
        for (int j = 0; j <100; j++) {
            [arr addObject:[NSString stringWithFormat:@"%d_%d",i,j]];
        }
        [_dataArray addObject:arr];
    }
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
