# CLAUDE.md — DLNAKit

AI assistant guidance for the DLNAKit repository.

## Project Overview

DLNAKit is a pure Objective-C iOS framework implementing the DLNA/UPnP protocol stack for local-network media casting. It enables iOS apps to discover DLNA-compatible renderers (smart TVs, media players) on the LAN and control video playback over HTTP/SOAP.

**Key capabilities:** device discovery (SSDP), media URI delivery (AVTransport), playback control (play/pause/stop/seek), event subscriptions (GCDWebServer), and volume control (RenderingControl).

**Language:** Objective-C only. No Swift. No CocoaPods. All third-party code is embedded directly.

## Repository Structure

```
DLNAKit/
├── DLNAKit/DLNAKit/          # Framework source
│   ├── DLNAKit.h             # Public umbrella header (exports UPnPManager, Device, Service)
│   ├── UPnPManager.h/m       # Main singleton controller (~764 lines)
│   ├── Device.h/m            # Device, DeviceDescription, Address, SsdpResponseHeader models
│   ├── Service.h/m           # Service, ServiceDescription, Action, Argument, StateVariable models
│   ├── UPnPActionRequest.h/m # Constructs UPnP SOAP XML requests
│   ├── UPnPActionResponse.m  # Parses SOAP response XML
│   ├── GetTransportInfoResponse.m
│   ├── GetPositionInfoResponse.m
│   ├── NSString+Ext.h/m      # String utilities
│   ├── XMLDictionary.h/m     # XML-to-NSDictionary parser (v1.4.1, public domain)
│   ├── GCDAsyncUdpSocket.h/m # UDP socket for SSDP multicast (CocoaAsyncSocket)
│   └── GCDWebServer/         # Embedded HTTP server for receiving UPnP NOTIFY events
│       ├── Core/
│       ├── Requests/
│       └── Responses/
├── DLNAKit/DLNAKit.xcodeproj/
├── DLNADemo/                 # Demo iOS app (single-screen device discovery)
│   ├── ViewController.m      # Shows discovered devices in a UITableView
│   ├── AppDelegate.m
│   └── main.m
└── README.md                 # Chinese-language overview
```

## Architecture

### Protocol Flow

1. **Discovery** — `UPnPManager` sends an SSDP M-SEARCH packet via UDP multicast to `239.255.255.250:1900`. `GCDAsyncUdpSocket` handles the async I/O.
2. **Device description** — Response headers are parsed into `SsdpResponseHeader`, then `Device`. `fetchDDD...` fetches the device description XML, parsed by `XMLDictionary` into a `DeviceDescription` with its `Service` list.
3. **Service description** — `fetchSDD...` fetches a service's SCPD XML into `ServiceDescription` with `Action`/`Argument` lists.
4. **Control** — `UPnPManager (ControlPoint)` sends SOAP `POST` requests (via `UPnPActionRequest`) to the service's `controlURL`.
5. **Events** — `GCDWebServer` listens on port **10190** for UPnP `NOTIFY` HTTP requests. Subscribe using `subscribeEventNotificationForAVTransport`.
6. **State changes** — Broadcast via `NSNotificationCenter` using `UPnPVideoStateChangedNotification`.

### Key Classes

| Class | Role |
|---|---|
| `UPnPManager` | Singleton. Owns discovery, control, and subscription logic. |
| `Device` | A discovered UPnP renderer. Holds `Address`, `DeviceDescription`, and USN/location metadata. |
| `Service` | A UPnP service within a device (e.g. AVTransport, RenderingControl). |
| `UPnPActionRequest` | Builds SOAP XML action envelopes. |
| `UPnPActionResponse` | Parses SOAP responses; exposes `statusCode`, `errorCode`, `xmlDictionary`. |
| `GetTransportInfoResponse` | Typed wrapper for `GetTransportInfo` responses (`currentTransportState`, `currentSpeed`). |
| `GetPositionInfoResponse` | Typed wrapper for `GetPositionInfo` responses (`relTime`, `trackDuration`, etc.). |
| `XMLDictionary` | Converts XML data/strings to `NSDictionary`. Used for all device/service description parsing. |
| `SsdpResponseHeader` | Parses raw SSDP response strings into typed properties. |

### Delegates

```objc
// Device discovery callbacks
@protocol UPnPSSDPDataDelegate
- uPnpManagerDidSendData:
- uPnpManager:didNotSendDataDueToError:
- uPnpManager:didDiscoverDevice:
@end

// Playback control callbacks
@protocol UPnPControlPointDelegate
- uPnpManager:didGetTransportInfoResponse:error:
- uPnpManager:didGetPositionInfoResponse:errror:   // Note: typo in selector ("errror")
- uPnpManager:didPlayResponse:error:
- uPnpManager:didPauseResponse:
- uPnpManager:didStopResponse:
- uPnpManager:didSeekTo:response:
- uPnpManager:didSetAVTransportURI:response:
- uPnpManager:didSetNextAVTransportURI:response:
- uPnpManager:didGetCurrentTransportActionsResponse:
- uPnpManager:didSetVolume:response:
@end
```

### Block Typedefs

```objc
typedef void(^successHandler)(NSData *data);
typedef void(^failureHandler)(NSData *data, NSURLResponse *response, NSError *error);
typedef void(^DDDHandler)(DeviceDescription *ddd);
typedef void(^SDDHandler)(ServiceDescription *sdd);
typedef void(^ActionResponseHandler)(UPnPActionResponse *actionResponse, NSURLResponse *response, NSError *error);
typedef void(^GetTransportInfoResponseHandler)(GetTransportInfoResponse *response, NSURLResponse *urlResponse, NSError *error);
typedef void(^GetPositionInfoResponseHandler)(GetPositionInfoResponse *response, NSURLResponse *urlResponse, NSError *error);
```

## Code Conventions

### Objective-C Style
- **Classes:** `UpperCamelCase` — `UPnPManager`, `DeviceDescription`, `SsdpResponseHeader`
- **Methods/properties:** `lowerCamelCase` — `searchDevice`, `controlURL`, `friendlyName`
- **Constants/enums:** `NS_ENUM` macros with `UPnP` or `DLNA` prefix
- **Categories:** named with `+Category` suffix on the class — `UPnPManager (Connection)`, `UPnPManager (ControlPoint)`
- **Extensions:** utility categories use `+Ext` suffix — `NSString+Ext`
- **Delegates:** `weak` properties — `@property (weak, nonatomic) id<UPnPSSDPDataDelegate> ssdpDataDelegate`
- **Memory:** ARC throughout; `strong` for owned objects, `copy` for value types (NSString, NSArray)
- **Nullability:** `_Nullable`/`_Nonnull` annotations used consistently in public headers

### Known Quirks
- `didGetPositionInfoResponse:errror:` has a triple-`r` typo in the selector name. Do not "fix" this without auditing all call sites — it will break binary compatibility.
- `UPnPVideoStateChangedNotification` is declared as `static NSString *const` in `UPnPManager.h`; it is defined in `UPnPManager.m`.
- The demo app sets `manager.device = device` directly (bypasses the setter) after checking containment. This is intentional to avoid triggering subscription logic prematurely.
- Comments and string literals are in Chinese throughout the codebase.

### Threading
- Discovery callbacks arrive on background GCD queues. UI updates must be dispatched to the main queue. The demo uses the macro `dispatch_main_async_safe(block)` for this.
- `GCDWebServer` dispatches NOTIFY events on its own queue.

## Building

The project uses Xcode project files only — no `Package.swift`, no CocoaPods, no Carthage.

1. Open `DLNAKit/DLNAKit.xcodeproj` to build the framework.
2. Open `DLNADemo/DLNADemo.xcodeproj` (or a workspace linking both) to run the demo.
3. The framework must be built before the demo app can link against it.

**Deployment target:** iOS, `armv7` minimum device capability (legacy devices supported).  
**No Swift** in this project; do not add Swift files unless explicitly requested.

## Testing

There are no automated tests (no XCTest targets, no test schemes). The `DLNADemo` app is the integration test — it runs device discovery and renders discovered devices in a table view. Manual testing requires:
- A DLNA-compatible renderer on the same LAN (smart TV, VLC with UPnP renderer enabled, etc.)
- A physical iOS device or simulator with the same network access

When adding new features, verify behavior against a real DLNA device.

## Common Development Tasks

### Add a new UPnP action

1. Add the SOAP construction in `UPnPActionRequest.m` (follow the pattern of existing actions such as `setAVTransportURI`).
2. Add a public method in the `UPnPManager (ControlPoint)` category in `UPnPManager.h`/`.m`.
3. Optionally add a typed response object (follow `GetTransportInfoResponse` pattern) if the response has multiple named fields.
4. Add a corresponding delegate method to `UPnPControlPointDelegate` if a delegate callback is appropriate.

### Add support for a new service type

1. Identify the service's `serviceType` string (e.g. `urn:schemas-upnp-org:service:AVTransport:1`).
2. The `DeviceDescription` already collects all services into `services: NSArray<Service *>`. Filter by `serviceType` to select the right one.
3. Set `[UPnPManager sharedManager].service = selectedService` before invoking control actions.

### Parse new fields from device/service descriptions

- Use `XMLDictionary` — call `[XMLDictionaryParser dictionaryWithData:data]` to get an `NSDictionary`.
- Key names correspond to XML element names; attributes are under the `__attributes` key.

## Dependencies

All dependencies are embedded in source form — no package manager is required.

| Dependency | Version | License | Location |
|---|---|---|---|
| GCDAsyncUdpSocket | (CocoaAsyncSocket) | MIT | `DLNAKit/DLNAKit/GCDAsyncUdpSocket.*` |
| GCDWebServer | embedded | Apache 2.0 | `DLNAKit/DLNAKit/GCDWebServer/` |
| XMLDictionary | 1.4.1 | Public domain | `DLNAKit/DLNAKit/XMLDictionary.*` |

Do not update these dependencies without testing against multiple real DLNA devices — the networking stack is sensitive to subtle behavioural changes.

## Git Workflow

- Main branch: `master`
- AI-assisted development: use `claude/...` feature branches, push to `origin`, then open a PR to `master`.
- Commit messages should be in English; code comments may remain in Chinese (existing convention).
