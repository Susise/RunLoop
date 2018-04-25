//
//  CommCell.m
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import "CommCell.h"
#import "TimerManager.h"

@interface CommCell ()

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

//NSString *const

@implementation CommCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:CountDownNotification object:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:CountDownNotification object:nil];
    }
    return self;
}
// 倒计时通知回调
- (void)countDownNotification{
    if (0) {//无需倒计时
        return;
    }
    
    Model *model = self.model;
    
    NSInteger timeInterval;
    
    if (model.countDownSource) {
        
        timeInterval  = [KCountDownManager  timeIntervalWithIdentifier:model.countDownSource];
    }else{
        
        timeInterval = KCountDownManager.timeInterval;
    }
    
    NSInteger countDown = model.count - timeInterval;
    
    if (countDown <=0) {
        
        !self.countDownZero ? nil : self.countDownZero(model);
        
        self.desLab.text = @"时间到";
        
        return;
        
    }else{
        self.desLab.text = [NSString stringWithFormat:@"倒计时%02zd:%02zd:%02zd",countDown/3600, (countDown/60)%60, countDown%60];
    }
    
}
- (void)setModel:(Model *)model{
    _model = model;
    
    self.textLabel.text = model.title;
    
    [self countDownNotification];
}

@end
