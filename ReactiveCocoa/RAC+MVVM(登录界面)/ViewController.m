//
//  ViewController.m
//  RAC+MVVM(登录界面)
//
//  Created by 周少文 on 16/9/7.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pswField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) LoginViewModel *loginVM;


@end

@implementation ViewController

// MVVM:
// VM:视图模型,处理界面上所有业务逻辑

// 每一个控制器对应一个VM模型
// VM:最好不要包括视图V
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    [self loginEvent];
    
    // MVVM:1.先创建VM模型,把整个界面的一些业务逻辑处理完
    // 2.回到控制器去执行

}

// 绑定viewModel
- (void)bindViewModel
{
    RAC(self.loginVM, account) = _accountField.rac_textSignal;
    RAC(self.loginVM, psw) = _pswField.rac_textSignal;

}

// 登录事件
- (void)loginEvent {
    // 1.处理文本框业务逻辑
    // 设置按钮能否点击
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSignal;
    
    
    // 监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"登录按钮被点击了");
        
        [self.loginVM.loginCommand execute:nil];
        
    }];

}

- (LoginViewModel *)loginVM
{
    if(!_loginVM){
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
}


@end
