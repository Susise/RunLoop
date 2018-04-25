//
//  ViewController.m
//  RunLoop
//
//  Created by S on 2018/3/7.
//  Copyright © 2018年 S. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property ( nonatomic,strong ) dispatch_source_t timer;

@property ( nonatomic,assign ) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 60;
    
//    [self timer1];
    
    [self cfrunloopObserverrefTest];
}

- (void)cfrunloopObserverrefTest{
    /*
     参数1 指定如果给Observer分配的内存空间
     参数2 需要监听的状态类
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入Runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer");
                break;
                
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source");
                break;
                
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                break;
                
            case kCFRunLoopAfterWaiting:
                NSLog(@"Runloop刚从睡眠中唤醒");
                break;
                
            case kCFRunLoopExit:
                NSLog(@"Runloop即将退出");
                break;
                
            default:
                break;
        }
    });
    
    //给主线程的Runloop 添加一个观察者，要监听的是RunLoop的哪种运行模式
    
    /*
     参数1 需要给哪个runloop 添加观察者
     参数2 需要添加的Observer对象
     参数3 在哪种模式下可以监听 KCFRunLoopDefaultMode == NSDefaultRunLoopMode
     */
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopDefaultMode);
    
}

- (void)timer1{
    
    NSLog(@"%s",__func__);
    
    __block NSInteger second = 5;
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"-----2.0秒后执行-----");
    });
    */
    
    //创建一个定时器
    
    /*
     参数1 source 的类型 DISPATCH_SOURCE_TYPE_TIMER 定时器
     参数2 线程等信息
     参数3 对第二个参数的描述信息
     参数4 传递一个队列，该队列对应了将来的回调方法在哪个线程中执行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    self.timer = timer;
    
    //开始的时间
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 3.0*NSEC_PER_SEC);
    
    //间隔时间
    uint64_t interval = 1.0 *NSEC_PER_SEC;
    
    /*
     参数1：需要给哪个定时器设置
     参数2：定时器开始的时间 DISPATCH_TIME_NOW 是立即执行
     参数3：定时器开始之后的时间间隔
     参数4 定时器间隔执行的精准度，传入0 代表最精准，尽量让定时器精准，传入一个大于0的值，代表多少秒的范围是可以接受的
     参数4存在的意义 ：主要是为了提高程序的性能。
     注意：Dispatch 定时器接收的时间是纳秒
     */
    dispatch_source_set_timer(timer, startTime, interval, 0 *NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           //刷新UI
            if (second > 0) {
                second--;
            }else{
                dispatch_source_cancel(timer);
                
                NSLog(@"定时器走完了");
            }
            
            NSLog(@"test 主线程 --- %@",[NSThread currentThread]);
            
        });
        NSLog(@"test 子线程 --- %@",[NSThread currentThread]);
    });
    
    //开启定时器
    dispatch_resume(timer);
}

- (void)timer2{
    NSLog(@"%s",__func__);
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
    
    //将NSTimer 添加到RunLoop 中，并告诉系统，当前Timer只有在RunLoop 的默认模式下才有效
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //将NSTimer 添加到RunLoop 中，并告诉系统，当前Timer只有在RunLoop 的UITrackingRunLoopMode 下才有效
    
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    //将NSTimer 添加到RunLoop 中，并且告诉系统，在所有被标记 common的模式都可以运行
   [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)timer3{
    
    NSLog(@"%s---%@",__func__,[NSThread currentThread]);
    
    //  如果是通过scheduledTimerWithTimeInterval创建的NSTimer 默认就会添加到RunLoop的DefauliMode中，所以会自动运行
    NSTimer *tiemr = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
    
    //虽然默认已经添加到DefaultMode中，但是我们也可以自己修改他的模式。
    [[NSRunLoop currentRunLoop] addTimer:tiemr forMode:NSRunLoopCommonModes];
    
    //开启子线程对应的RunLoop 注意：如果是子线程，那么需要手动创建子线程对应的RunLoop 子线程对应的Runloop还需要手动开启
    
    [[NSRunLoop currentRunLoop] run];
}
- (void)timer4{
    
    NSLog(@"%s",__func__);
    
    [self performSelectorInBackground:@selector(timer4show) withObject:nil];
    
    
    
}
- (void)timer4show{
    for (NSInteger i = self.count; i>=0; i--) {
        self.count = i;
        
        [self refreshUIMainThread];
        
        sleep(1);
    }
}

- (void)refreshUIMainThread{
    NSLog(@"%s--%@--%ld",__func__,[NSThread currentThread],(long)self.count);
}

- (void)show{
     NSLog(@"%s---%@",__func__,[NSThread currentThread]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // NSRunLoop 主线程对应的RunLoop 对象
    NSRunLoop *mainRunloop = [NSRunLoop mainRunLoop];
    
    NSLog(@"mainRunloop -- %@",mainRunloop);
    
    // NSRunLoop 获取当前方法所在线程对应的Runloop
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];

    NSLog(@"currentRunLoop -- %@",currentRunLoop);
    
    //CFRunLoopRef 主线程对应的Runloop 对象
    CFRunLoopRef cfMainRunloop = CFRunLoopGetMain();
    
    NSLog(@"cfMainRunloop -- %@",cfMainRunloop);
    
    //CFRunLoopRef 获取当前方法所在的线程对应的Runloop
    CFRunLoopRef cfCurrentRunLoop = CFRunLoopGetCurrent();
    
    NSLog(@"cfCurrentRunLoop -- %@",cfCurrentRunLoop);
    
    //开启一条子线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [thread start];
    
    /*
     创建一个子线程
     
     1 [self performSelectorInBackground:@selector(run) withObject:nil]; //不安全
     
     2 GCD 队列、任务。任务，即要做的事情。 同步异步。同步异步的区别主要区别于会不会阻塞当前线程，如果同步，sync会阻塞当前线程并等待block中人物完毕，然后当前线程才会继续往下执行。异步 async 当前线程会直接往下执行，不会阻塞当前线程。队列：存放任务。串行队列 FIFO 一个接一个执行 。并行队列：放到并行队列的任务，GCD也会FIFO取出来，不同的是，取出来一个就会放到别的线程，然后再取出来一个又放到另一个线程，这样由于取得动作很快，忽略不计，看起来，所有任务是一起执行的，不过，GCD 会根据系统资源控制并行的数量，所以如果任务很多，并不会让所有任务同时执行。
       主队列是一个特殊的串行队列。用于刷新UI。
     
     dispatch_queue_t queue = dispatch_get_main_queue(); //获取主队列
     
     dispatch_queue_t queue = dispatch_queue_create("tt", NULL);//默认串行队列
     dispatch_queue_t queue1 = dispatch_queue_create("ttt""", DISPATCH_QUEUE_SERIAL);
     
     dispatch_queue_t queue2 = dispatch_queue_create("tttt", DISPATCH_QUEUE_CONCURRENT);//并行队列
     
     dispatch_queue_t queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局队列
     
     dispatch_sync(queue, ^{
     
     });
     
     dispatch_async(queue, ^{
     
     });
     
     */
    
   

}

- (void)run{
    
    //注意，如果想要给子线程添加RunLoop，不能直接alloc init 只要调用 currentRunLoop 方法，系统就会自动创建一个RunLoop，添加到当前线程中
    [NSRunLoop currentRunLoop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
