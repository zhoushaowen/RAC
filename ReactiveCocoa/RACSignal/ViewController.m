//
//  ViewController.m
//  RACSignal
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // RACSignal:有数据产生的时候,就使用RACSignal
    
    // RACSignal使用步骤: 1.创建信号  2.订阅信号 3.发送信号
    
    
    //1.创建信号(冷信号)
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribe调用:只要一个信号被订阅就会调用
        // didSubscribe作用:发送数据
        NSLog(@"信号被订阅了");
        
        //3.发送信号
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    //2.订阅信号(热信号)
    [signal subscribeNext:^(id x) {
        // nextBlock调用:只要订阅者发送数据就会调用
        // nextBlock作用:处理数据,展示到UI上面
        
        // x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 只要订阅者调用sendNext,就会执行nextBlock
    // 只要订阅RACDynamicSignal,就会执行didSubscribe
    // 前提条件是RACDynamicSignal,不同类型信号的订阅,处理订阅的事情不一样
}

@end
