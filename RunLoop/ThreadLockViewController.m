//
//  ThreadLockViewController.m
//  RunLoop
//
//  Created by S on 2018/3/12.
//  Copyright © 2018年 S. All rights reserved.
//


/*
 线程锁
 
 死锁可能会崩溃
 */
#import "ThreadLockViewController.h"

@interface ThreadLockViewController ()

@end

@implementation ThreadLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}

- (void)test1{
    
    NSLog(@"1");//任务1
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");//任务2
    });
    
    NSLog(@"3");//任务3
    
    //执行任务1 遇到同步线程，等任务2执行完成之后再执行任务3 ，任务3先添加到主队列里面，任务3执行完再执行任务2 死锁
    
    
    
}

- (void)test2{
    NSLog(@"1");//任务1
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSLog(@"2");//任务2
    });
    
    NSLog(@"3");//任务3
    
    // 先执行任务1 -- 主线程遇到同步线程，阻塞主线程，执行任务2 （在全局队列执行任务2）-- 任务2 执行完才能执行任务3，同步线程阻塞了线程
}

- (void)test3{
    
    dispatch_queue_t queue = dispatch_queue_create("com.demo.seral", DISPATCH_QUEUE_SERIAL);
    
    
    NSLog(@"1");//任务1
    
    dispatch_async(queue, ^{
        NSLog(@"2");//任务2
        
        dispatch_sync(queue, ^{
            NSLog(@"3");//任务3
        });
        NSLog(@"4");//任务4
    });
    
    NSLog(@"5");//任务5
    
    //主队列加入 任务1、异步线程、任务5，因为异步，所以 1、2、5 或者1、5、2.  2、3、4 是添加到queue（串行队列）里面的3个任务，先2 遇到串行队列 3 ，等3执行完 再执行4，但是4先加入队列，所以4执行完再执行3 ，死锁
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
