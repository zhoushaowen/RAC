//
//  ViewController.m
//  RACDisposable
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"


@interface ViewController ()

@property (nonatomic,strong) id<RACSubscriber> subscriber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        _subscriber = subscriber;
        //3.发送信号
        [subscriber sendNext:@2];
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 默认一个信号发送数据完毕之后,就会主动取消订阅.
    // 只要订阅者在,就不会自动取消信号订阅
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 取消订阅信号
    [disposable dispose];
    
}

@end
