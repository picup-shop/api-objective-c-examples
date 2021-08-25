//
//  PKZNNetwork.h
//  api-oc-examples
//
//  Created by Eleven_Liu on 2021/8/23.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKZNNetwork : AFHTTPSessionManager

+ (instancetype)shared;

/**
 *  GET
 */
- (void)getWithUrlString:(NSString *)URLString
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  POST
 */
- (void)postWithUrlString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 * 上传
 */
- (void)uploadFileWithUrlString:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                           data:(NSData *)data
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
