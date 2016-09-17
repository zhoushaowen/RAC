//
//  ViewController.m
//  RACReplaySubject
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 RACReplaySubject与RACSubject区别:
 RACReplaySubject可以先发送信号，再订阅信号，RACSubject就不可以。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //发送信号
    // RACReplaySubject发送信号内部处理步骤:
    // 1.先保存值
    // 2.遍历所有的订阅者,调用订阅者的nextBlock
    [replaySubject sendNext:@4];
    
    
    //订阅信号
    //RACReplaySubject订阅信号内部处理步骤:
    //1.遍历保存的所有值
    //2.一个一个调用订阅者的nextBlock
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"订阅者统一收到数据:%@",x);
    }];
    
    
    
    
    
}



@end
