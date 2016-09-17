//
//  RequestViewModel.h
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/8.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface RequestViewModel : NSObject

/** 请求命令 */
@property (nonatomic,strong,readonly) RACCommand *requestCommand;

@end
