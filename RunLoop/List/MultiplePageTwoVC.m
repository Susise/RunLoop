//
//  MultiplePageTwoVC.m
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import "MultiplePageTwoVC.h"
#import "CommCell.h"
#import "TimerManager.h"

static NSString *iden = @"celliden";

NSString *const MultiplePageSource2 = @"MultiplePageSource2";

@interface MultiplePageTwoVC ()<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic,strong ) NSArray *data1;

@property ( nonatomic,strong ) UITableView *tab;

@end

@implementation MultiplePageTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.title = @"页面倒计时2";
    
    [self.view addSubview:self.tab];
    
    // 启动倒计时管理
    [KCountDownManager start];
    // 增加倒计时源
    [KCountDownManager addSourceWithIndentifier:MultiplePageSource2];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data1.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    
    Model *model = self.data1[indexPath.row];
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
- (UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, self.view.frame.size.width, 400) style:UITableViewStyleGrouped];
        _tab.delegate =self;
        _tab.dataSource= self;
        _tab.rowHeight = 44;
        [_tab registerNib:[UINib nibWithNibName:@"CommCell" bundle:nil] forCellReuseIdentifier:iden];
    }
    return _tab;
}
- (NSArray *)data1{
    if (!_data1) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 50; i++) {
            
            NSInteger count = arc4random_uniform(100);
            
            Model *model = [[Model alloc] init];
            
            model.count = count;
            
            model.title = [NSString stringWithFormat:@"第%ld条数据",i];
            
            model.countDownSource = MultiplePageSource2;
            [array addObject:model];
        }
        _data1 = array.copy;
    }
    return _data1;
}

- (void)dealloc{
    
    [KCountDownManager removeSourceWithIdentifier:MultiplePageSource2];
    
    [KCountDownManager invalidate];
    
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
