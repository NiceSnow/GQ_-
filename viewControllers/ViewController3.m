//
//  ViewController3.m
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#import "ViewController3.h"
#import "TableViewCell.h"
@interface ViewController3 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *jinduLabel;

@property(nonatomic,strong) baseScrollView* HeaderScrollView;
@end

@implementation ViewController3
- (IBAction)DownloadBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected){
        
    }else{
        
    }
}

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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count>0) {
        [_dataArray removeAllObjects];
    }else{
        
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    [self addTestData];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.HeaderScrollView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(baseScrollView *)HeaderScrollView{
    if (!_HeaderScrollView) {
        _HeaderScrollView = [[baseScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
        _HeaderScrollView.backgroundColor = [UIColor greenColor];
//        _HeaderScrollView.delegate = self;
        _HeaderScrollView.contentSize = CGSizeMake(screenWidth*2, 0);
    }
    return _HeaderScrollView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
