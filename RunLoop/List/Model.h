//
//  Model.h
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property ( nonatomic,assign ) NSInteger count;//剩余时间数

@property ( nonatomic,copy   ) NSString *title;

@property ( nonatomic,assign ) BOOL timeout;//表示时间已经到了

@property ( nonatomic,copy   )  NSString *countDownSource;//倒计时源


@end
