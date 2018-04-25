//
//  SingleTableVC.m
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import "SingleTableVC.h"
#import "CommCell.h"
#import "Model.h"
#import "TimerManager.h"


static NSString *celliden = @"cell";

@interface SingleTableVC ()<UITableViewDelegate,UITableViewDataSource>


@property ( nonatomic,strong ) UITableView *tab;

@property ( nonatomic,strong ) NSMutableArray *dataArr;

@end

@implementation SingleTableVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tab];
    
    [KCountDownManager start];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden forIndexPath:indexPath];
    
    Model *model = self.dataArr[indexPath.row];
    cell.model = model;
    [cell setCountDownZero:^(Model *model) {
        if (!model.timeout) {
            NSLog(@"SingleTableVC -- %@ -- 时间到了",model.title);
        }
        model.timeout = YES;
    }];
    return cell;
}
- (UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.rowHeight = 44;
        [_tab registerNib:[UINib nibWithNibName:@"CommCell" bundle:nil] forCellReuseIdentifier:celliden];
        
    }
    return _tab;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        for (NSInteger  i = 0; i < 5; i++) {
            
            Model *model = [[Model alloc] init];
            model.title  = [NSString stringWithFormat:@"第%ld条数据",i];
            model.count = arc4random_uniform(100);//生成0- 100 之间的随机正整数
            [_dataArr  addObject:model];
        }
        
        [self.tab reloadData];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
