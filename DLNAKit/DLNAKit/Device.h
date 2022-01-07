//
//  Device.h
//  DLNAKit
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DLNAKit/Service.h>

@interface Address : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *ipv4;
@property (copy, nonatomic) NSString *ipv6;
@property (copy, nonatomic) NSString *port;

@end

@interface SsdpResponseHeader : NSObject

@property (copy, nonatomic) NSString *statusCode;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *maxAge;
@property (copy, nonatomic) NSString *server;
@property (copy, nonatomic) NSString *bootid_upnp_org;
@property (copy, nonatomic) NSString *configid_upnp_org;
@property (copy, nonatomic) NSString *usn;
@property (copy, nonatomic) NSString *st;
@property (copy, nonatomic) NSString *date;

@property (strong, nonatomic) Address *address;

- (instancetype)initWithReceivedMsg:(NSString *)message;

@end

@class Device;

@interface DeviceDescription : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *deviceType;
@property (copy, nonatomic) NSString *friendlyName;
@property (copy, nonatomic) NSString *manufacturer;
@property (copy, nonatomic) NSString *manufacturerURL;
@property (copy, nonatomic) NSString *modelDescription;
@property (copy, nonatomic) NSString *modelName;
@property (copy, nonatomic) NSString *udn;
@property (copy, nonatomic) NSArray<Service *> *services;
@property (copy, nonatomic) NSArray<Device *> *devices;
@property (weak, nonatomic) Device *device;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface Device : NSObject <NSCopying, NSCoding>

@property (strong, nonatomic) DeviceDescription *ddd;
@property (strong, nonatomic) Address *address;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *maxAge;
@property (copy, nonatomic) NSString *server;
@property (copy, nonatomic) NSString *bootid_upnp_org;
@property (copy, nonatomic) NSString *configid_upnp_org;
@property (copy, nonatomic) NSString *usn;
@property (copy, nonatomic) NSString *st;
@property (copy, nonatomic) NSString *date;
@property (assign, nonatomic) NSTimeInterval successTime;
@property (assign, nonatomic) BOOL isSuccessed;

- (instancetype)initWithSsdpResponse:(SsdpResponseHeader *)header;

- (BOOL)isIPv4Equal:(Device *)object;

- (BOOL)isUSNEqual:(Device *)object;

@end

