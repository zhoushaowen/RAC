//
//  RedView.h
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"


@interface RedView : UIView

//用于监听按钮点击的信号
@property (nonatomic,strong) RACSubject *btnClickSignal;

@end
