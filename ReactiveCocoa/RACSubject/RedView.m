//
//  RedView.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "RedView.h"

@implementation RedView

//懒加载
- (RACSubject *)btnClickSignal
{
    if(!_btnClickSignal)
    {
        //创建信号
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}

- (IBAction)btnClick:(UIButton *)sender
{
    //发送信号
    [self.btnClickSignal sendNext:sender];
}

@end
