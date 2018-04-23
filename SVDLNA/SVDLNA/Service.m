//
//  Service.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Service.h"
#import "XMLDictionary.h"

@implementation Service

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary == nil)
        {
            return nil;
        }
        _serviceID = [dictionary stringValueForKeyPath:@"serviceId"];
        _serviceType = [dictionary stringValueForKeyPath:@"serviceType"];
        _SCPDURL = [dictionary stringValueForKeyPath:@"SCPDURL"];
        _controlURL = [dictionary stringValueForKeyPath:@"controlURL"];
        _eventSubURL = [dictionary stringValueForKeyPath:@"eventSubURL"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _serviceID = [aDecoder decodeObjectForKey:@"dlna_service_serviceId"];
        _serviceType = [aDecoder decodeObjectForKey:@"dlna_service_serviceType"];
        _SCPDURL = [aDecoder decodeObjectForKey:@"dlna_service_SCPDURL"];
        _controlURL = [aDecoder decodeObjectForKey:@"dlna_service_controlURL"];
        _eventSubURL = [aDecoder decodeObjectForKey:@"dlna_service_eventSubURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.serviceID ? self.serviceID : @"" forKey:@"dlna_service_serviceId"];
    [aCoder encodeObject:self.serviceType ? self.serviceType : @"" forKey:@"dlna_service_serviceType"];
    [aCoder encodeObject:self.SCPDURL ? self.SCPDURL : @"" forKey:@"dlna_service_SCPDURL"];
    [aCoder encodeObject:self.controlURL ? self.controlURL : @"" forKey:@"dlna_service_controlURL"];
    [aCoder encodeObject:self.eventSubURL ? self.eventSubURL : @"" forKey:@"dlna_service_eventSubURL"];
}

- (id)copyWithZone:(NSZone *)zone
{
    Service *service = [[Service allocWithZone:zone] init];
    service.serviceID = self.serviceID.copy;
    service.serviceType = service.serviceType.copy;
    service.SCPDURL = service.SCPDURL.copy;
    service.controlURL = service.controlURL.copy;
    service.eventSubURL = service.eventSubURL.copy;
    return service;
}

@end
