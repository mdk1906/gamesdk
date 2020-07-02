//
//  OrangeGreenFruitNetworking.m
//  OrangeGreenFruitframework
//
//  Created by shuangfei on 2018/1/31.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeGreenFruitNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "OrangeZBCacheManager.h"

#define GreenFruit_ERROR [NSError errorWithDomain:@"com.hGreenFruit.OrangeGreenFruitNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:@"网络出现错误，请检查网络连接"}]

#define TIMEOUT 30.f //请求超时时间
static NSMutableArray   *requestTasksPool;//请求任务池
static NSDictionary     *headers;
static AFNetworkReachabilityStatus networkReachabilityStatus;

@implementation NSURLRequest (decide)

//判断是否是同一个请求（依据是请求url和参数是否相同）
- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"] || [self.HTTPBody isEqualToData:request.HTTPBody]) {
//                NSLog(@"同一个请求还没执行完，又来请求☹️");
                return YES;
            }
        }
    }
    return NO;
}

@end


@interface OrangeGreenFruitNetworking()

@property (assign, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation OrangeGreenFruitNetworking

+ (void)load{
    //开始监听网络
    // 检测网络连接的单例,网络变化时的回调方法
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络状态 : %@", @(status));
        networkReachabilityStatus = status;
    }];
}

+ (instancetype)shaerdInstance{
    static OrangeGreenFruitNetworking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
        requestTasksPool  = [NSMutableArray array];
    });
    
    
    return instance;
}

#pragma mark - manager
- (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    if (!_manager) {

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //默认解析模式
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        
        //配置响应序列化
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
        _manager = manager;
        

    }

    for (NSString *key in headers.allKeys) {

        if (headers[key] != nil) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[OrangeZBCacheManager share_CustomNativeByte_Manager] setCacheTime: diskCapacity:]设置

    [[OrangeZBCacheManager share_CustomNativeByte_Manager] clearLRUCache];
    return _manager;
}

#pragma mark - get
- (GreenFruitURLSessionTask *)getWithUrl:(NSString *)url cache:(BOOL)cache params:(NSDictionary *)params progressBlock:(GreenFruitGetProgress)progressBlock successBlock:(GreenFruitResponseSuccessBlock)successBlock failBlock:(GreenFruitResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block GreenFruitURLSessionTask *session = nil;
    AFHTTPSessionManager *manager = [self manager];
    
    //网络验证
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failBlock) {
            failBlock(GreenFruit_ERROR);
        }
        return session;
    }
    
    id responseObj = [[OrangeZBCacheManager share_CustomNativeByte_Manager] getCacheResponseObjectWithRequestUrl:url params:params];
    if (responseObj && cache) {
        if (successBlock) {
            successBlock(responseObj);
        }
    }
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseManage:responseObject];
        if (successBlock && isValid) {
            successBlock(responseObject);
        }
        if (cache) {
            [[OrangeZBCacheManager share_CustomNativeByte_Manager] cacheResponseObject:responseObject requestUrl:url params:params];
        }
        [requestTasksPool removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [requestTasksPool removeObject:session];
    }];
    
    //判断重复请求，如果有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:session]) {
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        GreenFruitURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [requestTasksPool removeObject:oldTask];
        if (session) [requestTasksPool addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark post
- (GreenFruitURLSessionTask *)postWithUrl:(NSString *)url cache:(BOOL)cache params:(NSDictionary *)params progressBlock:(GreenFruitPostProgress)progressBlock successBlock:(GreenFruitResponseSuccessBlock)successBlock failBlock:(GreenFruitResponseFailBlock)failBlock {
    __block GreenFruitURLSessionTask *session = nil;

    AFHTTPSessionManager *manager = [self manager];
    //****  由于在新加的初始化方法中，网络状态被异常抛出，即在这里注释此代码；
//    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
//        if (failBlock) {
//            failBlock(GreenFruit_ERROR);
//            return session;
//        }
//    }
    
    id responseObj = [[OrangeZBCacheManager share_CustomNativeByte_Manager] getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseManage:responseObject];
        if (successBlock && isValid) successBlock(responseObject);
        if (cache) [[OrangeZBCacheManager share_CustomNativeByte_Manager] cacheResponseObject:responseObject requestUrl:url params:params];
        if ([requestTasksPool containsObject:session]) {
            [requestTasksPool removeObject:session];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [requestTasksPool removeObject:session];
    }];

    //判断重复请求，如果有重复请求，取消新请求
    if ([self haveSameRequestInTasksPool:session]) {
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        GreenFruitURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [requestTasksPool removeObject:oldTask];
        if (session) [requestTasksPool addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark 文件上传
- (GreenFruitURLSessionTask *)uploadFileWithUrl:(NSString *)url fileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progressBlock:(GreenFruitUploadProgressBlock)progressBlock successBlock:(GreenFruitResponseSuccessBlock)successBlock failBlock:(GreenFruitResponseFailBlock)failBlock {
    __block GreenFruitURLSessionTask *session = nil;
    AFHTTPSessionManager *manager = [self manager];
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failBlock) failBlock(GreenFruit_ERROR);
        return session;
    }
    
    session = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);
        [requestTasksPool removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [requestTasksPool removeObject:session];
    }];
    
    
    [session resume];
    if (session) [requestTasksPool addObject:session];
    return session;
}

#pragma mark 多文件上传
- (NSArray *)uploadMultFileWithUrl:(NSString *)url fileDatas:(NSArray *)datas name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeTypes progressBlock:(GreenFruitUploadProgressBlock)progressBlock successBlock:(GreenFruitMultUploadSuccessBlock)successBlock failBlock:(GreenFruitMultUploadFailBlock)failBlock {
    
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failBlock) failBlock(@[GreenFruit_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block GreenFruitURLSessionTask *session = nil;
        dispatch_group_enter(uploadGroup);
        session = [self uploadFileWithUrl:url fileData:datas[i] name:name fileName:fileName mimeType:mimeTypes progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
            if (progressBlock) progressBlock(bytesWritten, totalBytes);
        } successBlock:^(id response) {
            [responses addObject:response];
            dispatch_group_leave(uploadGroup);
            [sessions removeObject:session];
        } failBlock:^(NSError *error) {
            NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
            [failResponse addObject:Error];
            dispatch_group_leave(uploadGroup);
            [sessions removeObject:session];
        }];
        [session resume];
        if (session) [sessions addObject:session];
    }
    
    [requestTasksPool addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [requestTasksPool removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [requestTasksPool removeObjectsInArray:sessions];
                }
            }
        }
    });
    
    return [sessions copy];
}

#pragma mark 下载
- (GreenFruitURLSessionTask *)downloadWithUrl:(NSString *)url progressBlock:(GreenFruitDownloadProgress)progressBlock successBlock:(GreenFruitDownloadSuccessBlock)successBlock failBlock:(GreenFruitDownloadFailBlock)failBlock {
    //    NSString *type = nil;
    //    NSArray *subStringArr = nil;
    __block GreenFruitURLSessionTask *session = nil;
    
    NSURL *fileUrl = [[OrangeZBCacheManager share_CustomNativeByte_Manager] getDownloadDataFromCacheWithRequestUrl:url];
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    //    if (url) {
    //        subStringArr = [url componentsSeparatedByString:@"."];
    //        if (subStringArr.count > 0) {
    //            type = subStringArr[subStringArr.count - 1];
    //        }
    //    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSData *dataObj = (NSData *)responseObject;
            [[OrangeZBCacheManager share_CustomNativeByte_Manager] storeDownloadData:dataObj requestUrl:url];
            NSURL *downFileUrl = [[OrangeZBCacheManager share_CustomNativeByte_Manager] getDownloadDataFromCacheWithRequestUrl:url];
            successBlock(downFileUrl);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock (error);
        }
    }];
    
    [session resume];
    if (session) [requestTasksPool addObject:session];
    return session;
}

#pragma mark - 判断网络请求池中是否有相同的请求
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
- (BOOL)haveSameRequestInTasksPool:(GreenFruitURLSessionTask *)task {
    __block BOOL isSame = NO;
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(GreenFruitURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            isSame  = YES;
            *stop = YES;
        }
    }];
    return isSame;
}


/**
 *  如果有旧请求则取消旧请求
 *  @param task 新请求
 *  @return 旧请求
 */
- (GreenFruitURLSessionTask *)cancleSameRequestInTasksPool:(GreenFruitURLSessionTask *)task {
    __block GreenFruitURLSessionTask *oldTask = nil;
    
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(GreenFruitURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            if (obj.state == NSURLSessionTaskStateRunning) {
                [obj cancel];
                oldTask = obj;
            }
            *stop = YES;
        }
    }];
    
    return oldTask;
}

#pragma mark - other method
- (void)cancleAllRequest {
    @synchronized (self) {
        [requestTasksPool enumerateObjectsUsingBlock:^(GreenFruitURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GreenFruitURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [requestTasksPool removeAllObjects];
    }
}

- (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [requestTasksPool enumerateObjectsUsingBlock:^(GreenFruitURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GreenFruitURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

- (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

- (NSArray *)currentRunningTasks {
    return [requestTasksPool copy];
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
- (BOOL)networkResponseManage:(id)responseObject{
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    //    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"%@",json);
    
    //统一判断所有请求返回状态，例如：强制更新为6，若为6就返回YES，
    int stat = 0;
    switch (stat) {
        case -1:{//强制退出
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消");
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"点击了确定");
            }]];
            
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
            return NO;
        }
            break;
        case -2:{//强制更新
            return NO;
        }
            break;
        case -3:{//弹出对话框
            return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

@end

#pragma mark -
@implementation OrangeGreenFruitNetworking (cache)

- (NSString *)getDownDirectoryPath {
    return [[OrangeZBCacheManager share_CustomNativeByte_Manager] getDownDirectoryPath];
}

- (NSString *)getCacheDiretoryPath {
    return [[OrangeZBCacheManager share_CustomNativeByte_Manager] getCacheDiretoryPath];
}

- (NSUInteger)totalCacheSize {
    return [[OrangeZBCacheManager share_CustomNativeByte_Manager] totalCacheSize];
}

- (NSUInteger)totalDownloadDataSize {
    return [[OrangeZBCacheManager share_CustomNativeByte_Manager] totalDownloadDataSize];
}

- (void)clearDownloadData {
    [[OrangeZBCacheManager share_CustomNativeByte_Manager] clearDownloadData];
}

- (void)clearTotalCache {
    [[OrangeZBCacheManager share_CustomNativeByte_Manager] clearTotalCache];
}

@end
