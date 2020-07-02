//
//  TTTrackerHeader.h
//  Tracker
//
//  Created by fengyadong on 2017-3-14.
//  Copyright (c) 2017 toutiao. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSUInteger kTTTrackerSDKVersion = 204;

/// 事件类型
typedef NS_ENUM (NSInteger,TTTrackType) {
    /// 普通事件
    TTTrackTypeEvent = 1,
    /// launch或者terminate事件
    TTTrackTypeSession = 2
};

/// 事件类型
typedef NS_ENUM(NSInteger,TTTrackEventType) {
    /// 正常事件
    TTTrackNormalEvent = 0,
    /// CDN事件，已废弃
    TTTrackCDNEvent = 1
};

/// 网络状态
typedef NS_ENUM(NSInteger, TTInstallNetworkConnection) {
    /// 初始状态
    TTInstallNetworkNone = -1,
    /// 无网络连接
    TTInstallNetworkNoConnection = 0,
    /// 移动网络连接
    TTInstallNetworkMobileConnnection = 1,
    /// 2G网络连接
    TTInstallNetwork2GConnection = 2,
    /// 3G网络连接
    TTInstallNetwork3GConnection = 3,
    /// wifi网络连接
    TTInstallNetworkWifiConnection = 4,
    /// 4G网络连接
    TTInstallNetwork4GConnection = 5
};

/// 上报策略
typedef NS_ENUM(NSInteger, TTTrackPolicy) {
    /// 初始状态
    TTTrackPolicyNone = -1,
    /// 批量发送，目前都是
    TTTrackPolicyBatch = 1,
    /// 实时发送
    TTTrackPolicyCritical = 2,
};

/// 上报触发场景
typedef NS_ENUM(NSUInteger, TTTrackerCleanerStartCleanFromType) {
    /// app启动触发
    TTTrackerCleanerStartCleanFromInitAppKey,
    /// 定时器触发
    TTTrackerCleanerStartCleanFromTimer,
    /// 切到前台触发
    TTTrackerCleanerStartCleanFromAppWillEnterForground,
    /// 切到后台触发
    TTTrackerCleanerStartCleanFromAppDidEnterBackground,
};

/// APP启动时上报启动原因,wiki: https://wiki.bytedance.com/pages/viewpage.action?pageId=55125960
typedef NS_ENUM(NSUInteger, TTTrackerLaunchFrom) {
    /// 初始状态
    TTTrackerLaunchFromInitialState = 0,
    /// 用户手动点击进入app
    TTTrackerLaunchFromUserClick = 1,
    /// 用户通过push点击进入app
    TTTrackerLaunchFromRemotePush = 2,
    /// 用户通过widget点击进入app
    TTTrackerLaunchFromWidget = 3,
    /// 用户通过sptlight点击进入app
    TTTrackerLaunchFromSpotlight = 4,
    /// 用户通过外部app唤醒进入app
    TTTrackerLaunchFromExternal = 5,
    /// 用户手动切回前台
    TTTrackerLaunchFromBackground = 6,
};

/// url地址类型
typedef NS_ENUM (NSInteger,TTTrackerURLType) {
    /// 日志库配置
    TTTrackerURLTypeConfig = 0,
    /// 日志库批量上报
    TTTrackerURLTypeBatchReport,
    /// 日志库实时上报
    TTTrackerURLTypeImmediateReport
};
