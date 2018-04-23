//
//  Address.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/7.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

#import "Device.h"

@implementation Address

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _ipv4 = [aDecoder decodeObjectForKey:@"dlna_device_address_ipv4"];
        _ipv6 = [aDecoder decodeObjectForKey:@"dlna_device_address_ipv6"];
        _port = [aDecoder decodeObjectForKey:@"dlna_device_address_port"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ipv4 ? _ipv4 : @"" forKey:@"dlna_device_address_ipv4"];
    [aCoder encodeObject:_ipv6 ? _ipv6 : @"" forKey:@"dlna_device_address_ipv6"];
    [aCoder encodeObject:_port ? _port : @"" forKey:@"dlna_device_address_port"];
}

- (id)copyWithZone:(NSZone *)zone
{
    Address *address = [[Address allocWithZone:zone] init];
    address.ipv4 = self.ipv4.copy;
    address.ipv6 = self.ipv6.copy;
    address.port = self.port.copy;
    return address;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{<Address>: ipv4: %@ port: %@, ipv6: %@}", self.ipv4, self.port, self.ipv6];
}

@end
