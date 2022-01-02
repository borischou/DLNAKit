# DLNAKit for iOS/Android

基于UPnP的UDP/HTTP/XML协议簇的纯 Objective-C 库

实现了基本DLNA发现设备，查找设备、投放网络视频、播控的UPnP协议

支持同局域网内搜索设备，保存设备列表，网络视频的投放；基本的播放控制：播放、暂停、停止、seek

满足业内普遍长视频点播/直播流媒体投屏业务

与苹果系统镜像功能的区别？
苹果系统镜像功能是对设备屏幕的单纯镜像映射，无法针对开发者指定具体的内容进行投射；而DLNA协议是基于HTTP协议可供传输多内容形式（content-type）的投射能力。

与苹果Airplay的区别？
Airplay与DLNA是对等的功能能力，但Airplay目前仅支持苹果生态范围内的设备业务能力，而DLNA支持的范围是覆盖全操作系统（安卓/iOS/MacOS/Windows/Linux等等），包括移动端、桌面端、智能硬件。
