//
//  APISessionTask.h
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/17/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APISessionManager.h"

typedef void (^APISessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);
typedef void (^APISessionDownloadCompletionHandler)(NSURLResponse *response, NSData* responseObject, NSError *error);

@interface APISessionTask : NSObject

@property (nonatomic, copy) APISessionTaskCompletionHandler completionHandler;
@property (nonatomic, copy) APISessionDownloadCompletionHandler downloadCompletionHandler;

@end
