//
//  ViewController.m
//  RACMulticastConnection
//
//  Created by 周少文 on 16/9/6.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
     
     使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
     
     */
    
    // 每次订阅不要都请求一次,指向请求一次,每次订阅只要拿到数据
    
    // 不管订阅多少次信号,就会请求一次
    // RACMulticastConnection:必须要有信号
    
    // 1.创建信号
    // 2.把信号转换成连接类
    // 3.订阅连接类的信号
    // 4.连接
    
    
    
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //subscriber,其实就是RACSubject
        // didSubscribe什么时候调用:连接类连接的时候
        NSLog(@"发送网络请求");
        [subscriber sendNext:@"网络请求成功之后返回的数据"];
        
        return nil;
    }];
    
    
    // 2.把信号转换成连接类
    //内部会创建一个RACSubject对象,并且创建一个signal指针保存RACSubject,另外还会创建一个signal指针保存上面的RACDynamicSignal对象.
    RACMulticastConnection *connection = [signal publish];
    
    
    // 3.订阅连接类信号
    //订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    [connection.signal subscribeNext:^(id x) {
       
        NSLog(@"订阅者1:%@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者2:%@",x);
    }];
    
    
    // 4.连接
    //内部会订阅RACDynamicSignal(原始信号)，并且订阅者是RACSubject
    [connection connect];
    
    
    [self connection2];
}

- (void)connection2
{
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发起另一个网络请求");
        [subscriber sendNext:@"另一个网络请求得到的数据"];
        return nil;
    }];
    
    //2.把信号转换成连接的另一种方式
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    
    //因为这里的的信号是RACReplaySubject,所以可以先连接后订阅
    //内部会订阅RACDynamicSignal(原始信号)，并且订阅者是RACReplaySubject
    //一连接也是会调用RACDynamicSignal的didSubscribe
    [connection connect];
    
    //3.订阅连接类信号
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者1:%@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者2:%@",x);
    }];
    
    
}

















@end
