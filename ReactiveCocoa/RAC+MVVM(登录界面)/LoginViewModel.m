//
//  LoginViewModel.m
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/7.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "LoginViewModel.h"
#import "MBProgressHUD+XMG.h"


@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    
    return self;
}

// 初始化操作
- (void)setup {
    // 1.处理登录点击的信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, psw)] reduce:^id(NSString *account,NSString *psw){
        
        
        return @(account.length > 0 && psw.length > 0);
    }];
    
    // 2.处理登录点击命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSLog(@"发送网络请求");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 发送数据
                [subscriber sendNext:@"网络请求数据"];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
        
    }];
    
    // 3.处理登录请求返回的结果
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.处理登录执行过程
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        if([x boolValue]){
            NSLog(@"正在执行");
            [MBProgressHUD showMessage:@"登录中..."];
        }else{
            [MBProgressHUD hideHUD];
            NSLog(@"执行完成");
        }
    }];


}

@end
