//
//  TTInstallBaseMacro.h
//  Article
//
//  Created by panxiang on 15/11/5.
//
//

#ifndef TTInstallBaseMacro_h
#define TTInstallBaseMacro_h

#define WeakSelf __weak typeof(self) wself = self
#define StrongSelf __strong typeof(wself) self = wself

#ifdef DEBUG

#define TTInstallLOGD( s, ... ) NSLog(@"Debug %s: %@", __FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define TTInstallLOGT( s, ... ) NSLog(@"Trace %s: %@", __FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define TTInstallTICK  NSDate *startTime = [NSDate date]
#define TTInstallTOCK  LOGD(@"took time: %f seconds.", -[startTime timeIntervalSinceNow])

#else

#define TTInstallLOGD( s, ... )
#define TTInstallLOGT( s, ... )
#define TTInstallTICK
#define TTInstallTOCK

#endif


#ifndef TTInstallIsEmptyString
#define TTInstallIsEmptyString(str) (!str || ![str isKindOfClass:[NSString class]] || str.length == 0)
#endif

#ifndef TTInstallIsEmptyArray
#define TTInstallIsEmptyArray(array) (!array || ![array isKindOfClass:[NSArray class]] || array.count == 0)
#endif

#ifndef TTInstallIsEmptyDictionary
#define TTInstallIsEmptyDictionary(dict) (!dict || ![dict isKindOfClass:[NSDictionary class]] || ((NSDictionary *)dict).count == 0)
#endif

#endif /* TTInstallBaseMacro_h */
