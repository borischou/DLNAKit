//
//  DeviceDescription.m
//  DLNAKit
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Device.h"
#import "XMLDictionary.h"

@implementation DeviceDescription

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary == nil)
        {
            return nil;
        }
        
        NSDictionary *aDict = [dictionary dictionaryValueForKeyPath:@"device"];
        if (aDict == nil)
        {
            return nil;
        }
        
        _udn = [aDict stringValueForKeyPath:@"UDN"];
        _deviceType = [aDict stringValueForKeyPath:@"deviceType"];
        _friendlyName = [aDict stringValueForKeyPath:@"friendlyName"];
        _manufacturer = [aDict stringValueForKeyPath:@"manufacturer"];
        _manufacturerURL = [aDict stringValueForKeyPath:@"manufacturerURL"];
        _modelName = [aDict stringValueForKeyPath:@"modelName"];
        _modelDescription = [aDict stringValueForKeyPath:@"modelDescription"];
        
        NSMutableArray *services = [NSMutableArray new];
        NSArray *serviceList = [aDict arrayValueForKeyPath:@"serviceList.service"];
        if (serviceList != nil && serviceList.count > 0)
        {
            for (NSDictionary *service in serviceList)
            {
                Service *serv = [[Service alloc] initWithDictionary:service];
                [services addObject:serv];
            }
        }
        _services = services.copy;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _udn = [aDecoder decodeObjectForKey:@"dlna_device_description_UDN"];
        _deviceType = [aDecoder decodeObjectForKey:@"dlna_device_description_deviceType"];
        _friendlyName = [aDecoder decodeObjectForKey:@"dlna_device_description_friendlyName"];
        _manufacturer = [aDecoder decodeObjectForKey:@"dlna_device_description_manufacturer"];
        _manufacturerURL = [aDecoder decodeObjectForKey:@"dlna_device_description_manufacturerURL"];
        _modelName = [aDecoder decodeObjectForKey:@"dlna_device_description_modelName"];
        _modelDescription = [aDecoder decodeObjectForKey:@"dlna_device_description_modelDescription"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.udn ? self.udn : @"" forKey:@"dlna_device_description_UDN"];
    [aCoder encodeObject:self.deviceType ? self.deviceType : @"" forKey:@"dlna_device_description_deviceType"];
    [aCoder encodeObject:self.friendlyName ? self.friendlyName : @"" forKey:@"dlna_device_description_friendlyName"];
    [aCoder encodeObject:self.manufacturer ? self.manufacturer : @"" forKey:@"dlna_device_description_manufacturer"];
    [aCoder encodeObject:self.manufacturerURL ? self.manufacturerURL : @"" forKey:@"dlna_device_description_manufacturerURL"];
    [aCoder encodeObject:self.modelName ? self.modelName : @"" forKey:@"dlna_device_description_modelName"];
    [aCoder encodeObject:self.modelDescription ? self.modelDescription : @"" forKey:@"dlna_device_description_modelDescription"];
}

- (id)copyWithZone:(NSZone *)zone
{
    DeviceDescription *deviceDscrp = [[DeviceDescription allocWithZone:zone] init];
    deviceDscrp.udn = self.udn.copy;
    deviceDscrp.deviceType = self.deviceType.copy;
    deviceDscrp.friendlyName = self.friendlyName.copy;
    deviceDscrp.manufacturer = self.manufacturer.copy;
    deviceDscrp.manufacturerURL = self.manufacturerURL.copy;
    deviceDscrp.modelDescription = self.modelDescription.copy;
    deviceDscrp.modelName = self.modelName.copy;
    return deviceDscrp;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{<DDD>: udn: %@, deviceType: %@, friendlyName: %@, manufacturer: %@, manufacturerURL: %@, modelDescription: %@, modelName: %@}", self.udn, self.deviceType, self.friendlyName, self.manufacturer, self.manufacturerURL, self.modelDescription, self.modelName];
}

@end
