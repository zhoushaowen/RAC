//
//  ViewController.m
//  RAC操作方法之映射(flattenMap,Map)
//
//  Created by 周少文 on 16/9/6.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RACReturnSignal.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 FlatternMap和Map的区别
 
 1.FlatternMap中的Block返回信号。
 2.Map中的Block返回对象。
 3.开发中，如果信号发出的值不是信号，映射一般使用Map
 4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self flattenMap];
//    [self map];
    
    // flattenMap:用于信号中的信号
    
    //创建信号源
    RACSubject *signalOfSignals = [RACSubject subject];
    
    //创建信号
    RACSubject *signal = [RACSubject subject];
    
    //订阅信号
//    [signalOfSignals subscribeNext:^(RACSubject *x) {
//        
//        [x subscribeNext:^(id x) {
//            NSLog(@"%@",x);
//        }];
//    }];
    
//    RACSignal *bindSignal = [signalOfSignals flattenMap:^RACStream *(id value) {
//        return value;
//    }];
//    
//    [bindSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    [[signalOfSignals flattenMap:^RACStream *(id value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [signalOfSignals sendNext:signal];
    [signal sendNext:@"11111"];
    
}

- (void)map{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *signal =  [subject map:^id(id value) {
        
        // 返回的类型,就是你需要映射的值
        return [NSString stringWithFormat:@"xixi:%@",value];
    }];
    
    // 订阅绑定信号
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"456"];
    [subject sendNext:@"789"];
}

- (void)flattenMap
{
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal *bindSignal = [subject flattenMap:^RACStream *(id value) {
        
        // block:只要源信号发送内容就会调用
        // value:就是源信号发送内容
        
        value = [@"haha" stringByAppendingString:value];
        
        // 返回信号用来包装成修改内容值
        return [RACReturnSignal return:value];
    }];
    
    // flattenMap返回的是什么信号,订阅的就是什么信号
    
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    // 发送数据
    [subject sendNext:@"123"];

}


@end
