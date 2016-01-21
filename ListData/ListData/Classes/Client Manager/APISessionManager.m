//
//  APISessionManager.m
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/16/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import "APISessionManager.h"
#import "APISessionTask.h"

@interface APISessionManager()

@property (nonatomic, strong) NSURLSession* apiSession;
@property (nonatomic, strong) NSURLSessionConfiguration* apiSessionConfig;
@property (nonatomic, strong) NSURLRequest* apiRequest;
@property (nonatomic, strong) NSOperationQueue* apiDelegateQueue;
@property (nonatomic, strong) NSMutableDictionary* apiSessionDict;
@end


@implementation APISessionManager

+ (instancetype)sharedManager {
    static APISessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[self alloc] init];
    });
    return sessionManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.apiSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.apiDelegateQueue = [NSOperationQueue mainQueue];
        self.apiDelegateQueue.maxConcurrentOperationCount = 1;
        self.apiSessionDict = [[NSMutableDictionary alloc] init];
        [self initializeSession];
    }
    return self;
}

- (void)initializeSession{
    
    self.apiSession = [NSURLSession sessionWithConfiguration:self.apiSessionConfig delegate:self delegateQueue:self.apiDelegateQueue];
    
}

- (void)sessionWithRequest:(NSString *)URLString{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDataTask* apiSessionDataTask = [self.apiSession dataTaskWithRequest:request];
    [apiSessionDataTask resume];
    
}


#pragma mark Get Data Task

- (void)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLResponse * response, id responseObject))success
                      failure:(void (^)(NSURLResponse * response, NSError *error))failure
{

    [self GET:URLString APISessionTaskCompletionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(nil, error);
            }
        } else {
            if (success) {
                success(nil, responseObject);
            }
        }
    }];
}


- (void)GET:(NSString *)URLString
    APISessionTaskCompletionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    APISessionTask* sessionTask = [[APISessionTask alloc] init];
    sessionTask.completionHandler = completionHandler;
    
    NSURLSessionDataTask* apiSessionDataTask = [self.apiSession dataTaskWithRequest:request];
    [apiSessionDataTask resume];
    [self.apiSessionDict setObject:sessionTask forKey:[NSString stringWithFormat:@"task%lu",(unsigned long)apiSessionDataTask.taskIdentifier]];
    
    
}

#pragma mark Download Task

- (void)Download:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLResponse * response, NSData* responseObject))success
    failure:(void (^)(NSURLResponse * response, NSError *error))failure
{
    
    [self Download:URLString APISessionTaskCompletionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(nil, error);
            }
        } else {
            if (success) {
                success(nil, responseObject);
            }
        }
    }];
}


- (void)Download:(NSString *)URLString
APISessionTaskCompletionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    APISessionTask* sessionTask = [[APISessionTask alloc] init];
    sessionTask.downloadCompletionHandler = completionHandler;
    
    NSURLSessionDownloadTask* apiSessionDataTask = [self.apiSession downloadTaskWithRequest:request];
    [apiSessionDataTask resume];
    [self.apiSessionDict setObject:sessionTask forKey:[NSString stringWithFormat:@"task%lu",(unsigned long)apiSessionDataTask.taskIdentifier]];
    
    
}

# pragma mark SessionTask Clean

- (void)sessionTaskCleanup:(NSURLSessionTask*)task{
    
    APISessionTask* sessionTask = [self.apiSessionDict objectForKey:[NSString stringWithFormat:@"task%lu",(unsigned long)task.taskIdentifier]];
    if (sessionTask.completionHandler)
        sessionTask.completionHandler = nil;
    if (sessionTask.downloadCompletionHandler)
        sessionTask.downloadCompletionHandler=nil;
    
    [self.apiSessionDict removeObjectForKey:[NSString stringWithFormat:@"task%lu",(unsigned long)task.taskIdentifier]];
    
}

# pragma mark Session Task Delegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    APISessionTask* sessionTask = [self.apiSessionDict objectForKey:[NSString stringWithFormat:@"task%lu",task.taskIdentifier]];
    
    if (sessionTask.downloadCompletionHandler)
        sessionTask.downloadCompletionHandler(nil,nil, error);
    else if (sessionTask.completionHandler)
        sessionTask.completionHandler(nil, nil, error);
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,
                             NSURLCredential *credential))completionHandler{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler{
    completionHandler(request);
}


# pragma mark Session Data Task Delegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    APISessionTask* sessionTask = [self.apiSessionDict objectForKey:[NSString stringWithFormat:@"task%lu",(unsigned long)dataTask.taskIdentifier]];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (sessionTask.completionHandler)
        sessionTask.completionHandler(nil, jsonData, nil);
    [self sessionTaskCleanup:dataTask];
    
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    
}

# pragma mark Session Download Task Delegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    APISessionTask* sessionTask = [self.apiSessionDict objectForKey:[NSString stringWithFormat:@"task%lu",(unsigned long)downloadTask.taskIdentifier]];
    if (sessionTask.downloadCompletionHandler)
        sessionTask.downloadCompletionHandler(nil, [NSData dataWithContentsOfURL:location], nil);
    [self sessionTaskCleanup:downloadTask];
}

@end
