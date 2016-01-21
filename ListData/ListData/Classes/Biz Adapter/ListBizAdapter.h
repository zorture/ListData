//
//  ListBizAdapter.h
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/19/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APISessionManager.h"
#import "ListDataModel.h"
#import "APICacheData.h"

typedef void (^ListBizAdapterCompletionHandler)(ListDataModel* listDM);


@interface ListBizAdapter : NSObject
@property (nonatomic, strong) APICacheData* mCacheData;
@property (nonatomic, copy) ListBizAdapterCompletionHandler completionHandler;
- (void)fetchData:(void (^)(NSArray* data))data;
- (void)fetchImageWithURL:(NSString*)imageURL Image:(void (^)(UIImage* image))imageData;
@end
