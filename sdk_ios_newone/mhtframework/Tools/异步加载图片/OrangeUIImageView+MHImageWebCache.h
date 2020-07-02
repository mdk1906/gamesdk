//
//  OrangeUIImageView+MHImageWebCache.h
//  MHImageWebCache
//
//  Created by Macro on 10/14/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MHImageWebCache)

/*!
 *  @author Macro QQ:778165728, 15-10-14
 *
 *  @brief  加载网络图片
 *
 *  @param urlStr    NSString *: 网络图片地址
 *  @param imageName NSString *: 未加载时的占位图片名
 */
- (void)setWebImageWithUrlStr:(NSString *)urlStr
         placeholderImageName:(NSString *)imageName;

/*!
 *  @author Macro QQ:778165728, 15-10-14
 *
 *  @brief  加载网络图片
 *
 *  @param urlStr    NSString *: 网络图片地址
 */
- (void)setWebImageWithUrlStr:(NSString *)urlStr;

/*!
 *  @author Macro QQ:778165728, 15-11-12
 *
 *  @brief  加载网络图片
 *
 *  @param url       NSURL *: 网络图片地址
 *  @param imageName NSString *: 未加载时的占位图片名
 */
- (void)setWebImageWithUrl:(NSURL *)url
      placeholderImageName:(NSString *)imageName;

/*!
 *  @author Macro QQ:778165728, 15-11-12
 *
 *  @brief  加载网络图片
 *
 *  @param url       NSURL *: 网络图片地址
 */
- (void)setWebImageWithUrl:(NSURL *)url;
@end
