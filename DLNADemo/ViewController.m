//
//  ViewController.m
//  DLNADemo
//
//  Created by  bolizhou on 2018/2/26.
//  Copyright © 2018年 7hriller. All rights reserved.
//

#import "ViewController.h"
#import <DLNAKit.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UPnPSSDPDataDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger numberOfDevice;

@property (nonatomic, strong) NSMutableArray<Device *> *devices;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设备";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = refreshButtonItem;
    
    [self initTableView];
    [self initDLNAModule];
}

- (void)refreshButtonItemPressed:(UIBarButtonItem *)sender
{
    [self.devices removeAllObjects];
    [self.tableView reloadData];
    [self initDLNAModule];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_id"];
}

- (void)initDLNAModule
{
    UPnPManager *manager = [UPnPManager sharedManager];
    manager.ssdpDataDelegate = self;
    [manager searchDeviceWithDLNALocalServiceEnabled:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    
    if (self.devices.count > indexPath.row) {
        Device *device = [self.devices objectAtIndex:indexPath.row];
        cell.textLabel.text = device.ddd.friendlyName ? device.ddd.friendlyName : @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark <UPnP>

- (void)uPnpManagerDidSendData:(UPnPManager *)manager
{
    NSLog(@"uPnpManagerDidSendData");
}

- (void)uPnpManager:(UPnPManager *)manager didDiscoverDevice:(Device *)device
{
    NSLog(@"didDiscoverDevice: %@", device);
    if (device) {
        if (![self.devices containsObject:device]) {
            [self.devices addObject:device];
            manager.device = device;
            [manager fetchDDDSuccessHandler:^(DeviceDescription * _Nullable ddd) {
                device.ddd = ddd;
                dispatch_main_async_safe(^{
                    [self.tableView reloadData];
                });
            } failureHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
            }];
        }
    }
}

#pragma mark <Helper>

- (NSMutableArray<Device *> *)devices
{
    if (!_devices) {
        _devices = [[NSMutableArray alloc] init];
    }
    return _devices;
}

@end
