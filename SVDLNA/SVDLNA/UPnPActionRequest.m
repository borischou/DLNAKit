//
//  UPnPActionRequest.m
//  SVDLNADemo
//
//  Created by  bolizhou on 17/2/8.
//  Copyright © 2017年  bolizhou. All rights reserved.
//

/***
 content-type必须为text/xml，应包括使用的字符编码，如utf-8
 
 ***/

#import "UPnPActionRequest.h"
#import "UPnPManager.h"

#define REQUEST_TIMEOUT 5

@interface UPnPActionRequest ()

@property (copy, nonatomic) NSString *actionName;
@property (copy, nonatomic) NSString *requestURL;
@property (strong, nonatomic) NSData *requestBody;
@property (strong, nonatomic) NSMutableArray<NSString *> *xmlLines;

@end

@implementation UPnPActionRequest

+ (instancetype)request
{
    return [[UPnPActionRequest alloc] init];
}

- (instancetype)initWithActionName:(NSString *)actionName
{
    self = [super init];
    if (self)
    {
        _actionName = actionName;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _service = [UPnPManager sharedManager].service;
        _device = [UPnPManager sharedManager].device;
        self.timeoutInterval = 5;
    }
    return self;
}

- (NSMutableArray<NSString *> *)xmlLines
{
    if (_xmlLines == nil)
    {
        _xmlLines = [NSMutableArray new];
    }
    return _xmlLines;
}

- (void)addParameterWithKey:(NSString * _Nonnull)key
{
    NSString *para = [NSString stringWithFormat:@"<%@>%@</%@>\n", key, @" ", key];
    [self.xmlLines addObject:para];
}

- (void)addParameterWithKey:(NSString * _Nonnull)key value:(NSString * _Nullable)value
{
    NSString *para = [NSString stringWithFormat:@"<%@>%@</%@>\n", key, value, key];
    [self.xmlLines addObject:para];
}

-(void)_addXmlSoapWrapper
{
    NSString *start = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:u=\"%@\">\n<s:Body>\n<u:%@ xmlns:u=\"%@\">\n", self.service.serviceType, self.actionName, self.service.serviceType];
    NSString *end = [NSString stringWithFormat:@"</u:%@>\n</s:Body>\n</s:Envelope>\r\n", self.actionName];
    [self.xmlLines insertObject:start atIndex:0];
    [self.xmlLines addObject:end];
}

- (NSString *)_soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", self.service.serviceType, self.actionName];
}

- (void)setActionName:(NSString *)actionName
{
    _actionName = actionName;
}

- (void)composeRequest
{
    if (self.xmlLines == nil || self.xmlLines.count <= 0)
    {
        return;
    }
    [self _addXmlSoapWrapper];
    
    NSString *url = nil;
    NSString *controlURL = self.service.controlURL;
    
    if ([self.service.controlURL hasPrefix:@"/"])
    {
        url = [NSString stringWithFormat:@"http://%@:%@%@", self.device.address.ipv4, self.device.address.port, controlURL];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://%@:%@/%@", self.device.address.ipv4, self.device.address.port, controlURL];
    }
    _requestURL = url;
    [self setURL:[NSURL URLWithString:url]];
    self.HTTPMethod = @"POST";
    self.timeoutInterval = REQUEST_TIMEOUT;
    [self addValue:[self _soapAction] forHTTPHeaderField:@"SOAPAction"];
    [self addValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *mutStr = [NSMutableString new];
    for (NSString *line in self.xmlLines)
    {
        [mutStr appendString:line];
    }
    NSData *data = [mutStr dataUsingEncoding:NSUTF8StringEncoding];
    self.HTTPBody = data;
    _requestBody = data;
}

@end
