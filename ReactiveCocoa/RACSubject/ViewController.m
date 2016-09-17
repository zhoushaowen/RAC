//
//  ViewController.m
//  RACSubject
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RedView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet RedView *redView;

@end

@implementation ViewController

/*
 RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
 
 使用场景:通常用来代替代理，有了它，就不必要定义代理了。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    // 不同信号订阅的方式不一样
    // RACSubject处理订阅:仅仅是保存订阅者
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一收到数据:%@",x);
    }];
    
    // 保存订阅者
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二收到数据:%@",x);
    }];
    
    // 3.发送数据
    [subject sendNext:@3];
    
    // 底层实现:遍历所有的订阅者,调用nextBlock
    
    // 执行流程:
    
    // RACSubject被订阅,仅仅是保存订阅者
    // RACSubject发送数据,遍历所有的订阅,调用他们的nextBlock
    
    
    //RACSubject代替代理的例子:
    //监听红色view上按钮的点击
    //订阅信号
    [self.redView.btnClickSignal subscribeNext:^(UIButton *x) {
        NSLog(@"红色view按钮被点击了");
        x.selected = !x.selected;
    }];
}


@end
