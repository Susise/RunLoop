//
//  MultipleTableVC.m
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import "MultipleTableVC.h"
#import "TimerManager.h"
#import "CommCell.h"
#import "Model.h"

NSString *const MultipleTableSource1 = @"MultipleTableSource1";
NSString *const MultipleTableSource2 = @"MultipleTableSource2";


static NSString *celliden = @"cell";

#define h  [UIApplication sharedApplication].statusBarFrame.size.height + 44

@interface MultipleTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic,strong ) UITableView *tab1;

@property ( nonatomic,strong ) UITableView *tab2;

@property ( nonatomic,strong ) NSMutableArray *arr1;

@property ( nonatomic,strong ) NSMutableArray *arr2;

@end

@implementation MultipleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多列表倒计时";
    
    [self.view addSubview:self.tab1];
    
    [self.view addSubview:self.tab2];
   
    [KCountDownManager start];
    
    //增加倒计时源
    [KCountDownManager addSourceWithIndentifier:MultipleTableSource1];
    
    [KCountDownManager addSourceWithIndentifier:MultipleTableSource2];
}

#pragma mark -- delegate
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (tableView == self.tab1) ? self.arr1.count:self.arr2.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden forIndexPath:indexPath];
    
    Model *model = (tableView == self.tab1)?self.arr1[indexPath.row]:self.arr2[indexPath.row];
    cell.model = model;
    [cell setCountDownZero:^(Model *model) {
        if (!model.timeout) {
            NSLog(@"SingleTableVC -- %@ -- 时间到了",model.title);
        }
        model.timeout = YES;
    }];
    return cell;
}


#pragma mark -- lazy loading
- (UITableView *)tab1{
    if (!_tab1) {
        _tab1 = [[UITableView alloc] initWithFrame:CGRectMake(0, h , self.view.frame.size.width, 200) style:UITableViewStyleGrouped];
        _tab1.delegate = self;
        _tab1.dataSource = self;
        _tab1.rowHeight = 44;
        [_tab1 registerNib:[UINib nibWithNibName:@"CommCell" bundle:nil] forCellReuseIdentifier:celliden];
    }
    return _tab1;
}
- (UITableView *)tab2{
    if (!_tab2) {
        _tab2 = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tab1.frame.size.height + h + 20 , self.view.frame.size.width, 200) style:UITableViewStyleGrouped];
        _tab2.delegate = self;
        _tab2.dataSource = self;
        _tab2.rowHeight = 44;
        [_tab2 registerNib:[UINib nibWithNibName:@"CommCell" bundle:nil] forCellReuseIdentifier:celliden];
    }
    return _tab2;
}
- (NSMutableArray *)arr1{
    if (!_arr1) {
        _arr1 = [NSMutableArray array];
        for (NSInteger i = 0; i < 50; i++) {
            NSInteger count = arc4random_uniform(100);//生成0-100之间的随机正整数
            Model *model = [[Model alloc] init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%ld条数据",i];
            model.countDownSource = MultipleTableSource1;
            [_arr1 addObject:model];
        }
    }
    return _arr1;
}
- (NSMutableArray *)arr2{
    if (!_arr2) {
        _arr2 = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 50;  i++) {
            NSInteger count = arc4random_uniform(100);//随机0 -100 的正整数
            Model *model = [[Model alloc] init];
            model.count = count;
            model.title = [NSString stringWithFormat:@"第%ld条数据",i];
            model.countDownSource = MultipleTableSource2;
            [_arr2 addObject:model];
        }
    }
    return _arr2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [KCountDownManager removeAllSource];
    [KCountDownManager invalidate];
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
