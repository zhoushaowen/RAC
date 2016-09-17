//
//  ViewController.m
//  RACCommand
//
//  Created by 周少文 on 16/9/6.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
 
 使用场景:监听按钮点击，网络请求
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self command1];
//    [self command2];
//    [self command3];
//    [self switchToLastest];
    [self executing];
    
}

- (void)executing
{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令传入的参数:%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据4"];
            
            // 当前命令内部发送数据完成,一定要主动发送完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    //2. 监听事件有没有完成
//    [command.executing subscribeNext:^(NSNumber *x) {
//        NSLog(@"%@",x);
//        if([x boolValue]){// 当前正在执行
//            NSLog(@"当前正在执行");
//        }else{//没有执行完,或者还没有开始执行
//            NSLog(@"没有执行完,或者还没有开始执行");
//        }
//        
//    }];
    
    //监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
       
        if([x boolValue]){
            NSLog(@"当前正在执行");
        }else{
            NSLog(@"执行完毕");
        }
        
    }];
    
    // 3.执行命令
    [command execute:@"111"];
}

- (void)switchToLastest
{
    //创建信号中的信号
    RACSubject *signalOfSignals = [RACSubject subject];
    //创建信号
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    //订阅信号
//    [signalOfSignals subscribeNext:^(RACSubject *x) {
//        [x subscribeNext:^(id x) {
//            NSLog(@"%@",x);
//        }];
//    }];
    
    // switchToLatest:获取信号中信号发送的最新信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [signalOfSignals sendNext:signalA];
    [signalA sendNext:@"aaa"];
    [signalB sendNext:@"bbb"];
    
}

- (void)command3
{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令传入的参数:%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据3"];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // RAC高级用法
    // switchToLatest获取最新发送的信号,只能用于信号中信号
    // 注意:必须要在执行命令前,订阅
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"RACCommand中的信号传来的数据:%@",x);
    }];
    
    [command execute:@"789"];
}

- (void)command2
{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"执行命令传入的参数:%@",input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据2"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //2.订阅信号
    // 注意:必须要在执行命令前,订阅
    // executionSignals:信号源,信号中信号,signalOfSignals.信号:发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal *x) {
        
        //订阅信号源传来的信号
        [x subscribeNext:^(id x) {
            NSLog(@"RACCommand中的信号传来的数据:%@",x);
        }];
    }];
    
    
    // 3.执行命令
    [command execute:@"456"];

}

- (void)command1 {
    //1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        // input:执行命令传入参数
        // Block调用:执行命令的时候就会调用
        NSLog(@"执行命令传入的参数:%@",input);
        
        
        // RACCommand:必须返回信号,空信号也是可以的
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //发送数据
            [subscriber sendNext:@"请求数据1"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        //创建空信号
//        return [RACSignal empty];
    }];
    
    // 如何拿到执行命令中产生的数据
    // 订阅命令内部的信号
    // 1.方式一:直接订阅执行命令返回的信号
    // 2.方式二:
    
    // 2.执行命令
    RACSignal *signal = [command execute:@123];
    
    
    // 3.订阅信号
    [signal subscribeNext:^(id x) {
        //RACCommand中的信号传来的数据
        NSLog(@"RACCommand中的信号传来的数据:%@",x);
    }];

}



@end
