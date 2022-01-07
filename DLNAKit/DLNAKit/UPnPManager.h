//
//  UPnPManager.h
//  DLNAKit
//
//  Created by  bolizhou on 17/2/8.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DLNAKit/Service.h>
#import <DLNAKit/Device.h>

static NSString *const _Nonnull UPnPVideoStateChangedNotification;   //视频播放状态改变通知

typedef NS_ENUM (NSInteger, DLNAActionError)
{
    DLNAActionErrorEmptyTransportURI,
    DLNAActionErrorEmptyActionResponse,
    DLNAActionErrorServerError
};

/**
 upnp动作请求响应类
 */
@interface UPnPActionResponse : NSObject

@property (assign, nonatomic) NSInteger statusCode;
@property (copy, nonatomic) NSString * _Nullable respMsg;
@property (copy, nonatomic) NSString * _Nullable errorCode;
@property (copy, nonatomic) NSString * _Nullable errorDescription;
@property (copy, nonatomic) NSArray<Action *> * _Nullable actions;
@property (copy, nonatomic) NSDictionary * _Nullable xmlDictionary;

- (instancetype _Nonnull)initWithData:(NSData * _Nullable)data;

@end

@class UPnPManager;

/**
 SSDP搜索设备请求响应代理
 */
@protocol UPnPSSDPDataDelegate <NSObject>

@optional

- (void)uPnpManagerDidSendData:(UPnPManager * _Nonnull)manager;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didNotSendDataDueToError:(NSError * _Nullable)error;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didDiscoverDevice:(Device * _Nullable)device;

@end

/**
 upnp控制请求响应代理
 */
@protocol UPnPControlPointDelegate <NSObject>

@optional

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didGetTransportInfoResponse:(GetTransportInfoResponse * _Nullable)response error:(NSError * _Nullable)error;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didGetPositionInfoResponse:(GetPositionInfoResponse * _Nullable)response errror:(NSError * _Nullable)error;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didPlayResponse:(UPnPActionResponse * _Nullable)response error:(NSError * _Nullable)error;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didPauseResponse:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didStopResponse:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didSeekTo:(NSString * _Nonnull)target response:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didSetAVTransportURI:(NSString * _Nullable)uri response:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didSetNextAVTransportURI:(NSString * _Nullable)uri response:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didGetCurrentTransportActionsResponse:(UPnPActionResponse * _Nullable)response;

- (void)uPnpManager:(UPnPManager * _Nonnull)manager didSetVolume:(NSString * _Nonnull)volume response:(UPnPActionResponse * _Nullable)response;

@end

/**
 DLNA主管理类，负责搜索、订阅、控制的请求调用
 */
@interface UPnPManager : NSObject

/**
 当前设备
 */
@property (strong, nonatomic, readonly) Device * _Nullable device;

/**
 当前服务
 */
@property (strong, nonatomic, readonly) Service * _Nullable service;

/**
 全局共享管理类
 
 @return 管理类单例
 */
+ (_Nullable instancetype)sharedManager;

/**
 设置当前服务
 
 @param service 当前服务实例
 */
- (void)setService:(Service * _Nullable)service;

/**
 设置当前连接的设备
 
 @param device 当前设备实例
 */
- (void)setDevice:(Device * _Nullable)device;

/**
 默认开启本地DLNA服务器并搜索设备
 */
- (void)searchDevice;

/**
 搜索设备

 @param enable 是否开启本地DLNA服务器
 */
- (void)searchDeviceWithDLNALocalServiceEnabled:(BOOL)enable;

/**
 关闭搜索
 */
- (void)searchClose;

/**
 订阅AVTransport服务的状态响应通知
 */
- (void)subscribeEventNotificationForAVTransport;

/**
 订阅AVTransport服务的状态响应通知
 
 @param responseBlock 回调闭包，可保存订阅ID用于请求续订
 */
- (void)subscribeEventNotificationForAVTransportResponse:(void (^ _Nullable)(NSString * _Nullable subscribeID, NSURLResponse * _Nullable response, NSError * _Nullable error))responseBlock;

/**
 订阅指定服务的状态响应通知
 
 @param service 指定的服务实例
 @param responseBlock 回调闭包
 */
- (void)subscribeEventNotificationForService:(Service * _Nonnull)service response:(void (^ _Nullable)(NSString * _Nullable subscribeID, NSURLResponse * _Nullable response, NSError * _Nullable error))responseBlock;

/**
 转换视频播放状态枚举工具方法

 @param origin 原始状态字符串
 @return 自定义状态枚举
 */
- (UPnPAVTransportState)transportStateWith:(NSString * _Nullable)origin;

/**
 取消当前的请求
 */
- (void)cancelCurrentRequest;

@property (weak, nonatomic) id <UPnPControlPointDelegate> _Nullable controlPointDelegate;

@property (weak, nonatomic) id <UPnPSSDPDataDelegate> _Nullable ssdpDataDelegate;

@end

typedef void(^successHandler)(NSData * _Nullable data);
typedef void(^failureHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

typedef void(^DDDHandler)(DeviceDescription * _Nullable ddd);
typedef void(^SDDHandler)(ServiceDescription * _Nullable sdd);

@interface UPnPManager (Connection)

/**
 请求当前默认设备的设备描述文档
 */
- (void)fetchDDDSuccessHandler:(DDDHandler _Nullable)dddBlk failureHandler:(failureHandler _Nullable)failBlk;

/**
 根据指定设备请求设备描述文档
 
 @param device 指定的设备
 */
- (void)fetchDDDWithDevice:(Device * _Nonnull)device successHandler:(DDDHandler _Nullable)dddBlk failureHandler:(failureHandler _Nullable)failBlk;

/**
 请求服务描述文档
 */
- (void)fetchSDDSuccessHandler:(SDDHandler _Nullable)sddBlk failureHandler:(failureHandler _Nullable)failBlk;

@end

typedef void (^ActionResponseHandler)(UPnPActionResponse * _Nullable actionResponse, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface UPnPManager (ControlPoint)

#pragma mark - AVTransport


/**
 设置当前播放的网络视频URI

 @param uri  视频地址
 @param title 视频标题
 @param responseHandler
 */
- (void)setAVTransportURI:(NSString * _Nonnull)uri andTitle:(NSString *_Nonnull)title response:(ActionResponseHandler _Nonnull)responseHandler;

/**
 设置下一个联播视频URI
 
 @param uri 下一个视频地址
 @param responseHandler
 */
- (void)setNextAVTransportURI:(NSString * _Nonnull)uri response:(ActionResponseHandler _Nullable)responseHandler;

/**
 请求播放视频
 */
- (void)playWithResponse:(ActionResponseHandler _Nullable)responseHandler;

/**
 请求暂停视频
 */
- (void)pauseWithResponse:(ActionResponseHandler _Nullable)responseHandler;

/**
 请求停止视频
 */
- (void)stopWithResponse:(ActionResponseHandler _Nullable)responseHandler;

/**
 请求视频播放状态
 */
typedef void (^GetTransportInfoResponseHandler)(GetTransportInfoResponse * _Nullable getTransportInfoResponse, NSURLResponse * _Nullable response, NSError * _Nullable error);

- (void)getTransportInfo:(GetTransportInfoResponseHandler _Nullable)responseHandler;

/**
 请求视频播放时间戳
 */
typedef void (^GetPositionInfoResponseHandler)(GetPositionInfoResponse * _Nullable getPositionInfoResponse, NSURLResponse * _Nullable response, NSError * _Nullable error);

- (void)getPositionInfo:(GetPositionInfoResponseHandler _Nullable)responseHandler;

/**
 请求从指定时间点播放视频
 
 @param target 播放开始时间点，如"00:12:15"
 */
- (void)seekTo:(NSString * _Nonnull)target response:(ActionResponseHandler _Nullable)responseHandler;

/**
 请求当前服务可调用的动作
 */
- (void)getCurrentTransportActions:(ActionResponseHandler _Nullable)responseHandler;

#pragma mark - RenderingControl

/**
 请求设置当前音量（绝对值）
 
 @param volume 当前音量
 */
- (void)setVolume:(NSString * _Nonnull)volume response:(ActionResponseHandler _Nullable)responseHandler;

@end
