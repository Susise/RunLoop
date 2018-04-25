//
//  TimerManager.h
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CountDownNotification;

#define KCountDownManager [TimerManager share]

@interface TimerManager : NSObject


+ (instancetype)share;

@property ( nonatomic,assign ) NSInteger timeInterval;//时间差


- (void)start;//开始

- (void)reload;//时间差置为0，重新获取新数据

- (void)invalidate;//停止，并移除倒计时

- (void)addSourceWithIndentifier:(NSString *)identifier;//添加倒计时源

- (void)reloadSourceWithIdentifier:(NSString *)identifier;//刷新某一个倒计时

- (void)reloadAllSource;//刷新所有倒计时

- (void)removeSourceWithIdentifier:(NSString *)identifier;//清除某一个倒计时

- (void)removeAllSource;//清除所有倒计时

- (NSInteger)timeIntervalWithIdentifier:(NSString *)identifier;//根据identifier 获取时间差

@end




@interface TimeInterval :NSObject

@property ( nonatomic,assign ) NSInteger timeInterval;

+(instancetype)timeInterval:(NSInteger)timeInterval;


@end
