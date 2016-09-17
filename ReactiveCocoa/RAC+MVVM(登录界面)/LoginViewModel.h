//
//  LoginViewModel.h
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/7.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface LoginViewModel : NSObject

// 保存登录界面的账号和密码
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *psw;

// 处理登录按钮是否允许点击
@property (nonatomic,strong,readonly) RACSignal *loginEnableSignal;

/** 登录按钮命令 */
@property (nonatomic,strong,readonly) RACCommand *loginCommand;

@end
