//
//  UPnPActionRequest.h
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/8.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "Service.h"

@interface UPnPActionRequest : NSMutableURLRequest

@property (strong, nonatomic) Service *service;

@property (strong, nonatomic) Device *device;

+ (instancetype)request;

- (instancetype)initWithActionName:(NSString *)actionName;

/*
 * 请求调用的动作名称（注意大小写一致）
 */
- (void)setActionName:(NSString *)actionName;

/*
 * 添加动作参数的键名
 */
- (void)addParameterWithKey:(NSString * _Nonnull)key;

/*
 * 添加动作参数的键值对
 */
- (void)addParameterWithKey:(NSString * _Nonnull)key value:(NSString * _Nullable)value;

/*
 * 只能在参数添加完毕后调用
 */
- (void)composeRequest;

@end
