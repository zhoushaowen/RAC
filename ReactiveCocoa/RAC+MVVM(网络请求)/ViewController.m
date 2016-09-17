//
//  ViewController.m
//  RAC+MVVM(网络请求)
//
//  Created by 周少文 on 16/9/8.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "RequestViewModel.h"

@interface ViewController ()

@property (nonatomic,strong) RequestViewModel *requestVM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.requestVM.requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    // 发送请求
    RACSignal *signal = [self.requestVM.requestCommand execute:nil];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
}

- (RequestViewModel *)requestVM
{
    if(!_requestVM){
        _requestVM = [[RequestViewModel alloc] init];
    }
    
    return _requestVM;
}


@end
