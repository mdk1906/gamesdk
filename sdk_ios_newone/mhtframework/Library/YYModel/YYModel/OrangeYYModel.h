//
//  OrangeYYModel.h
//  OrangeYYModel <https://github.com/ibireme/OrangeYYModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<OrangeYYModel/OrangeYYModel.h>)
FOUNDATION_EXPORT double YYModelVersionNumber;
FOUNDATION_EXPORT const unsigned char YYModelVersionString[];
#import <OrangeYYModel/NSObject+OrangeYYModel.h>
#import <OrangeYYModel/OrangeYYClassInfo.h>
#else
#import "NSObject+OrangeYYModel.h"
#import "OrangeYYClassInfo.h"
#endif
