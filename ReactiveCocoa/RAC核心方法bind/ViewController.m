//
//  ViewController.m
//  RAC核心方法bind
//
//  Created by 周少文 on 16/9/6.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import <ReactiveCocoa/RACReturnSignal.h>


@interface ViewController ()

@end

@implementation ViewController

/*
 ReactiveCocoa操作的核心方法是bind（绑定）,给RAC中的信号进行绑定，只要信号一发送数据，就能监听到，从而把发送数据改成自己想要的数据。
 
 在开发中很少使用bind方法，bind属于RAC中的底层方法，RAC已经封装了很多好用的其他方法，底层都是调用bind，用法比bind简单.
 */

/*
 // 底层实现:
 // 1.源信号调用bind,会重新创建一个绑定信号。
 // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
 // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
 // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
 // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
 
 // 注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
 // 这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建信号(源信号)
    RACSubject *subject = [RACSubject subject];
    
    //2.绑定信号(内部会创建一个RACDynamicSignal)
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        // block调用时刻:只要绑定信号被订阅就会调用
        
        return ^RACStream *(id value, BOOL *stop){
            
            // block调用:只要源信号发送数据,就会调用block
            // block作用:处理源信号内容
            // value:源信号发送的内容
            NSLog(@"接收到原信号的内容:%@",value);
            
            value = [@"haha" stringByAppendingString:value];
            
            // 返回信号,不能传nil,返回空信号[RACSignal empty]
            return [RACReturnSignal return:value];
        };
        
    }];
    
    //3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        // block:当处理完信号发送数据的时候,就会调用这个Block
        NSLog(@"接收到绑定信号处理完的信号:%@",x);
    }];
    
    //4.发送数据
    [subject sendNext:@"123"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
