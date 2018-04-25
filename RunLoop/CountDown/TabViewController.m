//
//  TabViewController.m
//  RunLoop
//
//  Created by S on 2018/3/8.
//  Copyright © 2018年 S. All rights reserved.
//

//NSTimeInterval类：是一个浮点数字，用来定义秒注意：将计数器的repeats设置为YES的时候，self的引用计数会加1。因此可能会导致self（即viewController）不能release，所以，必须在viewDidDisappear的时候，将计数器timer停止，否则可能会导致内存泄露。停止timer的运行，但这个是永久的停止：（注意：停止后，一定要将timer赋空，否则还是没有释放。不信？你自己试试~）

/*
 
 首先关闭定时器不能使用上面的方法，应该使用下面的方法
 [myTimer setFireDate:[NSDate distantFuture]];
 
 然后就可以使用下面的方法再此开启这个timer了：
 [myTimer setFireDate:[NSDate distantPast]];  在页面消失的时候关闭定时器，然后等页面再次打开的时候，又开启定时器。主要是为了防止它在后台运行，暂用CPU
 */
#import "TabViewController.h"
#import "SingleTableVC.h"
#import "MultipleTableVC.h"


static NSString *celliden = @"iden";

@interface TabViewController ()<UITableViewDelegate,UITableViewDataSource>

@property ( nonatomic,strong ) UITableView *tab;

@property ( nonatomic,strong ) NSArray *dataArr;


@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Cell 倒计时";
    
    [self.view addSubview:self.tab];
    
    self.dataArr = @[@"单个列表倒计时",@"多个列表倒计时",@"多个页面倒计时"];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:celliden forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
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
- (UITableView *)tab {
    if (!_tab) {
        _tab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tab.delegate = self;
        _tab.dataSource = self;
        [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:celliden];
    }
    return _tab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        NSArray *arr = @[@"MultiplePageOneVC",@"MultiplePageTwoVC"];
        UITabBarController *tab = [[UITabBarController alloc] init];
        
        UIViewController *vc1 = [[NSClassFromString(arr[0]) alloc] init];
        UIViewController *vc2 = [[NSClassFromString(arr[1]) alloc] init];
        vc1.title = @"item1";
        vc2.title = @"item2";
        tab.viewControllers = @[vc1,vc2];
        
        [self.navigationController pushViewController:tab animated:YES];
        
    }else{
        NSArray *vcarr = @[@"SingleTableVC",@"MultipleTableVC"];
        Class class = NSClassFromString(vcarr[indexPath.row]);
        UIViewController *vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
