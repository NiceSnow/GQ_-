//
//  ViewController4.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ViewController4.h"
#import "TableViewCell.h"

@interface ViewController4 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITableView* tableView2;
@property(nonatomic,strong) NSMutableArray* dataArray;
@end

@implementation ViewController4


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell* cell = [TableViewCell createCellWithTableView:tableView];
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }else{
        
    }
    [self.tableView reloadData];
    [self.tableView2 reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    adjustsScrollViewInsets_NO(self.tableView, self);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addTestData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableView2];
    [self setrightBarItem:@"play"];
    
    UIButton* btn = [UIButton new];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.height.equalTo(@150);
        make.left.offset(screenWidth/2);
    }];
    // Do any additional setup after loading the view from its nib.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth/2, screenHeight - tabBarHeight) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(UITableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, screenHeight) style:(UITableViewStylePlain)];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tableFooterView = [UIView new];
    }
    return _tableView2;
}

-(void)rightPress:(UIButton*)btn{
    [self addTestData];
    [self.tableView reloadData];
    [self.tableView2 reloadData];
}

-(void)addTestData{
    for (int i = 0; i < 2; i ++) {
        NSMutableArray* arr = [NSMutableArray new];
        for (int j = 0; j <10; j++) {
            [arr addObject:[NSString stringWithFormat:@"%d_%d",i,j]];
        }
        [_dataArray addObject:arr];
    }
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
