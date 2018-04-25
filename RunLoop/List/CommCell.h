//
//  CommCell.h
//  RunLoop
//
//  Created by S on 2018/3/9.
//  Copyright © 2018年 S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


@interface CommCell : UITableViewCell

@property ( nonatomic,strong ) Model *model;

@property ( nonatomic,copy ) void (^countDownZero) (Model *);


@end
