//
//  PKZNNetwork.m
//  api-oc-examples
//
//  Created by Eleven_Liu on 2021/8/23.
//

#import "PKZNNetwork.h"

@implementation PKZNNetwork

+ (instancetype)shared {
    static PKZNNetwork *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PKZNNetwork alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        //证件照格式必须设置
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"video/mpeg",@"video/mp4",@"audio/mp3", @"image/png", nil];
        //请登录picup.shop查看你的API密钥
        [manager.requestSerializer setValue:@"账号获取到的APIKEY" forHTTPHeaderField:@"APIKEY"];
    });
    return  manager;
}

- (void)getWithUrlString:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSLog(@"urlString = %@", URLString);
    
    [PKZNNetwork shared].responseSerializer = [AFJSONResponseSerializer serializer];
    [PKZNNetwork shared].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"video/mpeg",@"video/mp4",@"audio/mp3", @"image/png", nil];
    
    NSURLSessionDataTask *dataTask = [[PKZNNetwork shared] GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        failure(error);
    }];
    
    [dataTask resume];
}

- (void)postWithUrlString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSLog(@"urlString = %@", URLString);
    
    [PKZNNetwork shared].responseSerializer = [AFJSONResponseSerializer serializer];
    [PKZNNetwork shared].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"video/mpeg",@"video/mp4",@"audio/mp3", @"image/png", nil];
    
    NSURLSessionDataTask *dataTask = [[PKZNNetwork shared] POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        failure(error);
    }];
    
    [dataTask resume];
}

- (void)uploadFileWithUrlString:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                           data:(NSData *)data
                        success:(nonnull void (^)(id _Nonnull))success
                        failure:(nonnull void (^)(NSError * _Nonnull))failure
{
    if (!data) {
        return;
    }
    
    //根据接口返回的数据类型，设置不同的编码格式
    if ([URLString containsString:@"matting2"]) {
        [PKZNNetwork shared].responseSerializer = [AFJSONResponseSerializer serializer];
    }else {
        [PKZNNetwork shared].responseSerializer = [AFImageResponseSerializer serializer];
    }
    
    [PKZNNetwork shared].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"video/mpeg",@"video/mp4",@"audio/mp3", @"image/png", nil];
    
    NSLog(@"urlString = %@", URLString);
    
    NSURLSessionDataTask *dataTask = [[PKZNNetwork shared] POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        failure(error);
    }];
    
    [dataTask resume];
}

@end
