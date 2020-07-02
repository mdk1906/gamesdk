//
//  OrangeUIImageView+MHImageWebCache.m
//  MHImageWebCache
//
//  Created by Macro on 10/14/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "OrangeUIImageView+MHImageWebCache.h"

@implementation UIImageView (MHImageWebCache)


/*!
 *  @author Macro QQ:778165728, 15-10-14
 *
 *  @brief  加载网络图片
 *
 *  @param urlStr    NSString *: 网络图片地址
 *  @param imageName NSString *: 未加载时的占位图片名
 */
- (void)setWebImageWithUrlStr:(NSString *)urlStr
         placeholderImageName:(NSString *)imageName {
    NSURL *imageURL = [NSURL URLWithString:urlStr];
    [self setWebImageWithUrl:imageURL
        placeholderImageName:imageName];
}

/*!
 *  @author Macro QQ:778165728, 15-10-14
 *
 *  @brief  加载网络图片
 *
 *  @param urlStr    NSString *: 网络图片地址
 */
- (void)setWebImageWithUrlStr:(NSString *)urlStr {
    [self setWebImageWithUrlStr:urlStr
           placeholderImageName:nil];
}

/*!
 *  @author Macro QQ:778165728, 15-11-12
 *
 *  @brief  加载网络图片
 *
 *  @param url       NSURL *: 网络图片地址
 *  @param imageName NSString *: 未加载时的占位图片名
 */
- (void)setWebImageWithUrl:(NSURL *)url
         placeholderImageName:(NSString *)imageName {
    if (imageName) {
        self.image = [UIImage imageNamed:imageName];
    }
    // 通过GCD的方式创建一个新的线程来异步加载图片
    dispatch_queue_t queue =
    dispatch_queue_create("cacheimage", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self downLoadImageWithUrl:url];  //回调
    });
}

/*!
 *  @author Macro QQ:778165728, 15-11-12
 *
 *  @brief  加载网络图片
 *
 *  @param url       NSURL *: 网络图片地址
 */
- (void)setWebImageWithUrl:(NSURL *)url {
    [self setWebImageWithUrl:url placeholderImageName:nil];
}

/*!
 *  @author Macro QQ:778165728, 15-11-12
 *
 *  @brief  下载网络数据 填到主线程UI
 *
 *  @param url 下载地址
 */
- (void)downLoadImageWithUrl:(NSURL *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    // 通知主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imageData) {
            self.image = [UIImage imageWithData:imageData];
        }
    });
}


@end
