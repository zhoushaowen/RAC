//
//  Flag.h
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/4.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *icon;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
