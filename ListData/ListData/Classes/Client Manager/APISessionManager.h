//
//  APISessionManager.h
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/16/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APISessionManager : NSObject <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

+ (instancetype)sharedManager;

- (void)sessionWithRequest:(NSString *)URLString;

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLResponse * response, id responseObject))success
    failure:(void (^)(NSURLResponse * response, NSError *error))failure;

- (void)Download:(NSString *)URLString
      parameters:(NSDictionary *)parameters
         success:(void (^)(NSURLResponse * response, NSData* responseObject))success
         failure:(void (^)(NSURLResponse * response, NSError *error))failure;


@end
