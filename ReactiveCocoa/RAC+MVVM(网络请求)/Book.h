//
//  Book.h
//  ReactiveCocoa
//
//  Created by 周少文 on 16/9/8.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithDictionaray:(NSDictionary *)dic;


@end
