//
//  TimerManager.m
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import "TimerManager.h"
#import "Model.h"
#import <UIKit/UIKit.h>

NSString *const CountDownNotification = @"CountDownNotification";

@interface TimerManager ()

@property ( nonatomic,strong ) NSTimer *tiemr;

@property ( nonatomic,strong ) NSMutableDictionary<NSString *,TimeInterval * > *timeIntervalDict;//时间差字典，使用字典来存放，支持多列表 或者多页面使用。 单位：秒

@property ( nonatomic,assign ) BOOL backgroundRecord;

@property ( nonatomic,assign ) CFAbsoluteTime lasttime;//进入后台的绝对时间



@end

@implementation TimerManager

+ (instancetype)share{
    
    static TimerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[TimerManager alloc] init];
        
    });
    
    return manager;
}
- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //将要进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        //将要进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}
//启动定时器
- (void)start{
    
    [self tiemr];
}
//把时间差 置0
- (void)reload{
    self.timeInterval  = 0;
}
//销毁timer
- (void)invalidate{
    if (self.tiemr) {
        [self.tiemr invalidate];
        self.tiemr = nil;
    }
}

- (void)applicationDidEnterBackgroundNotification{
    self.backgroundRecord = (self.tiemr !=nil); //根据timer是否存在判断 是在前后台。 不存在的话，说明已经进入后台了。
    if (self.backgroundRecord) {
        
        self.lasttime = CFAbsoluteTimeGetCurrent();//方便的进行时间差计算
        
        [self invalidate];
    }
}
- (void)applicationWillEnterForegroundNotification{
    
    if (self.backgroundRecord) {
        
        CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lasttime;//单位是毫秒
        
        [self timerActionWithTimeInterval:(NSInteger)timeInterval];
        
        [self start];
    }
}
- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier{
    return [[self.timeIntervalDict allKeys] containsObject:identifier]?self.timeIntervalDict[identifier].timeInterval:0;
}
- (void)addSourceWithIndentifier:(NSString *)identifier{
    
    BOOL haveidentifier = [[self.timeIntervalDict allKeys] containsObject:identifier];
    
    if (haveidentifier) {
        self.timeIntervalDict[identifier].timeInterval = 0;
    }else{
        [self.timeIntervalDict setValue:[TimeInterval  timeInterval:0] forKey:identifier];
    }
}

- (void)reloadSourceWithIdentifier:(NSString *)identifier{
    [self addSourceWithIndentifier:identifier];//如果有，就刷新，没有就创建
}
- (void)reloadAllSource{
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}
- (void)removeSourceWithIdentifier:(NSString *)identifier{
    [self.timeIntervalDict removeObjectForKey:identifier];
}

- (void)removeAllSource{
    [self.timeIntervalDict removeAllObjects];
}
#pragma mark -- private
//定时器执行一次 加1
- (void)timerAction{
    
    [self timerActionWithTimeInterval:1];
}
- (void)timerActionWithTimeInterval:(NSInteger)timeInterval{
    
    self.timeInterval = self.timeInterval + timeInterval;
    
    [self.timeIntervalDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TimeInterval * _Nonnull obj, BOOL * _Nonnull stop) {
        
        obj.timeInterval = obj.timeInterval + timeInterval;
    }];
    
    //发出通知。
    [[NSNotificationCenter defaultCenter] postNotificationName:CountDownNotification object:nil userInfo:nil];
    
}

#pragma mark -- lazy loading

- (NSTimer *)tiemr{
    if (!_tiemr) {
        _tiemr = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_tiemr forMode:NSRunLoopCommonModes];
    }
    return _tiemr;
}
- (NSMutableDictionary<NSString *,TimeInterval *> *)timeIntervalDict{
    if (!_timeIntervalDict) {
        _timeIntervalDict = [NSMutableDictionary dictionary];
    }
    return _timeIntervalDict;
}
@end



@implementation TimeInterval

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    TimeInterval  *object = [TimeInterval new];
    object.timeInterval = timeInterval;
    return object;
}

@end
